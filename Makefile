DESTDIR?=
prefix=/usr
bindir=${prefix}/bin
etcdir=/etc
mandir=${prefix}/share/man
vardir=/var

INSTALL=install
INSTALL_EXE=${INSTALL} -D
INSTALL_DATA=${INSTALL} -m 0644 -D

all:

install:
	mkdir -p $(DESTDIR)$(prefix)/share/clicraft/
	cp -dR ./src/* $(DESTDIR)$(prefix)/share/clicraft/

.PHONY: all install

