
# get filled by Makefile.inc files
TGT_TARGETS :=
CLEAN       :=
TGT_INSTALL :=
INSTALLDIRS :=
UNINSTALL   :=
DIST        := configure install-sh Makefile.in Makefile.inc \
               INSTALL LICENSE README.asciidoc
DISTCLEAN   := Makefile config.log config.status
MAINTCLEAN  := autom4te.cache

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
