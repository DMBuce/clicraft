
ASCIIDOC_OPTS=-f doc/asciidoc.conf -d manpage \
	-a CONFDIR=$(CONFDIR) \
	-a SERVER_DIR=$(SERVER_DIR) \
	-a BUGREPORT=$(BUGREPORT) \
	-a URL=$(URL)

.PHONY: doc
doc: all
	a2x --no-xmllint -d manpage -f manpage --asciidoc-opts="${ASCIIDOC_OPTS}" doc/clicraft.1.txt
	a2x --no-xmllint -d manpage -f manpage --asciidoc-opts="${ASCIIDOC_OPTS}" doc/clicraft.conf.5.txt

html: all
	asciidoc ${ASCIIDOC_OPTS} -a toc -a icons -a max-width=960px doc/clicraft.1.txt
	asciidoc ${ASCIIDOC_OPTS} -a toc -a icons -a max-width=960px doc/clicraft.conf.5.txt

# vim: set ft=make:
