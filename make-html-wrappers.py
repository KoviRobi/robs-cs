#!/usr/bin/env python3

import re
from pathlib import Path
from subprocess import run


# Slides in PATTERN/PATTERN.typ structure
PATTERN = re.compile(r"(?P<num>\d+)-(?P<name>.*)")
EXT = ".typ"
IN = Path("slides")
OUT = Path("public")


def titlecase(s: str) -> str:
    return " ".join(w.capitalize() for w in s.split("-"))


code = """\
document.addEventListener('keydown', event =>
	document.getElementById(event.key)?.click?.())
"""

stylesheet = """\
.centered {
	margin: auto;
	width: fit-content;
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
	font-size: calc(max(16vw, 9vh)  / 4);
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
		<title>Rob's CS &ndash; Index</title>
		<style>
body {{
	background-color: white;
	color: black;
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
		<ol class="centered">{links}</ol>
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
		<link rel="preload"    href="code.js"        as="script" />
		<link rel="preload"    href="stylesheet.css" as="style" />
		<link rel="preload"    href="{svg}"          as="image" />
		<link rel="stylesheet" href="stylesheet.css" />
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
		<img class="slide" src="{svg}" />
		{prev}
		{next}
		<script src="code.js" defer></script>
	</body>
</html>
"""


def prev(i, target):
    if i > 1:
        return f'<a id="ArrowLeft"  class="bot-left arrow"  href="{target}">⮈</a>'
    return '<a id="ArrowUp"  class="bot-left arrow"  href="index.html">⮉</a>'


def next(i, target):
    if i < len(svgs):
        return f'<a id="ArrowRight" class="bot-right arrow" href="{target}">⮊</a>'
    return '<a id="ArrowUp"  class="bot-right arrow"  href="index.html">⮉</a>'


def find_slides() -> list[tuple[re.Match]]:
    slides = []
    for dirname, dirs, files in IN.walk():
        dirs[:] = [dir for dir in dirs if PATTERN.match(dir)]
        partsmatch = [PATTERN.match(part) for part in dirname.relative_to(IN).parts]
        if all(partsmatch):
            for file in files:
                match = PATTERN.match(file)
                if match and file.endswith(EXT):
                    slides.append((*partsmatch, match))
    slides.sort(key=lambda matches: tuple(int(match["num"]) for match in matches))
    return slides


OUT.mkdir(parents=True, exist_ok=True)

slides = find_slides()
olddirs = []
toc = ""
for slide in slides:
    path = "/".join(m[0] for m in slide)
    dirs = slide[:-1]
    file = slide[-1]
    base = file[0].removesuffix(EXT)
    name = file["name"].removesuffix(EXT)
    title = titlecase(name)
    common = sum(o == d for o, d in zip(olddirs, dirs))
    toc += "</ol>" * (len(olddirs) - common)
    for i in range(len(dirs) - common):
        toc += f"<li>{titlecase(dirs[i]["name"])}</li><ol>"
    olddirs = dirs
    toc += f'<li><a href="{base}-01.html">{title}</a></li>'
    #
    run(["typst", "compile", IN / path, OUT / (base + "-{0p}.svg")])
    svgs = list(sorted(OUT.glob(base + "-??.svg")))
    for i, svg in enumerate(svgs, 1):
        svgz = svg.with_suffix(".svgz")
        run(
            [
                "scour",
                "-i",
                svg,
                "-o",
                svgz,
                "--enable-viewboxing",
                "--enable-id-stripping",
                "--enable-comment-stripping",
                "--shorten-ids",
                "--indent=none",
            ]
        )
        svg.with_suffix(".html").write_text(
            slide_fmt.format(
                title=title,
                svg=svgz.relative_to(OUT),
                prev=prev(i, f"{base}-{i-1:02}.html"),
                next=next(i, f"{base}-{i+1:02}.html"),
            ),
        )
toc += "</ol>" * len(olddirs)

(OUT / "index.html").write_text(index.format(links=toc))
(OUT / "stylesheet.css").write_text(stylesheet)
(OUT / "code.js").write_text(code)
