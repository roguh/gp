# gp: Git pull, push, push new remote branch

<!--
EDIT README.template.md, not README.md directly.
Use `make build-readme to update the README file
-->

Like the waves.

## Usage

```
gp --help
<GP_HELP_STRING>
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

## Testing

Testing is a semi-manual process.
Make sure you have permission to push new branches to the remote repository.

If the test script fails, the tests have failed.
Also read the output to determine if `gp` is behaving correctly.

### Running tests for many shells at once

```
make test-on-linux
```

Note this command runs the `test-integration.sh` within the test shell itself.

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

Tested using GNU coreutils 9.0 in these shells:

- dash 0.5
- bash 5.1
- bash 5.1 in bash 3.1 compatibility mode BASH_COMPAT=31
- zsh 5.8
