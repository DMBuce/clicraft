
# get filled by Makefile.inc files
TGT_TARGETS :=
CLEAN :=
TGT_INSTALL :=
INSTALLDIRS :=
UNINSTALL :=

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

.SECONDARY: $(CLEAN) $(UNINSTALL)

# vim: set ft=make:
