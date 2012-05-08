SCRIPTS_INSTALL := $(DESTDIR)$(sysconfdir)/bash_completion.d/$(PROG)
ifeq ($(WITH_C10T), yes)
SCRIPTS_INSTALL := $(SCRIPTS_INSTALL) $(DESTDIR)$(CONFDIR)/action.d/map.sh
endif
ifeq ($(WITH_MCEXPLORE), yes)
SCRIPTS_INSTALL := $(SCRIPTS_INSTALL) $(DESTDIR)$(CONFDIR)/action.d/explore.sh
endif



TGT_INSTALL := $(TGT_INSTALL) scripts-install
DIST        := $(DIST) scripts
DISTCLEAN   := $(DISTCLEAN) scripts/bash_completion

INSTALLDIRS := $(INSTALLDIRS) \
               $(DESTDIR)${sysconfdir}/bash_completion.d
               #$(DESTDIR)${CONFDIR}/action.d
               # ^ already provided by src/Makefile.inc

UNINSTALL := $(UNINSTALL) $(SCRIPTS_INSTALL)



# install scripts

$(DESTDIR)$(CONFDIR)/action.d/%.sh: scripts/%.sh
	$(INSTALL_DATA) $< $@

# install bash completion

$(DESTDIR)$(sysconfdir)/bash_completion.d/$(PROG): scripts/bash_completion
	$(INSTALL_DATA) $< $@



# phony targets

.PHONY: scripts-install
scripts-install: $(SCRIPTS_INSTALL)

# vim: set ft=make:
