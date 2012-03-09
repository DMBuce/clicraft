TGT_INSTALL := $(TGT_INSTALL) scripts-install
DIST := $(DIST) scripts

INSTALLDIRS := $(INSTALLDIRS) \
	$(DESTDIR)${sysconfdir}/bash_completion.d \
	$(DESTDIR)${CONFDIR}/action.d

UNINSTALL := $(UNINSTALL) \
	$(DESTDIR)${sysconfdir}/bash_completion.d/$(PROG) \
	$(DESTDIR)${CONFDIR}/action.d/map.sh \
	$(DESTDIR)${CONFDIR}/action.d/explore.sh

.PHONY: scripts-install
scripts-install:
	$(INSTALL_DATA) scripts/bash_completion $(DESTDIR)${sysconfdir}/bash_completion.d/$(PROG)

ifeq ($(WITH_C10T), yes)
	$(INSTALL_DATA) scripts/map.sh          $(DESTDIR)${CONFDIR}/action.d/map.sh
endif

ifeq ($(WITH_MCEXPLORE), yes)
	$(INSTALL_DATA) scripts/explore.sh      $(DESTDIR)${CONFDIR}/action.d/explore.sh
endif

# vim: set ft=make:
