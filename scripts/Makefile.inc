SCRIPTS_INSTALL := $(DESTDIR)$(sysconfdir)/bash_completion.d/$(PROG) \
                   $(DESTDIR)$(sysconfdir)/logrotate.d/$(PROG) \
                   $(DESTDIR)$(sysconfdir)/cron.d/$(PROG)



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



# install bash completion

$(DESTDIR)$(sysconfdir)/bash_completion.d/$(PROG): scripts/bash_completion
	$(INSTALL_DATA) $< $@

# install logrotate script

$(DESTDIR)$(sysconfdir)/logrotate.d/$(PROG): scripts/logrotate
	$(INSTALL_DATA) $< $@

# install crontab

$(DESTDIR)$(sysconfdir)/cron.d/$(PROG): scripts/cron
	$(INSTALL_DATA) $< $@


# phony targets

.PHONY: scripts-install
scripts-install: $(SCRIPTS_INSTALL)

# vim: set ft=make:
