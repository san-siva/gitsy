#!/usr/bin/env bash

# Author: Santhosh Siva
# Date Created: 03-08-2025

# Description:
# This script creates a new git worktree for a specified branch.
# If the branch does not exist, it prompts the user to create it.

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Default Values
stash=false
target_branch=

set_flags() {
	while [ $# -gt 0 ]; do
		case "$1" in
		-h | --help)
			echo "g-wa - attempt to checkout to branch"
			echo " "
			echo "g-wa [options] application [arguments]"
			echo " "
			echo "options:"
			echo "-h, --help                show brief help"
			echo "--target-branch=BRANCH    specify the target branch"
			echo "--stash-changes           stash changes before proceeding"
			exit 0
			;;
		-t=* | --target-branch=*)
			target_branch="${1#*=}"
			if [ -z "$target_branch" ]; then
				echo "${RED}Error: No target branch specified.$NC"
				exit 1
			fi
			;;
		-t | --target-branch)
			shift
			if [ $# -gt 0 ]; then
				target_branch="$1"
			else
				echo "${RED}Error: No target branch specified.$NC"
				exit 1
			fi
			;;
		-s | --stash-changes)
			stash=true
			;;
		*)
			echo "${RED}Unknown option:${NC} $1"
			exit
			;;
		esac
		shift
	done
}

try_fetching_branch() {
	fetch_success=$(fetch_changes "${target_branch}")
	if [ "${fetch_success}" = "false" ]; then
		print_message "${RED}Failed to fetch changes for branch ${target_branch}. [Fail]${NC}" | indent 2
		exit 1
	fi
}

checkout_or_create_branch() {
	local path="../git_worktree__$(echo -n "$target_branch" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]' '_')"
	print_message "${BLUE}Creating worktree for branch ${NC}origin/${target_branch} ${BLUE}at${NC} ${path} ${BLUE}${NC}"

	if [ -d "$path" ]; then
		print_message "${RED}Worktree path already exists. [Fail]${NC}" | indent
		exit 1
	fi

	# Check if branch exists locally
	if git show-ref --verify --quiet "refs/heads/${target_branch}"; then
		try_fetching_branch
		create_worktree "${target_branch}" "${path}"
		return
	fi

	print_message "${RED}Branch not found locally.${NC}" | indent 2
	print_message "${BLUE}Checking if branch exists on remote...${NC}" | indent 2
	if git ls-remote --heads origin "${target_branch}" | grep -q "${target_branch}"; then
		print_message "${GREEN}Branch available on remote.${NC}" | indent 2
		try_fetching_branch
		create_worktree "${target_branch}" "${path}"
		return
	fi

	print_message "${RED}Branch not found on remote.${NC}" | indent 2
	create_new_branch=$(prompt_user true "Create new branch?" 2)
	if [ "${create_new_branch}" = "y" ]; then
		create_worktree "${target_branch}" "${path}" true
		return
	fi

	print_message "${RED}Aborted.${NC}" | indent 2
	exit 1
}

already_on_branch() {
	current_branch=$(fetch_current_branch)
	if [ "${target_branch}" = "${current_branch}" ]; then
		print_message "${GREEN}Already on branch ${target_branch}. [DONE]${NC}" | indent 2
		exit 1
	fi
}

main() {
	validate_dependencies git figlet lolcat
	print_banner
	set_flags "$@"
	already_on_branch
	stash_changes $stash
	print_message ""
	checkout_or_create_branch
}

main "$@"
exit 0
