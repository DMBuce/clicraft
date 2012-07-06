DIST       := $(DIST) dist/debian
MAINTCLEAN := $(MAINTCLEAN) \
              $(PROG)_$(VERSION)-*_all.deb $(PROG)_$(VERSION).orig.tar.gz \
              $(PROG)_$(VERSION)-*.debian.tar.gz $(PROG)_$(VERSION)-*.dsc \
              $(PROG)_$(VERSION)-*.changes \
              dist/arch/$(VERSION) dist/arch/pkg dist/arch/src \
              dist/arch/$(PROG)-*.pkg.tar.xz dist/arch/$(PROG)-*.src.tar.gz

.PHONY: deb
deb: dist
	mv $(PROG)-$(VERSION).tar.gz $(PROG)_$(VERSION).orig.tar.gz
	cd $(PROG)-$(VERSION) && dpkg-buildpackage

# vim: set ft=make:
