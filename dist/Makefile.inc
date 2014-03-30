DIST       := $(DIST) dist/debian
MAINTCLEAN := $(MAINTCLEAN) \
              dist/$(PROG)_$(VERSION)-*_all.deb dist/$(PROG)_$(VERSION).orig.tar.gz \
              dist/$(PROG)_$(VERSION)-*.debian.tar.gz dist/$(PROG)_$(VERSION)-*.dsc \
              dist/$(PROG)_$(VERSION)-*.changes
RPMDIRS    := dist/rpmbuild/BUILD \
              dist/rpmbuild/RPMS \
              dist/rpmbuild/SOURCES \
              dist/rpmbuild/SPECS \
              dist/rpmbuild/SRPMS

.PHONY: dist
dist: dist/$(PROG)-$(VERSION).tar.gz

dist/$(PROG)-$(VERSION).tar.gz: dist/$(PROG)-$(VERSION)
	cd dist && tar czf $(PROG)-$(VERSION).tar.gz $(PROG)-$(VERSION)

dist/$(PROG)-$(VERSION):
	autoconf
	rm -rf dist/$(PROG)-$(VERSION)
	mkdir dist/$(PROG)-$(VERSION)
	cp -r $(DIST) dist/$(PROG)-$(VERSION)
	rm -f dist/$(PROG)-$(VERSION)/debian/post*
	sed -i '/include dist\/Makefile.inc/d' dist/$(PROG)-$(VERSION)/Makefile.inc

.PHONY: distclean
distclean: clean
	rm -f $(DISTCLEAN)

dist/$(PROG)_$(VERSION).orig.tar.gz: dist/$(PROG)-$(VERSION).tar.gz
	cp $< $@

dist/rpmbuild/SOURCES/$(PROG)-$(VERSION)-src.tar.gz: dist/$(PROG)-$(VERSION).tar.gz
	cp $< $@

dist/rpmbuild/SPECS/clicraft.spec: dist/rhel/clicraft.spec
	sed "/^Release:/ s/ .*%/ `git describe | sed 's/[^-]*//; s/-/r/; s/-/./; s/^$$/1/'`%/" \
		$< > $@

# sudo apt-get install autoconf make devscripts asciidoc
.PHONY: deb
deb: debchange dist/$(PROG)_$(VERSION).orig.tar.gz
	cd dist/$(PROG)-$(VERSION) && dpkg-buildpackage

.PHONY: debchange
debchange:
	cd dist \
		&& grep `git describe | sed 's/-/-r/; s/-/./2'` debian/changelog \
		|| debchange -v `git describe | sed 's/-/-r/; s/-/./2'` \
		&& grep `git describe | sed 's/-/-r/; s/-/./2'` debian/changelog

.PHONY: rpm
rpm: rpmdirs dist/rpmbuild/SPECS/clicraft.spec dist/rpmbuild/SOURCES/$(PROG)-$(VERSION)-src.tar.gz
	rpmbuild -ba \
		--define "_query_all_fmt %{name}-%{version}-%{release}.%{arch}" \
		--define "_topdir $(PWD)/dist/rpmbuild" \
		dist/rpmbuild/SPECS/clicraft.spec
	mv dist/rpmbuild/RPMS/noarch/$(PROG)-$(VERSION)-*.noarch.rpm dist/
	mv dist/rpmbuild/SRPMS/$(PROG)-$(VERSION)-*.src.rpm dist/

.PHONY: rpmdirs
rpmdirs: $(RPMDIRS)

$(RPMDIRS):
	$(INSTALL) -d $@

# vim: set ft=make:
