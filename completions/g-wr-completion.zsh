#compdef g-wr

# Zsh completion for g-wr command
# Author: Santhosh Siva
# Description: Provides auto-completion for g-wr using git worktree list

_g_wr() {
    local -a worktree_branches worktree_names

    # Get worktree branches
    worktree_branches=(${(f)"$(git worktree list --porcelain 2>/dev/null | grep '^branch' | sed 's/branch refs\/heads\///')"})

    # Get worktree directory names
    worktree_names=(${(f)"$(git worktree list --porcelain 2>/dev/null | grep '^worktree' | awk '{print $2}' | xargs -n1 basename)"})

    _arguments \
        '(-h --help)'{-h,--help}'[Show help message]' \
        '(-t --target-branch)'{-t,--target-branch}'[Specify target branch]:branch:->branches' \
        '(-w --worktree-name)'{-w,--worktree-name}'[Specify worktree name]:worktree:->worktrees' \
        '(-s --stash-changes)'{-s,--stash-changes}'[Stash changes before proceeding]'

    case $state in
        branches)
            _describe 'worktree branches' worktree_branches
            ;;
        worktrees)
            _describe 'worktree names' worktree_names
            ;;
    esac
}

_g_wr "$@"
