.DEFAULT_GOAL := backup

.PHONY: backup
backup:
	brew bundle dump -f

.PHONY: install
install:
	./setup.sh

.PHONY: clean
clean:
	brew bundle cleanup
