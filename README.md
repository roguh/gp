# gp: Git pull, push, push new remote branch

<!--
EDIT README.template.md, not README.md directly.
Use `make build-readme to update the README file
-->

Like the waves.

## Usage

```
gp --help
gp: Pull, push, push new branch. Version 1.3.5

- If there are changes in the remote branch, pull
- If there are changes in the local branch, push
- If there is no remote branch, prompt to push a new branch.
  Skip prompt with gp -f
- If the branches have diverged, do nothing.
  Force push with gp -f

USAGE: gp [-f|-v|-h|--version]
    -f|--force   Do not prompt for verification when pushing new branch.
                 Force push when local and remote branches diverged.
    -v|--verbose Show more output.
    -h|--help    Show this message.
    --version    Show program version.

```

To pull, push, or push a new remote branch:

```
gp
```

As above, but force push if diverged and do not prompt to push a new remote branch:

```
gp --force
gp -f
```

## Installation

### Option 1:

1. Download [raw.githubusercontent.com/roguh/gp/main/gp](https://raw.githubusercontent.com/roguh/gp/main/gp).
2. Make executable and move to your preferred binary location.

```
chmod +x gp
sudo cp gp /usr/bin/gp
```

### Option 2:

```
git clone https://github.com/roguh/gp.git
cd gp
make install
```

OR

```
git clone https://github.com/roguh/gp.git
cd gp
make install-to-user
```

## Unit Testing

### Linux: Running tests for many shells at once

```
make unit-test-on-linux
```

To include stricter POSIX shells:

```
make unit-test-all-on-linux
```

### Bash: Running tests for many shells at once

```
make unit-test-on-macos
```

## Integration Testing

Testing is a semi-manual process.
Make sure you have permission to push new branches to the remote repository.

If the test script fails, the tests have failed.
Also read the output to determine if `gp` is behaving correctly.

Note the `test-integration-all-shells.sh` script runs the `test-integration.sh` script using the test shell itself.

### Linux: Running tests for many shells at once

```
make test-on-linux
```

### MacOS: Running tests for many shells at once

```
make test-on-macos
```

### Running tests for stricter POSIX shells

```
make test-on-strict-posix-shells
```

### Running tests one shell at a time

Run the following commands:

```
./tests/test-integration.sh sh
./tests/test-integration.sh dash
./tests/test-integration.sh bash
BASH_COMPAT=31 ./tests/test-integration.sh bash
./tests/test-integration.sh zsh
```

### Test results

### Linux

Tested using GNU coreutils 9.0 in these shells:

- dash 0.5
- bash 5.1
- bash 5.1 in bash 3.1 compatibility mode BASH_COMPAT=31
- zsh 5.8
- yash 2.52
- ksh version 2020.0.0

### MacOS

Not tested on MacOS, yet. It should work fine.

## Linting and Compatibility Check

Use shellcheck to check shellscripts.

```
make check
```

## Why?

- I wanted a convenient shortcut for `git pull` and `git push`.
  I recently created git aliases (and fish abbreviations), e.g. `gl` for `git
  log`, and I wanted to use `gp` for either `git pull` or `git push` depending
  on the state of the repo. This needed more complex code so I wrote this script
  and eventually moved it to its own repo.
- To demonstrate how I would deploy code. Features:
  - Linting and other automated checks.
  - Thorough tests.
    - Integration tests and a way to run them on many different platforms.
    - Unit tests that run on many shells, even on Bash 2.03
  - Good documentation.
  - GitHub Actions for running tests and code checks.
