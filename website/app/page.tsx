import {
	Blog,
	BlogHeader,
	BlogSection,
	CodeBlock,
	Callout,
	Table,
} from '@san-siva/blogkit';
import styles from './page.module.scss';
import { HELP_TEXT, CODE_EXAMPLES } from './codeExamples';
import { SITE_URL } from './constants';

export default function Home() {
	return (
		<Blog
			jsonLd={{
				'@context': 'https://schema.org',
				'@type': 'SoftwareApplication',
				name: 'Gitsy',
				description:
					'Versatile bash utilities for managing Git repositories with ease. Automate common Git operations like checkout, push, pull, worktrees, and more.',
				applicationCategory: 'DeveloperApplication',
				operatingSystem: 'macOS, Linux',
				author: {
					'@type': 'Person',
					name: 'Santhosh Siva',
					url: 'https://santhoshsiva.dev',
				},
				url: SITE_URL,
			}}
		>
			<BlogHeader title={['Gitsy']} desc={['Git commands, turbocharged']} />
			<BlogSection title="Overview">
				<p>
					<strong>Gitsy</strong> is a set of versatile bash utilities designed
					to make managing Git repositories easier, faster, and more efficient.
					It provides user-friendly commands to automate common Git operations
					such as checking out branches, pushing, pulling, creating worktrees,
					stashing changes, and viewing git status — all enhanced with helpful
					prompts, color-coded outputs, and automation.
				</p>
			</BlogSection>

			<BlogSection title="System Requirements">
				<Table
					headers={['Requirement', 'Details']}
					rows={[
						['Node.js', '>= 12.0.0'],
						['Shell', 'Bash'],
						['Version Control', 'Git'],
						['Dependencies', 'figlet, lolcat'],
						['Supported OS', 'macOS, Linux'],
					]}
				/>
			</BlogSection>

			<BlogSection title="Command Reference">
				<Table
					headers={['Command', 'Description', 'Key Flags']}
					rows={[
						[
							<code>g-co</code>,
							'Checkout branch',
							<code>--target-branch, --stash-changes</code>,
						],
						[
							<code>g-pull</code>,
							'Pull changes from remote',
							<code>--target-branch, --fetch</code>,
						],
						[
							<code>g-push</code>,
							'Push changes to remote',
							<code>--target-branch, --force</code>,
						],
						[
							<code>g-wa</code>,
							'Create git worktree',
							<code>--target-branch, --worktree-name, --stash-changes</code>,
						],
						[<code>g-wl</code>, 'List all git worktrees', 'None'],
						[
							<code>g-wr</code>,
							'Remove git worktree',
							<code>--target-branch, --worktree-name, --all, --force</code>,
						],
						[
							<code>g-wh</code>,
							'Detect and repair bricked worktree / prune',
							<code>
								--target-branch, --worktree-name, --all, --dry-run, --force
							</code>,
						],
						[<code>g-db</code>, 'Delete branch', <code>--target-branch</code>],
						[<code>g-dlc</code>, 'Discard last commit', <code>--force</code>],
						[
							<code>g-rmf</code>,
							'Stash working directory',
							<code>--message</code>,
						],
						[<code>g-rto</code>, 'Reset to remote branch', 'None'],
						[<code>g-cb</code>, 'Show current branch', 'None'],
						[<code>g-s</code>, 'Show git status', 'None'],
						[
							<code>g-diff</code>,
							'Compare branches',
							<code>
								--source-branch, --target-branch, --full, --files-only
							</code>,
						],
					]}
				/>
			</BlogSection>

			<BlogSection title="Features">
				<Table
					headers={['Feature', 'Title', 'Description']}
					rows={[
						[
							<code>g-co</code>,
							'Checkout Branch',
							'Checkout to a branch with optional stash, automatically handles local and remote branches.',
						],
						[
							<code>g-pull</code>,
							'Pull Changes',
							'Pull changes from a remote branch. If no branch is specified, it pulls for the current branch.',
						],
						[
							<code>g-push</code>,
							'Push Changes',
							'Push changes to a remote branch, with optional force flag for overwriting remote history.',
						],
						[
							<code>g-wa</code>,
							'Create Worktree',
							'Create a new git worktree with automatic repository restructuring. Organizes your repo into main/ and worktrees/ directories for better branch isolation.',
						],
						[
							<code>g-wl</code>,
							'List Worktrees',
							'List all active worktrees along with their branch names in an aligned table. Automatically prunes stale entries whose directories no longer exist.',
						],
						[
							<code>g-wr</code>,
							'Remove Worktree',
							'Remove a git worktree by branch or directory name, prune stale worktree records, or remove all worktrees except main using --all.',
						],
						[
							<code>g-wh</code>,
							'Heal Worktree',
							'Detect and repair bricked worktrees: fixes broken submodule gitdirs, clears stale index.lock files, and prunes orphaned worktree registrations.',
						],
						[
							<code>g-db</code>,
							'Delete Branch',
							'Delete a branch locally and optionally push the deletion to remote.',
						],
						[
							<code>g-dlc</code>,
							'Discard Commit',
							'Discard the last commit with optional force mode to hard reset.',
						],
						[
							<code>g-rmf</code>,
							'Stash Changes',
							'Stash all changes in working directory with a timestamped message.',
						],
						[
							<code>g-rto</code>,
							'Reset to Remote',
							'Reset working directory hard to the latest remote branch, stashing changes first.',
						],
						[
							<code>g-cb</code>,
							'Current Branch',
							'Display the current git branch name.',
						],
						[
							<code>g-s</code>,
							'Git Status',
							'Show the output of git status with color formatting.',
						],
						[
							<code>g-diff</code>,
							'Compare Branches',
							'Compare and show differences between two branches.',
						],
					]}
				/>
			</BlogSection>

			<BlogSection title="Installation">
				<p>
					Install gitsy globally using npm. You&apos;ll also need to install the
					required dependencies (git, figlet, lolcat) for your platform:
				</p>
				<CodeBlock
					language="bash"
					code={CODE_EXAMPLES.installation}
					hasMarginUp
					hasMarginDown
				/>
				<p className={styles['margin-top--2']}>
					Once installed, all commands (<code>g-s</code>, <code>g-co</code>,{' '}
					<code>g-pull</code>, etc.) will be available globally in your
					terminal.
				</p>
			</BlogSection>

			<BlogSection title="Commands">
				<p>
					Each script corresponds to a Git-related utility. Below is a
					comprehensive guide on all available commands.
				</p>

				<BlogSection title="Checkout Branch (g-co)">
					<p className={styles['margin-bottom--2']}>
						Checkout to a branch, with optional stash.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.checkout}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.checkout}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Check if the branch exists locally</li>
						<li>Search for the branch on remote if not found locally</li>
						<li>Prompt to create a new branch if it doesn't exist</li>
						<li>
							Stash changes if <code>--stash-changes</code> flag is provided
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="Pull Changes (g-pull)">
					<p className={styles['margin-bottom--2']}>
						Pull changes from a remote branch.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.pull}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.pull}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Use current branch if no branch is specified</li>
						<li>
							Fetch changes from remote if <code>-f/--fetch</code> flag is
							provided
						</li>
						<li>Pull and merge changes from the target branch</li>
					</ul>
				</BlogSection>

				<BlogSection title="Push Changes (g-push)">
					<p className={styles['margin-bottom--2']}>
						Push changes to a remote branch, optionally with force.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.push}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.push}
						hasMarginUp
						hasMarginDown
					/>
					<Callout type="warning" hasMarginDown>
						<p>
							<strong>Warning:</strong> Using <code>--force</code> will
							overwrite remote history. This can cause data loss for
							collaborators who have already pulled the branch. Only use force
							push when you&apos;re certain it&apos;s safe.
						</p>
					</Callout>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Use current branch if no branch is specified</li>
						<li>Push changes to the remote repository</li>
						<li>
							Force push if <code>--force</code> flag is provided (use with
							caution)
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="Create Git Worktree (g-wa)">
					<p className={styles['margin-bottom--2']}>
						Create a new git worktree with intelligent repository restructuring.
						On first use, automatically reorganizes your repository to support
						multiple worktrees. New branches are created from your current
						branch, preserving your branch context.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.worktree}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.worktree}
						hasMarginUp
						hasMarginDown
					/>

					<Callout type="info" hasMarginDown>
						<div>
							<p className={styles['margin-bottom--1']}>
								<strong>Repository Restructuring:</strong> On first use,{' '}
								<code>g-wa</code> will automatically reorganize your repository:
							</p>
							<ul>
								<li>
									Moves your repository into a <code>main/</code> subdirectory
								</li>
								<li>
									Creates a <code>worktrees/</code> directory for feature
									branches
								</li>
								<li>Provides step-by-step feedback throughout the process</li>
								<li>Requires confirmation before making any changes</li>
							</ul>
							<p className={styles['margin-top--2']}>
								<strong>Final structure:</strong>
							</p>
							<CodeBlock
								language="text"
								code={CODE_EXAMPLES.worktreeStructure}
								hasMarginUp
							/>
						</div>
					</Callout>

					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul className={styles['margin-bottom--2']}>
						<li>
							<strong>Repository restructuring (first time only):</strong>
							<ul>
								<li>Detect if restructuring is needed</li>
								<li>
									Move repository contents to <code>main/</code> subdirectory
								</li>
								<li>
									Create <code>worktrees/</code> directory structure
								</li>
								<li>Checkout default branch in main directory</li>
								<li>
									Create worktree for your original branch (if not on default
									branch)
								</li>
								<li>
									Navigate to original branch worktree to preserve context
								</li>
							</ul>
						</li>
						<li>
							<strong>Worktree creation:</strong>
							<ul>
								<li>Check if worktree already exists for the branch</li>
								<li>
									Use custom directory name if <code>--worktree-name</code> is
									specified, otherwise sanitize branch name (lowercase, replace
									special chars with <code>_</code>)
								</li>
								<li>
									Convert to absolute path for clarity (e.g.{' '}
									<code>
										/Users/you/projects/your-repo/worktrees/feature_name
									</code>
									)
								</li>
								<li>
									Truncate long names to 30 characters with ".." suffix (e.g.{' '}
									<code>feature/this-is-a-very-long-branch-name</code> →{' '}
									<code>feature_this_is_a_very_long_br..</code>)
								</li>
								<li>Check if branch exists locally or remotely</li>
								<li>Prompt to create new branch if it doesn't exist</li>
								<li>Automatically push new branches to remote</li>
							</ul>
						</li>
						<li>
							<strong>Safety features:</strong>
							<ul>
								<li>
									New branches are created from your current branch (preserves
									branch context)
								</li>
								<li>Prevents duplicate worktrees</li>
								<li>
									Optional stashing with <code>--stash-changes</code> flag
								</li>
								<li>
									Custom directory naming with <code>--worktree-name</code> flag
								</li>
								<li>
									Requires confirmation before restructuring or creating
									worktrees
								</li>
								<li>Clear error messages with actionable guidance</li>
							</ul>
						</li>
					</ul>

					<Callout type="info" hasMarginDown>
						<p>
							<strong>Branch Context:</strong> When creating a new branch, it
							will be cut from your current branch. For example, if you&apos;re
							on <code>develop</code> and run <code>g-wa -t feature/new</code>,
							the new branch will be created from <code>develop</code>, not from{' '}
							<code>main</code>. This ensures your new branch inherits the
							correct context.
						</p>
					</Callout>
				</BlogSection>

				<BlogSection title="List Git Worktrees (g-wl)">
					<p className={styles['margin-bottom--2']}>
						List all active git worktrees along with their checked out branch
						names in an aligned table.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.worktreeList}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.worktreeList}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>
							Automatically prune stale worktree records whose directories were
							deleted on disk
						</li>
						<li>
							Display directory names, branch names, and detached HEAD states in
							a formatted table
						</li>
						<li>Show the total count of active worktrees</li>
					</ul>
				</BlogSection>

				<BlogSection title="Remove Git Worktree (g-wr)">
					<p className={styles['margin-bottom--2']}>
						Remove a git worktree by branch name or worktree directory name,
						prune stale worktree registrations, or remove all worktrees except
						main with <code>--all</code>.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.worktreeRemove}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.worktreeRemove}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>
							Search for the worktree in the worktrees directory or Git's worktree
							records
						</li>
						<li>
							Support removing all worktrees except <code>main</code> with{' '}
							<code>-a/--all</code>
						</li>
						<li>Check for uncommitted changes in the worktree before removal</li>
						<li>
							Prompt for confirmation before removal (skip with{' '}
							<code>-f/--force</code>)
						</li>
						<li>
							Safely navigate your shell to <code>main</code> if invoked from
							inside a removed worktree
						</li>
						<li>
							Automatically prune dead registrations from Git if the directory
							was deleted manually
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="Heal Git Worktree (g-wh)">
					<p className={styles['margin-bottom--2']}>
						Detect and repair bricked git worktrees, broken submodule gitdirs,
						stale <code>index.lock</code> files, and orphaned worktree
						registrations.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.worktreeHeal}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.worktreeHeal}
						hasMarginUp
						hasMarginDown
					/>
					<Callout type="info" hasMarginDown>
						<div>
							<p className={styles['margin-bottom--1']}>
								<strong>Targeted Failure Modes:</strong>
							</p>
							<ul>
								<li>
									<strong>Broken submodule gitdirs:</strong> When submodule
									setup is interrupted mid-operation, incomplete gitdirs cause{' '}
									<code>fatal: not a git repository</code> errors.{' '}
									<code>g-wh</code> removes incomplete gitdirs and re-runs
									submodule update.
								</li>
								<li>
									<strong>Stale index.lock files:</strong> Interrupted git
									processes leave lock files preventing further git actions.
								</li>
								<li>
									<strong>Stale / prunable worktrees:</strong> When worktree
									directories are deleted manually without <code>g-wr</code>, Git
									retains orphaned metadata that prevents re-checking out
									branches. <code>g-wh</code> detects these and cleanly prunes
									them.
								</li>
							</ul>
						</div>
					</Callout>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>
							Heal the current worktree directory when run with no options
						</li>
						<li>
							When run in <code>main</code> or with <code>-a/--all</code>, detect
							and offer to prune all stale worktrees in the repo
						</li>
						<li>
							Target individual worktrees by branch (<code>-t</code>) or
							directory name (<code>-w</code>)
						</li>
						<li>
							Preview detected issues and proposed fixes with{' '}
							<code>--dry-run</code>
						</li>
						<li>
							Skip confirmation prompts with <code>-f/--force</code>
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="Delete Branch (g-db)">
					<p className={styles['margin-bottom--2']}>
						Delete a branch locally and optionally push the deletion to remote.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.deleteBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.deleteBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Prompt for confirmation before deleting the branch</li>
						<li>Check if the branch exists locally</li>
						<li>
							Delete the local branch (requires branch to be fully merged)
						</li>
						<li>Prompt to delete the branch on remote if it exists</li>
					</ul>
				</BlogSection>

				<BlogSection title="Discard Last Commit (g-dlc)">
					<p className={styles['margin-bottom--2']}>
						Discard the last commit with optional force mode.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.discardCommit}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.discardCommit}
						hasMarginUp
						hasMarginDown
					/>
					<Callout type="warning" hasMarginDown>
						<p>
							<strong>Warning:</strong> Using <code>--force</code> performs a
							hard reset, permanently discarding all uncommitted changes in your
							working directory. This action cannot be undone.
						</p>
					</Callout>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Prompt for confirmation before discarding</li>
						<li>
							Check for uncommitted changes (unless <code>--force</code> is
							used)
						</li>
						<li>
							Perform soft reset (keeps changes) or hard reset (discards
							changes) based on <code>--force</code> flag
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="Stash Working Directory (g-rmf)">
					<p className={styles['margin-bottom--2']}>
						Clear your working directory by stashing all changes with a
						timestamped message.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.stash}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.stash}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Create a timestamped stash message if none is provided</li>
						<li>Stash all uncommitted changes (staged and unstaged)</li>
						<li>Clear your working directory</li>
					</ul>
				</BlogSection>

				<BlogSection title="Reset To Remote Branch (g-rto)">
					<p className={styles['margin-bottom--2']}>
						Reset your working directory hard to the latest remote branch,
						stashing changes beforehand.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.reset}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.reset}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Stash any uncommitted changes</li>
						<li>Fetch the latest changes from remote</li>
						<li>Perform a hard reset to the remote branch</li>
						<li>
							Pull the latest changes (⚠️ this is destructive, stashes changes
							first)
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="Current Branch (g-cb)">
					<p className={styles['margin-bottom--2']}>
						Display the current git branch name.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.currentBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.currentBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Fetch the current branch name</li>
						<li>Display the branch name</li>
						<li>Copy the branch name to your clipboard</li>
					</ul>
				</BlogSection>

				<BlogSection title="Git Status (g-s)">
					<p className={styles['margin-bottom--2']}>
						Show the output of <code>git status</code>.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.status}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.status}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Fetch the current branch name</li>
						<li>Display git status with color formatting</li>
						<li>Show staged, unstaged, and untracked files</li>
					</ul>
				</BlogSection>

				<BlogSection title="Compare Branches (g-diff)">
					<p className={styles['margin-bottom--2']}>
						Compare and show differences between two branches.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.diff}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.diff}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul className={styles['margin-bottom--4']}>
						<li>Use current branch as source if not specified</li>
						<li>Fetch the latest changes for the target branch</li>
					</ul>

					<p className={styles['margin-bottom--2']}>
						<strong>Default mode (no flags):</strong>
					</p>
					<ul className={styles['margin-bottom--2']}>
						<li>
							Show a stat summary of changes (files changed, insertions,
							deletions)
						</li>
						<li>Copy stats to clipboard</li>
					</ul>
					<p className={styles['margin-bottom--2']}>
						Example clipboard content:
					</p>
					<CodeBlock
						language="text"
						code={CODE_EXAMPLES.diffStatsExample}
						hasMarginUp
						hasMarginDown
					/>

					<p className={styles['margin-top--4']}>
						<strong>
							With <code>--files-only</code>:
						</strong>
					</p>
					<ul className={styles['margin-bottom--2']}>
						<li>Show only file names without stats</li>
						<li>No clipboard copying</li>
					</ul>
					<p className={styles['margin-bottom--2']}>Example output:</p>
					<CodeBlock
						language="text"
						code={CODE_EXAMPLES.diffFilesOnlyExample}
						hasMarginUp
						hasMarginDown
					/>

					<p className={styles['margin-top--4']}>
						<strong>
							With <code>--full</code>:
						</strong>
					</p>
					<ul className={styles['margin-bottom--2']}>
						<li>Display the complete diff output with all changes</li>
						<li>
							Copy the formatted diff to clipboard (full diff content with color
							codes stripped)
						</li>
					</ul>
					<p className={styles['margin-bottom--2']}>
						Example clipboard content:
					</p>
					<CodeBlock
						language="text"
						code={CODE_EXAMPLES.diffFullExample}
						hasMarginUp
						hasMarginDown
					/>
				</BlogSection>
			</BlogSection>

			<BlogSection title="Contributing">
				<p className={styles['margin-bottom--1']}>
					Contributions are welcome! Please fork the repository and submit pull
					requests. For bugs or feature requests, open an issue on the
					repository.
				</p>
				<a
					href="https://github.com/san-siva/gitsy"
					target="_blank"
					rel="noopener noreferrer"
					className={styles['a--highlighted']}
				>
					View source code, report issues, and contribute
				</a>
			</BlogSection>

			<BlogSection title="License">
				<p>This project is licensed under the MIT License.</p>
			</BlogSection>

			<BlogSection title="About">
				<p>
					<strong>Author:</strong>{' '}
					<a
						href="https://santhoshsiva.dev"
						target="_blank"
						rel="noopener noreferrer"
						className={styles['a--highlighted']}
					>
						Santhosh Siva
					</a>
					<br />
					<strong>GitHub:</strong>{' '}
					<a
						href="https://github.com/san-siva"
						target="_blank"
						rel="noopener noreferrer"
						className={styles['a--highlighted']}
					>
						https://github.com/san-siva
					</a>
				</p>
			</BlogSection>
		</Blog>
	);
}
