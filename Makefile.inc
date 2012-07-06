
# get filled by Makefile.inc files
TGT_TARGETS :=
CLEAN       :=
TGT_INSTALL :=
INSTALLDIRS :=
UNINSTALL   :=
DIST        := configure install-sh Makefile.in Makefile.inc \
               INSTALL LICENSE README.asciidoc
DISTCLEAN   := Makefile config.log config.status
MAINTCLEAN  := autom4te.cache $(PROG)-$(VERSION) $(PROG)-$(VERSION).tar.gz

.PHONY: all
all: targets

include scripts/Makefile.inc
include src/Makefile.inc
include dist/Makefile.inc
include doc/Makefile.inc

.PHONY: targets
targets: $(TGT_TARGETS)

.PHONY: clean
clean:
	rm -f $(CLEAN)

.PHONY: install
install: $(TGT_INSTALL)

$(TGT_INSTALL): installdirs

.PHONY: installdirs
installdirs: $(INSTALLDIRS)

$(INSTALLDIRS):
	$(INSTALL) -d $@

.PHONY: uninstall
uninstall:
	rm -f $(UNINSTALL)

.PHONY: dist
dist:
	autoconf
	rm -rf $(PROG)-$(VERSION)
	mkdir $(PROG)-$(VERSION)
	cp -r $(DIST) $(PROG)-$(VERSION)
	rm -f $(PROG)-$(VERSION)/debian/post*
	sed -i '/include dist\/Makefile.inc/d' $(PROG)-$(VERSION)/Makefile.inc
	tar czf $(PROG)-$(VERSION).tar.gz $(PROG)-$(VERSION)

.PHONY: distclean
distclean: clean
	rm -f $(DISTCLEAN)

.PHONY: maintainer-clean
maintainer-clean: clean distclean
	@echo 'This command is intended for maintainers to use; it'
	@echo 'deletes files that may need special tools to rebuild.'
	rm -rf $(MAINTCLEAN)

tags: distclean
	ctags -R
	ctags -a --language-force=Sh   `find . -name \*.in`
	ctags -a --language-force=Make `find . -name \*.inc` Makefile.in

.SECONDARY: $(CLEAN) $(UNINSTALL)

# vim: set ft=make:
