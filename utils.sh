#!/usr/bin/env bash

# Author: Santhosh Siva
# Date Created: 03-08-2025

# Colors
BLUE=$(tput setaf 4)
PROMPT=$(tput setaf 3)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)

overwrite() { echo -e "\r\033[1A\033[0K$@"; }

print_message() {
	echo -e "$1"
}

indent() {
	local spaces=$1
	if [ -z "$spaces" ]; then
		spaces=2
	fi
	local prefix="$(printf "%${spaces}s")- "
	sed "s/^/${prefix}/"
}

install_dependency() {
	local cmd=$1
	local package=$2

	if ! command -v "$cmd" >/dev/null; then
		if brew install "$package" >>"$log_file" 2>>"$error_log_file"; then
			return
		else
			print_message "${RED}Failed to install $package.${NC}"
			exit 1
		fi
	fi
}

validate_dependencies() {
	for cmd in $@; do
		install_dependency "$cmd" "$cmd"
	done
}

print_banner() {
	print_message ""
	figlet -f slant "Gitsy" | lolcat
	print_message ""
}

prompt_user() {
	local default_to_yes=$1
	local message=$2
	local spaces=$3

	if [ -z "$spaces" ]; then
		spaces=0
	fi

	local prefix="$(printf "%${spaces}s")- " # Generate spaces for indentation
	local prompt="${PROMPT}${prefix}${message}${NC} "

	if [ "$default_to_yes" = "true" ]; then
		read -p "${prompt}(Y/n): " response
		response="${response:-y}"
	else
		read -p "${prompt}(y/N): " response
		response="${response:-n}"
	fi

	case "$response" in
	[Yy]) print_message "y" ;;
	[Nn]) print_message "n" ;;
	*) print_message "${prefix}Invalid input." && exit 1 ;;
	esac
}

fetch_current_branch() {
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	if [ -z "$current_branch" ]; then
		print_message "${RED}Failed to get current branch. [Fail]${NC}" | indent
		exit 1
	fi
	echo "${current_branch}"
}

stash_changes() {
	local stash_changes=$1
	if [ "$stash_changes" = "true" ]; then
		print_message "${BLUE}Stashing changes...${NC}"

		if ! (git add -A 2>&1 | indent 4); then
			print_message "${RED}Failed to add changes to stash. [Fail]${NC}" | indent
			exit 1
		fi

		if ! (git stash push -m "Auto-stash__$(date '+%Y-%m-%d/%H:%M:%S')" 2>&1 | indent 4); then
			print_message "${RED}Failed to stash changes. [Fail]${NC}" | indent
			exit 1
		fi

		print_message "${GREEN}Changes stashed successfully.${NC}" | indent
	fi
}

fetch_changes() {
	local target_branch=$1

	if [ -z "$target_branch" ]; then
		print_message "${RED}Target branch is not set. [Fail]${NC}" | indent
		return 1
	fi

	if ! git_output=$(git fetch origin "${target_branch}:${target_branch}" 2>&1); then
		print_message "$git_output" | indent 4
		print_message "${PROMPT}Auto-Fetch failed, Please do it manually.${NC}" | indent 2
		return 1
	else
		print_message "$git_output" | indent 4
		return 0
	fi

	return 0
}

checkout_branch() {
	local target_branch=$1
	local new_branch=$2

	if [ -z "$target_branch" ]; then
		print_message "${RED}Target branch is not set. [Fail]${NC}" | indent
		exit 1
	fi

	if [ "$new_branch" = "true" ]; then
		if ! checkout_output=$(git checkout -b "${target_branch}" 2>&1); then
			print_message "$checkout_output" | indent 4
			print_message "${RED}Failed to create new branch. [Fail]${NC}" | indent 2
			exit 1
		fi
		print_message "${GREEN}Created new local branch ${NC}${target_branch}${GREEN}. [DONE]${NC}" | indent 2
		return 0
	fi

	if ! checkout_output=$(git checkout "${target_branch}" 2>&1); then
		print_message "$checkout_output" | indent 4
		print_message "${RED}Failed to checkout to branch ${NC}${target_branch}${RED}. [Fail]${NC}" | indent 2
		exit 1
	fi

	print_message "$checkout_output" | indent 4
	return 0
}

