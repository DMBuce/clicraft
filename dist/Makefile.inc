DIST       := $(DIST) dist/debian
MAINTCLEAN := $(MAINTCLEAN) \
              $(PROG)_$(VERSION)-*_all.deb $(PROG)_$(VERSION).orig.tar.gz \
              $(PROG)_$(VERSION)-*.debian.tar.gz $(PROG)_$(VERSION)-*.dsc \
              $(PROG)_$(VERSION)-*.changes \
              dist/arch/$(VERSION) dist/arch/pkg dist/arch/src \
              dist/arch/$(PROG)-*.pkg.tar.xz dist/arch/$(PROG)-*.src.tar.gz
RPMDIRS    := rpmbuild/BUILD \
              rpmbuild/RPMS \
              rpmbuild/SOURCES \
              rpmbuild/SPECS \
              rpmbuild/SRPMS

$(PROG)_$(VERSION).orig.tar.gz: $(PROG)-$(VERSION).tar.gz
	cp $< $@

rpmbuild/SOURCES/$(PROG)-$(VERSION)-src.tar.gz: $(PROG)-$(VERSION).tar.gz
	cp $< $@

rpmbuild/SPECS/clicraft.spec: dist/rhel/clicraft.spec
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

.PHONY: rpm
rpm: dist rpmdirs rpmbuild/SPECS/clicraft.spec rpmbuild/SOURCES/$(PROG)-$(VERSION)-src.tar.gz
	rpmbuild -ba \
		--define "_query_all_fmt %{name}-%{version}-%{release}.%{arch}" \
		--define "_topdir $(PWD)/rpmbuild" \
		rpmbuild/SPECS/clicraft.spec

.PHONY: rpmdirs
rpmdirs: $(RPMDIRS)

$(RPMDIRS):
	$(INSTALL) -d $@

# vim: set ft=make:
