
# get filled by Makefile.inc files
TGT_TARGETS :=
CLEAN       :=
TGT_INSTALL :=
INSTALLDIRS :=
UNINSTALL   :=
DIST        := configure Makefile.in Makefile.inc \
               INSTALL LICENSE README TODO
DISTCLEAN   := Makefile config.log config.status

.PHONY: all
all: targets

include scripts/Makefile.inc
include src/Makefile.inc

.PHONY: targets
targets: $(TGT_TARGETS)

.PHONY: clean
clean:
	rm -f $(CLEAN)

.PHONY: install
install: $(TGT_INSTALL)

$(TGT_INSTALL): installdirs

.PHONY: installdirs
installdirs:
	$(INSTALL) -d $(INSTALLDIRS)

.PHONY: uninstall
uninstall:
	rm -f $(UNINSTALL)

.PHONY: dist
dist:
	autoconf
	rm -rf $(PROG)-$(VERSION)
	mkdir $(PROG)-$(VERSION)
	cp -r $(DIST) $(PROG)-$(VERSION)
	tar czvf $(PROG)-$(VERSION).tar.gz $(PROG)-$(VERSION)

.PHONY: distclean
distclean: clean
	rm -f $(DISTCLEAN)

.SECONDARY: $(CLEAN) $(UNINSTALL)

# vim: set ft=make:
