SHELLSCRIPTS=gp
ALL_SHELLSCRIPTS=${SHELLSCRIPTS} tests/bash-3.1 test-install.sh $(shell find tests -iname \*.sh)

build-readme:
	./utils/generate_readme.py ./README.template.md > ./README.md

install-to-user:
	cp ${SHELLSCRIPTS} ~/bin/
	./tests/test-install.sh ~/bin/

install:
	cp ${SHELLSCRIPTS} /usr/bin/
	./tests/test-install.sh /usr/bin/

uninstall:
	echo Remove the files: ${SHELLSCRIPTS} from your PATH

check:
	shellcheck ${ALL_SHELLSCRIPTS}

test-on-linux:
	./tests/test-all-shells.sh dash bash zsh ./tests/bash-3.1

test-on-strict-posix-shells:
	./tests/test-all-shells.sh yash ksh

test-on-macos:
	# TODO add other shells?
	./tests/test-all-shells.sh bash zsh

line-count:
	cloc ${SHELLSCRIPTS}
	cloc tests
