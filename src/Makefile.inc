SRC_BINFILES  := src/bin/clicraft
SRC_EXECFILES := src/lib/functions.sh src/lib/defaults.sh \
                 $(wildcard src/lib/action.d/*.sh)
SRC_CONFFILES := src/etc/clicraft-defaults.conf \
                 $(wildcard src/etc/action.d/*.sh.example)

SRC_BINFILES_INSTALL  := $(SRC_BINFILES:src/bin/%=$(DESTDIR)$(bindir)/%)
SRC_EXECFILES_INSTALL := $(SRC_EXECFILES:src/lib/%=$(DESTDIR)$(EXECDIR)/%)
SRC_CONFFILES_INSTALL := $(SRC_CONFFILES:src/etc/%=$(DESTDIR)$(CONFDIR)/%)

SRC_FILES_INSTALL := $(SRC_BINFILES_INSTALL) \
                     $(SRC_EXECFILES_INSTALL) \
                     $(SRC_CONFFILES_INSTALL)



TGT_INSTALL := $(TGT_INSTALL) src-install
DIST        := $(DIST) src

DISTCLEAN   := $(DISTCLEAN) \
               src/bin/clicraft \
               src/lib/defaults.sh \
               src/etc/clicraft-defaults.conf

INSTALLDIRS := $(INSTALLDIRS) \
               $(DESTDIR)${bindir} \
               $(DESTDIR)${CONFDIR}/action.d \
               $(DESTDIR)${EXECDIR}/action.d \
               $(DESTDIR)${SERVER_DIR}

UNINSTALL := $(UNINSTALL) $(SRC_FILES_INSTALL)



# install files

$(DESTDIR)$(bindir)/%: src/bin/%
	$(INSTALL_PROGRAM) $< $@

$(DESTDIR)$(EXECDIR)/%: src/lib/%
	$(INSTALL_DATA) $< $@

$(DESTDIR)$(EXECDIR)/action.d/%.sh: src/lib/action.d/%.sh
	$(INSTALL_DATA) $< $@

$(DESTDIR)$(CONFDIR)/%: src/etc/%
	$(INSTALL_DATA) $< $@

$(DESTDIR)$(CONFDIR)/action.d/%.sh.example: src/etc/action.d/%.sh.example
	$(INSTALL_DATA) $< $@



# phony targets

.PHONY: src-install
src-install: $(SRC_FILES_INSTALL)
	
# vim: set ft=make:
