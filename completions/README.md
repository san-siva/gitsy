# Gitsy Shell Completions

Auto-completion scripts for gitsy commands.

## Available Completions

Currently, auto-completion is available for:

- **g-wr** - Remove Git Worktree command

## Features

The `g-wr` completion provides:

- **Branch name suggestions** for `-t` or `--target-branch` flag
  - Automatically lists all branches from `git worktree list`
  - Works with both `-t branch-name` and `-t=branch-name` formats

- **Worktree directory name suggestions** for `-w` or `--worktree-name` flag
  - Lists all worktree directory names
  - Works with both `-w worktree-name` and `-w=worktree-name` formats

- **Flag suggestions** when typing `-` or `--`
  - Shows all available flags: `-h`, `--help`, `-t`, `--target-branch`, `-w`, `--worktree-name`, `-s`, `--stash-changes`

## Automatic Setup

**Completions are automatically configured during installation!**

When you install gitsy via npm, the postinstall script automatically:

1. Detects your shell (bash or zsh)
2. Adds the completion script to your shell configuration file (`~/.bashrc`, `~/.bash_profile`, or `~/.zshrc`)
3. Checks for duplicate entries to avoid adding multiple times

After installation, simply restart your shell or run:

```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc
```

That's it! Auto-completion will now work for `g-wr` commands.

## Manual Setup (Optional)

If the automatic setup didn't work or you prefer manual installation:

### Bash

Add the following to your `~/.bashrc` or `~/.bash_profile`:

```bash
# Gitsy completions
[ -f "$(npm root -g)/@san-siva/gitsy/completions/g-wr-completion.bash" ] && source "$(npm root -g)/@san-siva/gitsy/completions/g-wr-completion.bash"
```

### Zsh

Add the following to your `~/.zshrc`:

```zsh
# Gitsy completions
[ -f "$(npm root -g)/@san-siva/gitsy/completions/g-wr-completion.zsh" ] && source "$(npm root -g)/@san-siva/gitsy/completions/g-wr-completion.zsh"
```

## Usage Examples

Once installed, you can use tab completion with `g-wr`:

```bash
# Show all available flags
g-wr -<TAB>

# Complete branch names
g-wr -t <TAB>
g-wr -t=<TAB>
g-wr --target-branch <TAB>

# Complete worktree directory names
g-wr -w <TAB>
g-wr -w=<TAB>
g-wr --worktree-name <TAB>
```

## Troubleshooting

### Completions not working

1. Make sure you restarted your shell after installation
2. Verify the completion was added to your config file:
   ```bash
   # For bash
   grep -i "gitsy" ~/.bashrc

   # For zsh
   grep -i "gitsy" ~/.zshrc
   ```
3. Verify the script path is correct: `ls $(npm root -g)/@san-siva/gitsy/completions/`

### No suggestions appearing

1. Make sure you're in a git repository with worktrees
2. Run `git worktree list` to verify worktrees exist
3. Check if bash-completion (Bash) or compinit (Zsh) is enabled

### Removing completions

If you want to remove the auto-completion, simply remove or comment out the lines added to your shell config file:

```bash
# Remove these lines from ~/.bashrc or ~/.zshrc
# Gitsy auto-completion (added by gitsy npm package)
[ -f "..." ] && source "..."
```

## Future Completions

We plan to add auto-completion support for more gitsy commands in future releases:

- g-co (checkout)
- g-wa (create worktree)
- g-pull, g-push
- And more!

## Contributing

If you'd like to contribute completion scripts for other gitsy commands, please submit a pull request!
