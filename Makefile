all:
	typst c slides.typ 2>&1 | grep -v '@preview'
