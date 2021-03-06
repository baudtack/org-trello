VERSION=$$(grep "^;; Version: " src/header.el | cut -f3 -d' ')
PACKAGE_FOLDER=org-trello-$(VERSION)
ARCHIVE=$(PACKAGE_FOLDER).tar
USER=ardumont

test: clean
	cask exec emacs --batch \
			-l ert \
			-l ./launch-tests.el \
			-f ert-run-tests-batch-and-exit

itest-clean:
	rm -f "#org-trello-tests.org#" "org-trello-tests.org" "org-trello-tests.org~"

itest: itest-clean
	cask exec ecukes --script

itest-f: itest-clean
	cask exec ecukes --script --dbg $(FEATURE)

itest-f-win: itest-clean
	cask exec ecukes --dbg $(FEATURE)

itest-win:
	cask exec ecukes features --dbg

tests:	test itest

pkg-el:
	cask package

clean:
	rm -rf *.tar $(PACKAGE_FOLDER)

prepare:
	mkdir -p $(PACKAGE_FOLDER)
	cp -r org-trello.el org-trello-pkg.el $(PACKAGE_FOLDER)

generate:
	cask exec emacs -Q --batch -l ./build-package.el

package: clean generate pkg-el prepare
	tar cvf $(ARCHIVE) $(PACKAGE_FOLDER)
	rm -rf $(PACKAGE_FOLDER)

info:
	cask info

install-package-from-marmalade:
	./install-package-from.sh marmalade

install-package-from-melpa:
	./install-package-from.sh melpa

install-file-with-deps-from-marmalade: package
	./install-file-with-deps-from.sh marmalade $(VERSION)

install-file-with-deps-from-melpa: package
	./install-file-with-deps-from.sh melpa $(VERSION)

cleanup-data:
	rm -rvf ~/.emacs.d/elnode/public_html/org-trello/{1,2,3}/.scanning/* \
		~/.emacs.d/elnode/public_html/org-trello/{1,2,3}/* \
		~/.emacs.d/elnode/public_html/org-trello/*.lock

release:
	./release.sh $(VERSION) $(USER)

install-cask:
	curl -fsSkL https://raw.github.com/cask/cask/master/go | python
