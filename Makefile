# tazlab Makefile

PREFIX     ?= /usr
DESTDIR    ?=
SYSCONFDIR ?= /etc

all:
	@echo "Run: make install [DESTDIR=...] [PREFIX=/usr]"

install:
	install -Dm755 tazlab      $(DESTDIR)$(PREFIX)/bin/tazlab
	install -Dm755 tazlab      $(DESTDIR)$(PREFIX)/bin/tazlab-build
	install -Dm644 tazlab.conf $(DESTDIR)$(SYSCONFDIR)/slitaz/tazlab.conf
	install -Dm644 README.md   $(DESTDIR)$(PREFIX)/share/doc/tazlab/README.md

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/tazlab
	rm -f $(DESTDIR)$(PREFIX)/bin/tazlab-build
	rm -f $(DESTDIR)$(SYSCONFDIR)/slitaz/tazlab.conf
	rm -rf $(DESTDIR)$(PREFIX)/share/doc/tazlab

.PHONY: all install uninstall
