
ASCIIDOC_OPTS=-f doc/asciidoc.conf -d manpage -a CONFDIR=$(CONFDIR) -a SERVER_DIR=$(SERVER_DIR)

.PHONY: doc
doc: all
	a2x --no-xmllint -d manpage -f manpage --asciidoc-opts="${ASCIIDOC_OPTS}" doc/clicraft.1.txt
	a2x --no-xmllint -d manpage -f manpage --asciidoc-opts="${ASCIIDOC_OPTS}" doc/clicraft.conf.5.txt

html: all
	asciidoc ${ASCIIDOC_OPTS} -a toc -a max-width=960px doc/clicraft.1.txt
	asciidoc ${ASCIIDOC_OPTS} -a toc -a max-width=960px doc/clicraft.conf.5.txt

# vim: set ft=make:
