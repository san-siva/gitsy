#!/usr/bin/env bash

# Author: Santhosh Siva
# Date Created: 03-08-2025

# Description:
# This script returns the current branch name in a git repository.

main() {
	validate_dependencies git
	git rev-parse --abbrev-ref HEAD
}

main "$@"
exit 0
