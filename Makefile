# tazchroot Makefile

PREFIX     ?= /usr
DESTDIR    ?=
SYSCONFDIR ?= /etc

all:
	@echo "Run: make install [DESTDIR=...] [PREFIX=/usr]"

install:
	install -Dm755 tazchroot      $(DESTDIR)$(PREFIX)/bin/tazchroot
	install -Dm644 tazchroot.conf $(DESTDIR)$(SYSCONFDIR)/slitaz/tazchroot.conf
	install -Dm644 README         $(DESTDIR)$(PREFIX)/share/doc/tazchroot/README

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/tazchroot
	rm -f $(DESTDIR)$(SYSCONFDIR)/slitaz/tazchroot.conf
	rm -rf $(DESTDIR)$(PREFIX)/share/doc/tazchroot

.PHONY: all install uninstall