create_worktree() {
	local target_branch="$1"
	local worktree_path="$2"
	local new_branch="$3"
	local base_branch

	if [ -z "$target_branch" ]; then
		print_message "${RED}Target branch is not set. [Fail]${NC}" | indent
		exit 1
	fi
	if [ -z "$worktree_path" ]; then
		print_message "${RED}Worktree path is not set. [Fail]${NC}" | indent
		exit 1
	fi
	if [ -d "$worktree_path" ]; then
		print_message "${RED}Worktree path already exists. [Fail]${NC}" | indent
		exit 1
	fi

	base_branch=$(fetch_current_branch)
	if [ -z "$base_branch" ]; then
		print_message "${RED}Failed to get current branch. [Fail]${NC}" | indent
		exit 1
	fi

	if [ "$new_branch" = "true" ]; then
		# Make sure the source branch exists remotely!
		if ! git rev-parse --verify "origin/$base_branch" >/dev/null 2>&1; then
			print_message "${RED}Base branch ${NC}origin/$base_branch${RED} not found. Cannot create new branch.${NC}" | indent 2
			exit 1
		fi

		# Use the -b flag on worktree directly:
		if ! worktree_output=$(git worktree add -b "$target_branch" "$worktree_path" "origin/$base_branch" 2>&1); then
			print_message "$worktree_output" | indent 4
			print_message "${RED}Failed to create worktree for branch ${NC}$target_branch${RED}. [Fail]${NC}" | indent 2
			exit 1
		fi

		print_message "${GREEN}Created worktree ${NC}$target_branch${GREEN} from ${NC}origin/$base_branch${GREEN} at ${NC}$worktree_path${GREEN} [DONE]${NC}" | indent 2
		print_message "${BLUE}Pushing new branch ${NC}$target_branch${BLUE} to remote...${NC}" | indent 2

		if ! push_output=$(git push -u origin "$target_branch" 2>&1); then
			print_message "$push_output" | indent 4
			print_message "${RED}Failed to push new branch ${NC}$target_branch${RED} to remote. [Fail]${NC}" | indent 2
			exit 1
		fi

		return 0
	fi

	# Just add the worktree to an existing branch:
	if ! worktree_output=$(git worktree add "$worktree_path" "$target_branch" 2>&1); then
		print_message "$worktree_output" | indent 4
		print_message "${RED}Failed to create worktree for branch ${NC}$target_branch${RED}. [Fail]${NC}" | indent 2
		exit 1
	fi

	print_message "${GREEN}Successfully created worktree for branch ${NC}$target_branch${GREEN} at ${NC}$worktree_path${GREEN}. [DONE]${NC}" | indent 2
	return 0
}

reset_to_target_branch() {
	local target_branch=$1

	if [ -z "$target_branch" ]; then
		print_message "${RED}Target branch is not set. [Fail]${NC}" | indent
		exit 1
	fi

	print_message "${BLUE}Resetting to ${NC}origin/${target_branch}${BLUE}...${NC}"

	if ! reset_output=$(git reset --hard "origin/${target_branch}" 2>&1); then
		print_message "$reset_output" | indent 4
		print_message "${RED}Failed to reset to ${NC}origin/${target_branch}${RED}. [Fail]${NC}" | indent 2
		exit 1
	fi

	print_message "$reset_output" | indent 4
	print_message "${GREEN}Reset to ${NC}origin/${target_branch}${GREEN} successfully.${NC}" | indent 2
	print_message ""
}

pull_changes() {
	local target_branch=$1

	if [ -z "$target_branch" ]; then
		print_message "${RED}Target branch is not set. [Fail]${NC}" | indent
		exit 1
	fi

	print_message "${BLUE}Pulling changes from ${NC}remote/${target_branch}${BLUE}...${NC}"
	if ! pull_output=$(git pull origin "${target_branch}" 2>&1); then
		print_message "$pull_output" | indent 4
		print_message "${RED}Failed to pull changes from remote. [Fail]${NC}" | indent 2
		exit 1
	fi

	print_message "$pull_output" | indent 4
	print_message "${GREEN}Pulled changes from ${NC}remote/${target_branch} ${GREEN}successfully.${NC}" | indent 2
}

push_changes() {
	local target_branch=$1
	local should_force_push=$2

	if [ -z "$target_branch" ]; then
		print_message "${RED}Target branch is not set. [Fail]${NC}" | indent
		exit 1
	fi

	if [ "$should_force_push" = "true" ]; then
		print_message "${BLUE}Force pushing changes to ${NC}remote/${target_branch}${BLUE}...${NC}"
		if ! push_output=$(git push --force origin "${target_branch}" 2>&1); then
			print_message "$push_output" | indent 4
			print_message "${RED}Failed to force push changes to remote. [Fail]${NC}" | indent 2
			exit 1
		fi
	else
		print_message "${BLUE}Pushing changes to ${NC}remote/${target_branch}${BLUE}...${NC}"
		if ! push_output=$(git push origin "${target_branch}" 2>&1); then
			print_message "$push_output" | indent 4
			print_message "${RED}Failed to push changes to remote. [Fail]${NC}" | indent 2
			exit 1
		fi
	fi

	print_message "$push_output" | indent 4
	print_message "${GREEN}Pushed changes to ${NC}remote/${target_branch} ${GREEN}successfully.${NC}" | indent 2
}
