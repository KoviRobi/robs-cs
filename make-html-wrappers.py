#!/usr/bin/env python3
import asyncio
import re
import shutil
import typing as t
from asyncio.subprocess import Process
from pathlib import Path

from css_html_js_minify import css_minify, html_minify

# Slides in PATTERN/PATTERN/num.svg structure
DIR_PATTERN = re.compile(r"(?P<num>\d+)-(?P<name>.*)")
FILE_PATTERN = re.compile(r"(?P<num>\d+)\.svg")
IN = Path("svg")
OUT = Path("public")


def titlecase(s: str) -> str:
    return " ".join(w.capitalize() for w in s.split("-"))


stylesheet = """\
.centered {
	margin: auto;
	width: fit-content;
	font-size: calc(max(12pt, max(16vw, 9vh)  / 4));
	border: solid;
	border-radius: 1em;
	padding: 1em 1em 1em 2.2em;
}
li>a {
	color: inherit;
}
li>a:visited {
	color: slategrey;
}
li>a:focus::after {
	content: " ⎆";
	text-decoration: none;
	color: initial;
	line-height: 1;
}
.slide {
	background-color: white;
	width: 100vw;
	height: 100vh;
	object-fit: contain;
	position: fixed;
	top: 0;
	left: 0;
}
.bot-left {
	position: fixed;
	bottom: 0;
	left: 0;
	border-radius: 0 calc(max(16vw, 9vh)  / 8) 0 0;
	border-top: 0.1em solid white;
	border-right: 0.1em solid white;
}
.bot-right {
	position: fixed;
	bottom: 0;
	right: 0;
	border-radius: calc(max(16vw, 9vh)  / 8) 0 0 0;
	border-top: 0.1em solid white;
	border-left: 0.1em solid white;
}
.arrow {
	font-size: calc(max(12pt, max(16vw, 9vh)  / 4));
	line-height: 1;
	padding: calc(max(16vh, 9vh) / 12);
	margin: 0;

	mix-blend-mode: difference;
	background-color: black;
	color: white;

	text-decoration: none;
}
"""

index = """\
<!doctype html>
<html lang="en-GB">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width" />
		<link rel="stylesheet" href="stylesheet.css" />
		<link rel="preconnect" href="https://fonts.googleapis.com" />
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
		<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Emoji&family=Noto+Sans+Symbols&family=Noto+Sans+Symbols+2" />
		<title>Rob's CS &ndash; Index</title>
		<style>
body {{
	color: black;
	mix-blend-mode: difference;
}}
@media (prefers-color-scheme: dark) {{
	body {{
		background-color: black;
		color: white;
	}}
}}
		</style>
	</head>
	<body>
		<ol class="centered" id="navigation">{links}</ol>
		<script type="text/javascript">
function until(value, predicate, next, limit) {{
	limit = limit || 100;
	next = next || predicate;
	var i = 0;
	while (value &&
		(!predicate || !predicate(value)) &&
		(!next || next(value)) &&
		limit--) {{
		value = next(value);
	}}
	let p = predicate(value);
	return p || value;
}}
let prev_el = e => e?.previousElementSibling;
let next_el = e => e?.nextElementSibling;
let is_link = e => e?.tagName == "A" ? e : null;
let first_link = e => e?.getElementsByTagName?.("A")?.[0];
let last_link = e => {{
	let links = e?.getElementsByTagName?.("A");
	return links && links?.[links.length - 1];
}};
let last_el = e => e?.lastElementChild;
let first_el = e => e?.firstElementChild;
let parent_el = e => e?.parentElement;
document.addEventListener('keydown', event =>
	event.key == "ArrowRight" ? document?.activeElement?.click?.()
	: event.key == "ArrowUp" ? until(
			until(document.activeElement, is_link, parent_el),
			last_link,
			e => until(e, prev_el, parent_el)
		)?.focus?.()
	: event.key == "ArrowDown" ?
		until(
			until(document.activeElement, is_link, parent_el),
			first_link,
			e => until(e, next_el, parent_el)
		)?.focus?.()
	: undefined);
document.addEventListener('focus', event => {{
	const url = new URLSearchParams(window.location.search);
	const id = url.get("focus");
	const element = document.getElementById(id);
	element?.focus();
}});
		</script>
	</body>
</html>
"""

