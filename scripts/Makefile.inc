SCRIPTS_INSTALL := $(DESTDIR)$(sysconfdir)/bash_completion.d/$(PROG) \
                   $(DESTDIR)$(sysconfdir)/logrotate.d/$(PROG) \
                   $(DESTDIR)$(sysconfdir)/cron.d/$(PROG)
ifeq ($(WITH_C10T), yes)
SCRIPTS_INSTALL := $(SCRIPTS_INSTALL) $(DESTDIR)$(CONFDIR)/action.d/map.sh
endif
ifeq ($(WITH_MCEXPLORE), yes)
SCRIPTS_INSTALL := $(SCRIPTS_INSTALL) $(DESTDIR)$(CONFDIR)/action.d/explore.sh
endif
ifeq ($(WITH_MMAT), yes)
SCRIPTS_INSTALL := $(SCRIPTS_INSTALL) $(DESTDIR)$(CONFDIR)/action.d/prune.sh \
                                      $(DESTDIR)$(CONFDIR)/overworld-blocks.conf \
                                      $(DESTDIR)$(CONFDIR)/nether-blocks.conf \
                                      $(DESTDIR)$(CONFDIR)/end-blocks.conf
endif



TGT_INSTALL := $(TGT_INSTALL) scripts-install
DIST        := $(DIST) scripts
DISTCLEAN   := $(DISTCLEAN) scripts/bash_completion scripts/logrotate \
               scripts/cron

INSTALLDIRS := $(INSTALLDIRS) \
               $(DESTDIR)${sysconfdir}/bash_completion.d \
               $(DESTDIR)${sysconfdir}/logrotate.d \
               $(DESTDIR)${sysconfdir}/cron.d
               #$(DESTDIR)${CONFDIR}/action.d
               # ^ already provided by src/Makefile.inc

UNINSTALL := $(UNINSTALL) $(SCRIPTS_INSTALL)



# install scripts

$(DESTDIR)$(CONFDIR)/action.d/%.sh: scripts/%.sh
	$(INSTALL_DATA) $< $@

# install bash completion

$(DESTDIR)$(sysconfdir)/bash_completion.d/$(PROG): scripts/bash_completion
	$(INSTALL_DATA) $< $@

# install logrotate script

$(DESTDIR)$(sysconfdir)/logrotate.d/$(PROG): scripts/logrotate
	$(INSTALL_DATA) $< $@

# install crontab

$(DESTDIR)$(sysconfdir)/cron.d/$(PROG): scripts/cron
	$(INSTALL_DATA) $< $@

$(DESTDIR)$(CONFDIR)/%-blocks.conf: scripts/%-blocks.conf
	$(INSTALL_DATA) $< $@


# phony targets

.PHONY: scripts-install
scripts-install: $(SCRIPTS_INSTALL)

# vim: set ft=make:
