# gitsy

A set of bash utilities for managing Git repositories with ease. Provides user-friendly commands with helpful prompts, color-coded outputs, and automation.

## Documentation

For complete documentation, usage examples, and detailed command reference, visit the [gitsy documentation website](https://gitsy-56895.web.app).

## Available Commands

- `g-co` - Checkout branch
- `g-pull` - Pull changes from remote
- `g-push` - Push changes to remote
- `g-wa` - Create git worktree
- `g-wr` - Remove git worktree
- `g-db` - Delete branch
- `g-dlc` - Discard last commit
- `g-rmf` - Stash working directory
- `g-rto` - Reset to remote branch
- `g-cb` - Show current branch
- `g-s` - Show git status
- `g-diff` - Compare branches

## Installation

### Quick Install (npm)

Install globally using npm:

```bash
npm install -g gitsy
```

### Prerequisites

Ensure you have the following dependencies installed:
- `git` - Version control system
- `figlet` - ASCII art text generator
- `lolcat` - Colorful output formatter

Install dependencies:
```bash
# macOS
brew install git figlet lolcat

# Ubuntu/Debian
sudo apt-get install git figlet lolcat

# Fedora/RHEL
sudo dnf install git figlet lolcat
```

### Verify Installation

```bash
g-s --help
```

### Manual Installation (Alternative)

If you prefer to install manually:

1. Clone the repository:
```bash
git clone https://github.com/san-siva/gitsy.git
cd gitsy
```

2. Install dependencies (see Prerequisites above)

3. Add gitsy to your PATH by adding this line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, or `~/.bash_profile`):
```bash
export PATH="$PATH:$HOME/path/to/gitsy"
```

4. Reload your shell configuration:
```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc
```

## Usage

Run any command with `--help` to see available options:
```bash
g-co --help
```

## Contributing

Contributions are welcome! Please fork the repo and submit pull requests. For bugs or feature requests, open an issue on the repository.

## License

This project is licensed under the MIT License.

## Contact

Author: Santhosh Siva
GitHub: https://github.com/san-siva