slide_fmt = """\
<!doctype html>
<html lang="en-GB">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width" />
		<title>Rob's CS &ndash; {title}</title>
		<link rel="preload"    href="{root}/stylesheet.css" as="style" />
		<link rel="preload"    href="{svg}" as="image" />
		<link rel="stylesheet" href="{root}/stylesheet.css" />
		<link rel="preconnect" href="https://fonts.googleapis.com" />
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
		<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Emoji&family=Noto+Sans+Symbols&family=Noto+Sans+Symbols+2" />
		<style>
body {{
	mix-blend-mode: difference;
}}
@media (prefers-color-scheme: dark) {{
	body {{
		background-color: white;
	}}
}}
		</style>
	</head>
	<body>
		<img class="slide" src="{svg}" defer />
		{prev}
		{next}
		<script type="text/javascript">
document.addEventListener('keydown', event =>
	document.getElementById(event.key)?.click?.());
		</script>
	</body>
</html>
"""


def prev_link(i, root, slideset, target):
    if i > 1:
        return f'<a id="ArrowLeft"  class="bot-left arrow"  href="{target}">⮈</a>'
    return f'<a id="ArrowUp"  class="bot-left arrow"  href="{root}/index.html?focus=slideset{slideset}">⮉</a>'


def next_link(i, end, root, slideset, target):
    if i < end:
        return f'<a id="ArrowRight" class="bot-right arrow" href="{target}">⮊</a>'
    return f'<a id="ArrowUp"  class="bot-right arrow"  href="{root}/index.html?focus=slideset{slideset + 1}">⮉</a>'


def find_slides() -> list[tuple[tuple[re.Match], list[int]]]:
    slides: dict[tuple[re.Match], list[int]] = {}
    for dirname, dirs, files in IN.walk():
        dirs[:] = [dir for dir in dirs if DIR_PATTERN.match(dir)]
        partsmatch = tuple(
            DIR_PATTERN.match(part) for part in dirname.relative_to(IN).parts
        )
        if all(partsmatch):
            partsmatch = t.cast(tuple[re.Match], partsmatch)
            nums: list[int] = []
            for file in files:
                match = FILE_PATTERN.match(file)
                if match:
                    nums.append(int(match["num"]))
            if nums != []:
                slides[partsmatch] = nums
    return list(
        sorted(
            slides.items(),
            key=lambda kv: tuple(int(part["num"]) for part in kv[0]),
        )
    )


async def amain():
    OUT.mkdir(parents=True, exist_ok=True)
    slides = find_slides()

    # For stripping SVGs
    scour = shutil.which("scour")
    assert scour
    scours: list[Process] = []

    oldpath = Path(".")
    contents = ""
    slideset = 0
    for dirs, nums in slides:
        path = Path(*(dir[0] for dir in dirs))
        common = sum(o == d for o, d in zip(oldpath.parts, path.parts))
        contents += "</ol>" * max(0, len(oldpath.parts) - common - 1)
        for i in range(len(path.parts) - common - 1):
            contents += f'<li>{titlecase(dirs[i]["name"])}</li><ol>'
        title = titlecase(dirs[-1]["name"])
        contents += (
            f'<li><a id="slideset{slideset}" href="{path}/1.html">{title}</a></li>'
        )
        oldpath = path
        #
        end = max(nums)
        (OUT / path).mkdir(parents=True, exist_ok=True)
        for i in nums:
            scours.append(
                await asyncio.subprocess.create_subprocess_exec(
                    scour,
                    "-i",
                    str(IN / path / f"{i}.svg"),
                    "-o",
                    str(OUT / path / f"{i}.svg"),
                    "--enable-viewboxing",
                    "--enable-id-stripping",
                    "--enable-comment-stripping",
                    "--shorten-ids",
                    "--indent=none",
                )
            )
            html = OUT / path / f"{i}.html"
            root = "../" * max(0, len(html.parts) - len(OUT.parts) - 1)
            root = root.rstrip("/")
            html.write_text(
                html_minify(
                    slide_fmt.format(
                        title=title,
                        root=root,
                        svg=f"{i}.svg",
                        prev=prev_link(i, root, slideset, f"{i-1}.html"),
                        next=next_link(i, end, root, slideset, f"{i+1}.html"),
                    )
                ),
            )
        slideset += 1
    contents += "</ol>" * len(oldpath.parts)

    (OUT / "index.html").write_text(html_minify(index.format(links=contents)))
    (OUT / "stylesheet.css").write_text(css_minify(stylesheet))
    return max(await asyncio.gather(*(scour.wait() for scour in scours)))


if __name__ == "__main__":
    exit(asyncio.run(amain()))
