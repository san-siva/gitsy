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

export default function Home() {
	return (
		<Blog>
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
							<code>--target-branch, --stash-changes</code>,
						],
						[
							<code>g-wr</code>,
							'Remove git worktree',
							<code>--target-branch, --worktree-name</code>,
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
							<code>g-wr</code>,
							'Remove Worktree',
							'Remove a git worktree by branch name or worktree directory name.',
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
						multiple worktrees.
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
							</ul>
						</li>
						<li>
							<strong>Worktree creation:</strong>
							<ul>
								<li>Check if worktree already exists for the branch</li>
								<li>
									Sanitize branch name (lowercase, replace special chars with{' '}
									<code>_</code>)
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
								<li>Only works from default branch (main/master)</li>
								<li>Prevents duplicate worktrees</li>
								<li>
									Optional stashing with <code>--stash-changes</code> flag
								</li>
								<li>Clear error messages with actionable guidance</li>
							</ul>
						</li>
					</ul>

					<Callout type="warning" hasMarginDown>
						<p>
							<strong>Important:</strong> Worktrees can only be created from the
							default branch (main/master). If you&apos;re on a different
							branch, commit or stash your changes, checkout to the default
							branch, and try again.
						</p>
					</Callout>
				</BlogSection>

				<BlogSection title="Remove Git Worktree (g-wr)">
					<p className={styles['margin-bottom--2']}>
						Remove a git worktree by branch name or worktree directory name.
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
						<li>Search for the worktree in the worktrees directory</li>
						<li>Check for uncommitted changes in the worktree</li>
						<li>Prompt for confirmation if uncommitted changes exist</li>
						<li>Remove the worktree directory and prune git records</li>
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
					<strong>Author:</strong> Santhosh Siva
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
