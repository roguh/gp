SHELLSCRIPTS=gp git-remote-status.sh
ALL_SHELLSCRIPTS=${SHELLSCRIPTS} test-install.sh test-make-commit.sh test.sh

install-to-user:
	cp ${SHELLSCRIPTS} ~/bin/
	./test-install.sh ~/bin/

install:
	cp ${SHELLSCRIPTS} /usr/bin/
	./test-install.sh /usr/bin/

uninstall:
	echo Remove the files: ${SHELLSCRIPTS} from your PATH

checkbashisms:
	shellcheck ${ALL_SHELLSCRIPTS}

test-on-linux:
	./test-all-shells.sh sh dash bash zsh
