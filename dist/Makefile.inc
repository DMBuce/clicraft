DIST       := $(DIST) dist/debian
MAINTCLEAN := $(MAINTCLEAN) \
              $(PROG)_$(VERSION)-*_all.deb $(PROG)_$(VERSION).orig.tar.gz \
              $(PROG)_$(VERSION)-*.debian.tar.gz $(PROG)_$(VERSION)-*.dsc \
              $(PROG)_$(VERSION)-*.changes \
              dist/arch/$(VERSION) dist/arch/pkg dist/arch/src \
              dist/arch/$(PROG)-*.pkg.tar.xz dist/arch/$(PROG)-*.src.tar.gz

$(PROG)_$(VERSION).orig.tar.gz: $(PROG)-$(VERSION).tar.gz
	cp $< $@

# sudo apt-get install autoconf make devscripts asciidoc
.PHONY: deb
deb: dist debchange $(PROG)_$(VERSION).orig.tar.gz
	cd $(PROG)-$(VERSION) && dpkg-buildpackage

.PHONY: debchange
debchange:
	cd dist \
		&& grep `git describe | sed 's/-/-r/; s/-/./2'` debian/changelog \
		|| debchange -v `git describe | sed 's/-/-r/; s/-/./2'` \
		&& grep `git describe | sed 's/-/-r/; s/-/./2'` debian/changelog

# vim: set ft=make:
