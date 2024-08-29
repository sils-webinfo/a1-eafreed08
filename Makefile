SHELL := /usr/bin/env bash
RIOT := tools/jena/bin/riot
RDF2DOT := tools/rdflib/bin/rdf2dot

.PHONY: superclean validate setup

superclean:
	$(MAKE) -s -C tools/jena clean
	$(MAKE) -s -C tools/rdflib clean


$(RIOT):
	which java || \
	(sudo apt update && sudo apt -y install default-jre)
	$(MAKE) -s -C tools/jena

$(RDF2DOT):
	which python3 || \
	(sudo apt update && sudo apt -y install python3)
	test -f /usr/share/doc/python3-venv || \
	(sudo apt update && sudo apt -y install python3-venv)
	$(MAKE) -s -C tools/rdflib

setup: $(RIOT) $(RDF2DOT)

validate: $(RIOT)
	./$(RIOT) --validate --count books.ttl

books.png: books.ttl | validate $(RDF2DOT)
	which dot || \
	(sudo apt update && sudo apt -y install graphviz)
	./$(RDF2DOT) $< | dot -Tpng > $@

