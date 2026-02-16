.PHONY: publish

publish:
	quarto render --profile book
	quarto render
	ghp-import -p _site
