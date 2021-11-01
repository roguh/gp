#!/usr/bin/env python3
import argparse
import sys
from pprint import pprint

# define subcommands to mock git behavior:
# DONE if git rev-parse, if in git-repo exit 0 else exit 1
# DONE if git remote update, do nothing
# DONE if rev-parse @, show local_branch
# DONE if rev-parse @{u}, show remote_branch
# DONE if merge-parse @{u}, show base_branch
# DONE if branch --show-current, print local_branch_name
# DONE if push or pull, print all args

# unit test: define git() as ./this.py <CONFIG ARGS> "$@"


def rev_parse(args, unknown_args):
    if args.git_dir:
        sys.exit(1 if args.not_in_a_git_repo else 0)
    elif args.rev == "@":
        print(args.local_branch)
    elif args.rev == "@{u}":
        print(args.remote_branch)
    else:
        raise NotImplementedError(f"rev={args.rev}")


def remote(_, unknown_args):
    # Do nothing but successfully exit
    pass


def merge_base(args, unknown_args):
    if args.rev == "@" and args.upstream_rev == "@{u}":
        print(args.base_branch)
    else:
        raise NotImplementedError(f"rev={args.rev} upstream_rev={args.upstream_rev}")


def branch(args, unknown_args):
    if args.show_current:
        print(args.local_branch_name)
    else:
        raise NotImplementedError("show_current=False")


def push(args, unknown_args):
    pass


def pull(args, unknown_args):
    pass


def main():
    parser = argparse.ArgumentParser(description="Mocks git subcommands used by gp")

    parser.add_argument("--not-in-a-git-repo", action="store_true")
    parser.add_argument("--local-branch", default=None)
    parser.add_argument("--remote-branch", default=None)
    parser.add_argument("--base-branch", default=None)
    parser.add_argument("--local-branch-name", default=None)

    subparsers = parser.add_subparsers()

    rev_parse_parser = subparsers.add_parser("rev-parse")
    rev_parse_parser.add_argument("rev", nargs="?")
    rev_parse_parser.add_argument("--git-dir", action="store_true")
    rev_parse_parser.set_defaults(func=rev_parse)

    remote_parser = subparsers.add_parser("remote")
    remote_parser.add_argument("remote_update_args", nargs="*")
    remote_parser.set_defaults(func=remote)

    merge_base_parser = subparsers.add_parser("merge-base")
    merge_base_parser.add_argument("rev", type=str)
    merge_base_parser.add_argument("upstream_rev", type=str)
    merge_base_parser.set_defaults(func=merge_base)

    branch_parser = subparsers.add_parser("branch")
    branch_parser.add_argument("--show-current", action="store_true", required=True)
    branch_parser.set_defaults(func=branch)

    push_parser = subparsers.add_parser("push")
    push_parser.set_defaults(func=push)

    pull_parser = subparsers.add_parser("pull")
    pull_parser.set_defaults(func=pull)

    args, unknown = parser.parse_known_args()
    args.func(args, unknown)


if __name__ == "__main__":
    main()
