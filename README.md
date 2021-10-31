# gp: Git pull, push, push new remote branch

Like the waves.

## Usage

```
gp --help
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

Simply copy `gp` to your favorite binary location.

Alternatively, run

```
make install
```

OR

```
make install-to-user
```

## Testing

Testing is a semi-manual process.
Make sure you have permission to push new branches to the remote repository.

If the test script fails, the tests have failed.
Also read the output to determine if `gp` is behaving correctly.

Run the following commands and press ENTER when you are prompted.

```
./test.sh sh
./test.sh dash
./test.sh bash
BASH_COMPAT=31 ./test.sh bash
./test.sh zsh
```

### Test results

Tested using GNU coreutils 9.0 in these shells:

- dash 0.5
- bash 5.1
- bash 5.1 in bash 3.1 compatibility mode BASH_COMPAT=31
- zsh 5.8
