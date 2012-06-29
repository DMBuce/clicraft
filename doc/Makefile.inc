MAN1PAGES := doc/clicraft.1
MAN5PAGES := doc/clicraft.conf.5 doc/clicraft-actions.5
MANPAGES  := $(MAN1PAGES) $(MAN5PAGES)
MAN1PAGES_INSTALL := $(MAN1PAGES:doc/%=$(DESTDIR)$(man1dir)/%)
MAN5PAGES_INSTALL := $(MAN5PAGES:doc/%=$(DESTDIR)$(man5dir)/%)
TXTFILES  := doc/clicraft.1.txt doc/clicraft.conf.5.txt doc/clicraft-actions.5.txt \
             doc/index.txt doc/install.txt doc/contribute.txt
HTMLPAGES := $(TXTFILES:.txt=.html)



TGT_INSTALL := $(TGT_INSTALL) doc-install
CLEAN       := $(MANPAGES) $(HTMLPAGES)
DIST        := $(DIST) doc

DISTCLEAN := $(DISTCLEAN) \
             $(MANPAGES) \
             $(HTMLPAGES)

UNINSTALL := $(UNINSTALL) \
             $(MAN1PAGES_INSTALL) \
             $(MAN5PAGES_INSTALL)

ASCIIDOC_OPTS=-f doc/asciidoc.conf \
	-a CONFDIR=$(CONFDIR) \
	-a EXECDIR=$(EXECDIR) \
	-a SERVER_DIR=$(SERVER_DIR) \
	-a BUGREPORT=$(BUGREPORT) \
	-a URL=$(URL) \
	-a VERSION=$(VERSION) \
	-a REPO='https://github.com/DMBuce/clicraft'



# install man pages

$(DESTDIR)$(man1dir)/%: doc/%
	- $(INSTALL_DATA) $< $@

$(DESTDIR)$(man5dir)/%: doc/%
	- $(INSTALL_DATA) $< $@



# compile man pages with asciidoc

doc/%.1: doc/%.1.txt
	- a2x --no-xmllint -d manpage -f manpage --asciidoc-opts="${ASCIIDOC_OPTS} -d manpage" $<

doc/%.5: doc/%.5.txt
	- a2x --no-xmllint -d manpage -f manpage --asciidoc-opts="${ASCIIDOC_OPTS} -d manpage" $<



# compile html-format man pages with asciidoc

doc/%.1.html: doc/%.1.txt
	asciidoc ${ASCIIDOC_OPTS} -a toc -a icons -a max-width=960px -d manpage $<
                                                                            
doc/%.5.html: doc/%.5.txt                                                   
	asciidoc ${ASCIIDOC_OPTS} -a toc -a icons -a max-width=960px -d manpage $<



# compile html documentation with asciidoc

doc/%.html: doc/%.txt
	asciidoc ${ASCIIDOC_OPTS} -a toc -a icons -a max-width=960px $<



# phony targets

.PHONY: doc-install doc html

doc-install: $(MAN1PAGES_INSTALL) $(MAN5PAGES_INSTALL)

doc: $(MANPAGES)

html: $(HTMLPAGES)



# vim: set ft=make:
