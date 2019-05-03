unix:
	stack build && sudo cp $(shell stack path --local-install-root)/bin/sae /usr/local/bin