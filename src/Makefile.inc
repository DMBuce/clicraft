TGT_INSTALL := $(TGT_INSTALL) src-install
DIST := $(DIST) src

INSTALLDIRS := $(INSTALLDIRS) \
	$(DESTDIR)${bindir} \
	$(DESTDIR)${CONFDIR}/action.d \
	$(DESTDIR)${EXECDIR}/action.d

UNINSTALL := $(UNINSTALL) \
	$(DESTDIR)$(bindir)/clicraft \
	$(DESTDIR)$(EXECDIR)/functions.sh \
	$(DESTDIR)$(EXECDIR)/defaults.sh \
	$(DESTDIR)$(EXECDIR)/action.d/init.sh \
	$(DESTDIR)$(EXECDIR)/action.d/status.sh \
	$(DESTDIR)$(EXECDIR)/action.d/console.sh \
	$(DESTDIR)$(EXECDIR)/action.d/stop.sh \
	$(DESTDIR)$(EXECDIR)/action.d/start.sh \
	$(DESTDIR)$(EXECDIR)/action.d/cmd.sh \
	$(DESTDIR)$(EXECDIR)/action.d/version.sh \
	$(DESTDIR)$(EXECDIR)/action.d/help.sh \
	$(DESTDIR)$(EXECDIR)/action.d/update.sh \
	$(DESTDIR)$(EXECDIR)/action.d/restart.sh \
	$(DESTDIR)$(EXECDIR)/defaults.sh \
	$(DESTDIR)$(CONFDIR)/clicraft-defaults.conf \
	$(DESTDIR)$(CONFDIR)/action.d/backup.sh.example

.PHONY: src-install
src-install:
	$(INSTALL_PROGRAM) src/bin/clicraft                $(DESTDIR)$(bindir)/clicraft
	$(INSTALL_DATA) src/lib/functions.sh               $(DESTDIR)$(EXECDIR)/functions.sh
	$(INSTALL_DATA) src/lib/defaults.sh                $(DESTDIR)$(EXECDIR)/defaults.sh
	$(INSTALL_DATA) src/lib/action.d/init.sh           $(DESTDIR)$(EXECDIR)/action.d/init.sh
	$(INSTALL_DATA) src/lib/action.d/status.sh         $(DESTDIR)$(EXECDIR)/action.d/status.sh
	$(INSTALL_DATA) src/lib/action.d/console.sh        $(DESTDIR)$(EXECDIR)/action.d/console.sh
	$(INSTALL_DATA) src/lib/action.d/stop.sh           $(DESTDIR)$(EXECDIR)/action.d/stop.sh
	$(INSTALL_DATA) src/lib/action.d/start.sh          $(DESTDIR)$(EXECDIR)/action.d/start.sh
	$(INSTALL_DATA) src/lib/action.d/cmd.sh            $(DESTDIR)$(EXECDIR)/action.d/cmd.sh
	$(INSTALL_DATA) src/lib/action.d/version.sh        $(DESTDIR)$(EXECDIR)/action.d/version.sh
	$(INSTALL_DATA) src/lib/action.d/help.sh           $(DESTDIR)$(EXECDIR)/action.d/help.sh
	$(INSTALL_DATA) src/lib/action.d/update.sh         $(DESTDIR)$(EXECDIR)/action.d/update.sh
	$(INSTALL_DATA) src/lib/action.d/restart.sh        $(DESTDIR)$(EXECDIR)/action.d/restart.sh
	$(INSTALL_DATA) src/etc/clicraft-defaults.conf     $(DESTDIR)$(CONFDIR)/clicraft-defaults.conf
	$(INSTALL_DATA) src/etc/action.d/backup.sh.example $(DESTDIR)$(CONFDIR)/action.d/backup.sh.example
	
# vim: set ft=make:
