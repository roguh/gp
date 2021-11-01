LINUX_SHELLS=dash bash zsh
STRICT_SHELLS=yash ksh
SHELLSCRIPTS=gp
ALL_SHELLSCRIPTS=${SHELLSCRIPTS} tests/bash-3.1 $(shell find tests -iname \*.sh)
GITHUB_ACTIONS_FILES=.github/workflows/on-pr-to-main.yml

setup-cicd:
	apt-get update -y
	apt-get install -y shellcheck $(LINUX_SHELLS) $(STRICT_SHELLS)

build-readme:
	./utils/generate_readme.py ./README.template.md > ./README.md

release:
	# Check version is valid
	[ "$(TITLE)" != "" ] || (echo Please set the title with \`make TITLE=...\`; false)
	echo "$(VERSION)" | grep '^[0-9]\+\.[0-9]\+\(\.[0-9]\+\)\?$$' || (echo Must pass version string as \`make VERSION=XX.YY[.ZZ]\`; false)
	./tests/check-repo-is-clean.sh Please commit your changes before bumping version
	./utils/bump-version.sh "$(VERSION)"
	make build-readme
	git commit -am "Bump version to $(VERSION)" -m "$(TITLE)"
	gh release create "v$(VERSION)" --title "$(VERSION) $(TITLE)" $(SHELLSCRIPTS)

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

check-github-actions:
	yamllint $(GITHUB_ACTIONS_FILES)

test-on-linux:
	./tests/test-all-shells.sh $(LINUX_SHELLS) ./tests/bash-3.1

test-on-strict-posix-shells:
	./tests/test-all-shells.sh $(STRICT_SHELLS)

test-all-on-linux:
	# If this fails, check the tests/test-results.*.txt files
	./tests/test-all-shells.sh $(LINUX_SHELLS) $(STRICT_SHELLS) ./tests/bash-3.1

test-on-macos:
	# TODO add other shells?
	./tests/test-all-shells.sh bash zsh

line-count:
	cloc ${SHELLSCRIPTS}
	cloc tests
