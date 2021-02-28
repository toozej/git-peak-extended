# git-peak-extended

## Overview
git-peak-extended uses the same basic idea as [git-peak][git-peak] but takes it a few steps further:

1. Supports saving git repos either to temporary storage (like [git-peak][git-peek]), but alternatively, to permanent storage for future use.
2. Supports the three most common public git providers: [GitHub][github], [GitLab][gitlab], [sourcehut][sourcehut], and [BitBucket][bitbucket].
3. Supports HTTPS, Git, and short-hand formatted repo URLs to clone

Like [git-peak][git-peak], git-peak-extended is written in Bash for portability, ease of use, and extendability. 

In essence git-peak-extended chains together common tools like `sed`, `git`, `ssh`, and `mktemp` to allow users to quickly view git repos or permanently save them to disk in a configurable location for future use.


## Inspirations
git-peak-extended is inspired by similar repos posted in Hacker News [1](https://news.ycombinator.com/item?id=26083919) [2](https://news.ycombinator.com/item?id=26108039) [3](https://news.ycombinator.com/item?id=26110114) [4](https://news.ycombinator.com/item?id=26129986) recently:

1. [github1s][github1s] by cownet
2. [git-peek][git-peek] by Jarred Sumner
3. [git-peak][git-peak] by Alex David
4. [repo-peek][repo-peek] by Rahul Nair

Specifically it is an extended version of #3 above, [git-peak][git-peak]. 

### Why git-peak-extended?
With so many similar repos as noted [above in the inspirations section](#inspirations), why did I decide to write git-peak-extended? A few reasons really:

1. I often find myself wanting to be able to quickly store git repos from a terminal without having to faff around copy/pasting `git clone`-style links.
2. I wanted to be able to view repos using one $EDITOR [VSCode][vscode] while storing repos permanently and opening them with another $EDITOR [vim][vim].
    - I find the GUI-centric nature of [VSCode][vscode] easier for quick perusing and determining what a repo is and does than my main editing-focused usage of [vim][vim]
3. More practice writing Bash scripts
4. More specifically testing Bash scripts with GitHub Actions

## Usage
1. Install pre-requisites
    - bash
    - git
    - jq
    - curl
    - coreutils (for the mktemp binary)
    - If you're using an apt-based distribution, you can typically install these with:
        ```bash
        sudo apt-get install -y bash git jq curl coreutils
        ```
    - If you're using a dnf-based distribution, you can typically install these with:
        ```bash
        sudo dnf install -y bash git jq curl coreutils
        ```
    - If you're using MacOS, you can typically install these with homebrew:
        ```
        brew install bash git jq curl
        ```
2. Download git-peak-extended:
    - Using cURL: `curl -sLo ./git-peak-extended https://raw.githubusercontent.com/toozej/git-peak-extended/main/git-peak-extended && chmod u+x ./git-peak-extended` 
    - Using Wget: `wget -q -O ./git-peak-extended https://raw.githubusercontent.com/toozej/git-peak-extended/main/git-peak-extended && chmod u+x ./git-peak-extended` 
    - Using git: `git clone git@github.com:toozej/git-peak-extended.git`
    - Using git-peak-extended (meta!): `git-peak-extended toozej/git-peak-extended`

3. Find a repo to you want to "peek", and get the `GIT_REPO_URL` in any one of these supported formats:
    - `https://$git_provider/$username/$repo.git`
    - `git@$git_provider:$username/$repo.git`
    - `$username/$repo`
        - git-peak-extended will first search [GitHub][github], then [GitLab][gitlab], then [soucehut][sourcehut] and finally [BitBucket][bitbucket]. If repo not found, git-peak-extended will print an error message and exit 

4. Temporarily clone and view a git repo: `./git-peak-extended GIT_REPO_URL`
    - For more explicit usage (like in aliases), you can alternatively use `./git-peak-extended --temp GIT_REPO_URL` or the `-t` flag to mean the same thing

5. Permanently clone and view a git repo: `./git-peak-extended --save GIT_REPO_URL`
    - Alternatively, the `-s` short-hand flag, `--permanent` or `-p` short-hand flags do the same thing

6. Optional arguments affecting both "temporary" and "permanent" modes are as follows:
    - `./git-peak-extended <arguments> GIT_REPO_URL`
    - If you want to specify a non-default directory to store, you can use `--dir </path/to/dir>`
    - If you want to change the default editor used to open the git repo using either of these methods:
        - Temporarily set the editor for this one-time usage of git-peak-extended: `EDITOR=<some_different_editor> ./git-peak-extended <arguments> GIT_REPO_URL`
        - Permanently set the editor by editing your shell's configuration file, adding or adjusting a line like this: `export EDITOR='<some_different_editor>'`


### Assumptions
- Already have git and mktemp packages installed
- Already have $EDITOR environment variable configured for your favourite editor 
- Port 22 not blocked so you can use git over SSH
- git config is set up for various git providers like [GitHub][github] or [GitLab][gitlab]
- SSH config already set up with entry for git providers using IdentityFile with the same SSH key added to your git provider user profiles
- SSH agent has your key loaded to facilitate fast usage (don't need to enter password each time)

### Examples
Below are examples of how I use git-peak-extended:

1. Download it to ~/bin/git-peak-extended and set as executable:
```bash
curl -sLo ~/bin/git-peak-extended https://raw.githubusercontent.com/toozej/git-peak-extended/main/git-peak-extended && chmod u+x ~/bin/git-peak-extended
```

2. Alias `gp` to git-peak-extended's default mode (temporarily grab repo)
```bash
echo 'alias gp="EDITOR=vscode $HOME/bin/git-peak-extended --temp"' >> ~/.aliases 
```

3. Alias `gps` to git-peak-extended's save permanently mode
```bash
echo 'alias gps="EDITOR=vim $HOME/bin/git-peak-extended --save"' >> ~/.aliases 
```

[bitbucket]: https://bitbucket.org/
[git-peak]: https://git.sr.ht/~alexdavid/dotfiles/tree/master/bin/git-peak
[git-peek]: https://github.com/jarred-sumner/git-peek
[github1s]: https://github.com/conwnet/github1s 
[github]: https://github.com
[gitlab]: https://gitlab.com
[repo-peek]: https://github.com/rahulunair/repo-peek
[sourcehut]: https://git.sr.ht/
[vim]: https://www.vim.org/
[vscode]: https://code.visualstudio.com/
