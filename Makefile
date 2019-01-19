PREFIX?=/usr/local
INSTALL_NAME = xcode-scheme-sort

install: build install_binary

build:
	mkdir -p .build
	swiftc -o .build/$(INSTALL_NAME) main.swift

install_binary:
	mkdir -p $(PREFIX)/bin
	install .build/$(INSTALL_NAME) $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/$(INSTALL_NAME)

clean:
	rm -Rf .build