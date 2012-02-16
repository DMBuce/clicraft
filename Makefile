SHELL = /bin/sh

prog=clicraft

# root for installation
prefix=/usr/local
exec_prefix=$(prefix)

# executables
bindir=$(exec_prefix)/bin
sbindir=$(exec_prefix)/sbin
libexecdir=$(exec_prefix)/libexec

# data
datarootdir=$(prefix)/share
datadir=$(datarootdir)
sysconfdir=$(prefix)/etc
sharedstatedir=$(prefix)/com
localstatedir=$(prefix)/var

# misc
includedir=$(prefix)/include
oldincludedir=/usr/include
docdir=$(datarootdir)/doc/$(prog)
infodir=$(datarootdir)/info
libdir=$(exec_prefix)/lib
localedir=$(datarootdir)/locale
mandir=$(datarootdir)/man
man1dir=$(mandir)/man1
man2dir=$(mandir)/man1
man3dir=$(mandir)/man1
man4dir=$(mandir)/man1
man5dir=$(mandir)/man1
man6dir=$(mandir)/man1
man7dir=$(mandir)/man1
man8dir=$(mandir)/man1
man9dir=$(mandir)/man1
manext=.1
srcdir=.

etcdir=/etc
mandir=$(prefix)/share/man
vardir=/var

INSTALL=install
INSTALL_PROGRAM=$(INSTALL)
INSTALL_DATA=$(INSTALL) -m 644

all:

clean:

install:
	$(INSTALL_PROGRAM) $(srcdir)/bin/$(prog) $(DESTDIR)$(prefix)/share/$(prog)/bin/
	$(INSTALL_DATA) $(srcdir)/lib/action.d/* $(DESTDIR)$(prefix)/share/$(prog)/lib/action.d/
	$(INSTALL_DATA) $(srcdir)/lib/*.sh $(DESTDIR)$(prefix)/share/$(prog)/lib/
	$(INSTALL_DATA) $(srcdir)/etc/action.d/* $(DESTDIR)$(prefix)/share/$(prog)/etc/action.d/
	$(INSTALL_DATA) $(srcdir)/etc/*.conf $(DESTDIR)$(prefix)/share/$(prog)/etc/

uninstall:
	rm $(DESTDIR)$(prefix)/share/$(prog)/bin/$(prog)
	rm $(DESTDIR)$(prefix)/share/$(prog)/lib/action.d/*
	rm $(DESTDIR)$(prefix)/share/$(prog)/lib/*.sh
	rm $(DESTDIR)$(prefix)/share/$(prog)/etc/action.d/*
	rm $(DESTDIR)$(prefix)/share/$(prog)/etc/*.conf

check:

.PHONY: all clean install uninstall check

