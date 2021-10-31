# gp: Git pull, push, push new remote branch

Like the waves.

## Usage

```
gp --help
gp: Pull, push, push new branch. Version 1.2

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
    --version    Show program version.
    -h|--help    Show this message.

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

Note this command runs the `test.sh` within the test shell itself.

### Running tests one shell at a time

Run the following commands:

```
./tests/test.sh sh
./tests/test.sh dash
./tests/test.sh bash
BASH_COMPAT=31 ./tests/test.sh bash
./tests/test.sh zsh
```

### Test results

Tested using GNU coreutils 9.0 in these shells:

- dash 0.5
- bash 5.1
- bash 5.1 in bash 3.1 compatibility mode BASH_COMPAT=31
- zsh 5.8
