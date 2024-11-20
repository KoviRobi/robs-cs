all: fonts/
	typst compile --font-path fonts/ slides.typ 2>&1 | \
		sed 's|.*@preview/\([^:]*\):\([^/]*\)/|~/.cache/typst/packages/preview/\1/\2/|g'

fonts/: fonts/CaskaydiaCoveNerdFont-Regular.ttf \
        fonts/CaskaydiaCoveNerdFontMono-Regular.ttf \
        fonts/CaskaydiaCoveNerdFontPropo-Regular.ttf

CascadiaCode.zip:
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaCode.zip

fonts/%: CascadiaCode.zip
	unzip -o CascadiaCode.zip -d fonts $*
