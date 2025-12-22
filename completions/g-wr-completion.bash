#!/usr/bin/env bash

# Bash completion for g-wr command
# Author: Santhosh Siva
# Description: Provides auto-completion for g-wr using git worktree list

_g_wr_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Available options
    opts="-h --help -t --target-branch -w --worktree-name -s --stash-changes"

    # Get worktree information
    _get_worktree_branches() {
        git worktree list --porcelain 2>/dev/null | grep "^branch" | sed 's/branch refs\/heads\///'
    }

    _get_worktree_paths() {
        git worktree list --porcelain 2>/dev/null | grep "^worktree" | awk '{print $2}' | xargs -I {} basename {}
    }

    # Completion for -t/--target-branch flag
    case "${prev}" in
        -t|--target-branch)
            local branches=$(_get_worktree_branches)
            COMPREPLY=( $(compgen -W "${branches}" -- ${cur}) )
            return 0
            ;;
        -w|--worktree-name)
            local worktree_names=$(_get_worktree_paths)
            COMPREPLY=( $(compgen -W "${worktree_names}" -- ${cur}) )
            return 0
            ;;
        *)
            ;;
    esac

    # Handle -t= and -w= formats
    if [[ ${cur} == -t=* ]]; then
        local branches=$(_get_worktree_branches)
        local prefix="-t="
        local search_term="${cur#-t=}"
        COMPREPLY=( $(compgen -W "${branches}" -P "${prefix}" -- ${search_term}) )
        return 0
    fi

    if [[ ${cur} == --target-branch=* ]]; then
        local branches=$(_get_worktree_branches)
        local prefix="--target-branch="
        local search_term="${cur#--target-branch=}"
        COMPREPLY=( $(compgen -W "${branches}" -P "${prefix}" -- ${search_term}) )
        return 0
    fi

    if [[ ${cur} == -w=* ]]; then
        local worktree_names=$(_get_worktree_paths)
        local prefix="-w="
        local search_term="${cur#-w=}"
        COMPREPLY=( $(compgen -W "${worktree_names}" -P "${prefix}" -- ${search_term}) )
        return 0
    fi

    if [[ ${cur} == --worktree-name=* ]]; then
        local worktree_names=$(_get_worktree_paths)
        local prefix="--worktree-name="
        local search_term="${cur#--worktree-name=}"
        COMPREPLY=( $(compgen -W "${worktree_names}" -P "${prefix}" -- ${search_term}) )
        return 0
    fi

    # Default completion for options
    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi

    return 0
}

# Register the completion function
complete -F _g_wr_completion g-wr
