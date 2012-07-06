DIST     := $(DIST) dist/debian

.PHONY: deb
deb: dist
	mv $(PROG)-$(VERSION).tar.gz $(PROG)_$(VERSION).orig.tar.gz
	cd $(PROG)-$(VERSION) && dpkg-buildpackage

# vim: set ft=make:
