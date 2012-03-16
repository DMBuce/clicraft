RELEASE := 1

.PHONY: deb
deb: all
	make DESTDIR="${PWD}/dist/deb" install
	find dist/deb/etc -type f | sed 's#^dist/deb##' >dist/deb/DEBIAN/conffiles
	which dpkg
	fakeroot dpkg --build dist/deb clicraft_$(VERSION)-$(RELEASE)_all.deb

# vim: set ft=make:
