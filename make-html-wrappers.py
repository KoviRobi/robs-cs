#!/usr/bin/env python3
from __future__ import annotations

import asyncio
import re
import shutil
import typing as t
from asyncio.subprocess import Process
from pathlib import Path
from dataclasses import dataclass

from css_html_js_minify import css_minify, html_minify

# Topics in PATTERN/PATTERN/num.svg structure
DIR_PATTERN = re.compile(
    r"(?P<id>(?P<appendix>appendix-)?(?P<num>\d+))-(?P<name>.*)|(?P<index>index)"
)
FILE_PATTERN = re.compile(r"(?P<num>\d+)\.svg")
IN = Path("svg")
OUT = Path("public")


stylesheet = """\
.centered li::marker {
	content: "";
}
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
	font-family: "Noto Sans Symbols";
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
	font-family: "Noto Sans Symbols 2";
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
		<menu class="centered" id="navigation">{links}</menu>
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


def titlecase(s: str) -> str:
    return " ".join(w.capitalize() for w in s.split("-"))


@dataclass
class DirPattern:
    """
    Represents a fragment of a table-of-contents path, e.g. one of the items in
    ["section 1 'Foo'", "subsection 2 'Bar'"]
    """

    appendix: bool
    num: int
    title: str

    @classmethod
    def from_match(cls, match: re.Match[str]) -> DirPattern:
        "Returns DirPattern from a DIR_PATTERN match"
        return DirPattern(
            appendix=bool(match["appendix"]),
            num=int(match["num"]),
            title=titlecase(match["name"] or ""),
        )

    def __lt__(self, other: DirPattern) -> bool:
        return (self.appendix == other.appendix and self.num < other.num) or (
            not self.appendix and other.appendix
        )

    def __eq__(self, other) -> bool:
        return self.appendix == other.appendix and self.num == other.num

    def to_html(self, id: str | None = None, link: None | Path = None) -> str:
        ret = "<li>"
        if self.appendix:
            ret += "Appendix "
            counter = ""
            num = self.num - 1
            while True:
                counter = chr(ord("A") + num % 26) + counter
                num = num // 26
                if num == 0:
                    break
            ret += f"{counter}. "
        else:
            ret += f"{self.num}. "
        if link is not None:
            ret += f'<a id="{id}" href="{link}">'
        ret += self.title
        if link is not None:
            ret += "</a>"
        ret += "</li>"
        return ret


@dataclass
class Topic:
    path: Path
    parts: list[DirPattern]
    slides: list[int]

    @classmethod
    def match(cls, path: Path) -> Topic | None:
        matches = [DIR_PATTERN.match(part) for part in path.parts]
        if all(matches):
            matches = t.cast(list[re.Match[str]], matches)
            return Topic(
                path=path,
                parts=[
                    DirPattern.from_match(match)
                    for match in matches
                    if not match["index"]
                ],
                slides=[],
            )

    def __lt__(self, other) -> bool:
        return self.parts < other.parts

    def __eq__(self, other) -> bool:
        return self.parts == other.parts


def prev_link(i, root, slideset, target):
    if i > 1:
        return f'<a id="ArrowLeft"  class="bot-left arrow"  href="{target}">⮈</a>'
    return f'<a id="ArrowUp"  class="bot-left arrow"  href="{root}/index.html?focus=slideset{slideset}">⮉</a>'


def next_link(i, end, root, slideset, target):
    if i < end:
        return f'<a id="ArrowRight" class="bot-right arrow" href="{target}">⮊</a>'
    return f'<a id="ArrowUp"  class="bot-right arrow"  href="{root}/index.html?focus=slideset{slideset + 1}">⮉</a>'


def find_topics() -> list[Topic]:
    topics: list[Topic] = []
    for dirname, dirs, files in IN.walk():
        dirs[:] = [dir for dir in dirs if DIR_PATTERN.match(dir)]
        if topic := Topic.match(dirname.relative_to(IN)):
            topic.slides = [
                int(match["num"])
                for file in files
                if (match := FILE_PATTERN.match(file))
                if match["num"]
            ]
            if topic.slides != []:
                topics.append(topic)
    topics.sort()
    return topics


async def amain():
    OUT.mkdir(parents=True, exist_ok=True)
    topics = find_topics()

    # For stripping SVGs
    scour = shutil.which("scour")
    assert scour
    scours: list[Process] = []

    oldparts = []
    contents = ""
    slideset = 0
    for topic in topics:
        common = sum(o == d for o, d in zip(oldparts, topic.parts))
        contents += "</menu>" * max(0, len(oldparts) - common - 1)
        for i in range(len(topic.parts) - common - 1):
            contents += topic.parts[i].to_html() + "<menu>"
        contents += topic.parts[-1].to_html(
            f"slideset{slideset}", topic.path / f"{min(topic.slides)}.html"
        )
        oldparts = topic.parts
        #
        end = max(topic.slides)
        (OUT / topic.path).mkdir(parents=True, exist_ok=True)
        for i in topic.slides:
            scours.append(
                await asyncio.subprocess.create_subprocess_exec(
                    scour,
                    "-i",
                    str(IN / topic.path / f"{i}.svg"),
                    "-o",
                    str(OUT / topic.path / f"{i}.svg"),
                    "--enable-viewboxing",
                    "--enable-id-stripping",
                    "--enable-comment-stripping",
                    "--shorten-ids",
                    "--indent=none",
                )
            )
            html = OUT / topic.path / f"{i}.html"
            root = "../" * max(0, len(html.parts) - len(OUT.parts) - 1)
            root = root.rstrip("/")
            html.write_text(
                html_minify(
                    slide_fmt.format(
                        title=topic.parts[-1].title,
                        root=root,
                        svg=f"{i}.svg",
                        prev=prev_link(i, root, slideset, f"{i-1}.html"),
                        next=next_link(i, end, root, slideset, f"{i+1}.html"),
                    )
                ),
            )
        slideset += 1
    contents += "</menu>" * len(oldparts)

    (OUT / "index.html").write_text(html_minify(index.format(links=contents)))
    (OUT / "stylesheet.css").write_text(css_minify(stylesheet))
    if scours == []:
        return 0
    else:
        return max(await asyncio.gather(*(scour.wait() for scour in scours)))


if __name__ == "__main__":
    exit(asyncio.run(amain()))
