RELEASE := 1

.PHONY: deb
deb: all
	make DESTDIR="${PWD}/dist/deb" install
	which dpkg
	fakeroot dpkg --build dist/deb clicraft_$(VERSION)-$(RELEASE)_all.deb

# vim: set ft=make:
