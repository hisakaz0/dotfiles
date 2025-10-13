.DEFAULT_GOAL := backup

.PHONY: backup
backup:
	brew bundle dump -f

.PHONY: install
install: install_link install_brew install_other install_mac 

install_link:
	./setup_link.sh

install_brew:
	./setup_brew.sh

install_other:
	./setup_other.sh

install_mac:
	./setup_mac.sh

.PHONY: clean
clean:
	brew bundle cleanup
