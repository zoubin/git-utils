# git-utils

- [Installation](#installation)
- Commands
  - [git xclone](#git-xclone)
  - [git xpull](#git-xpull)
  - [git xgrep](#git-xgrep)
  - [git blame-stat](#git-blame-stat)
  - [git diff-stat](#git-diff-stat)
  - [git diff-blame](#git-diff-blame)

## Installation
```bash
git clone https://github.com/zoubin/git-utils.git
cd git-utils
echo "export PATH="'"'`pwd`"/bin:\$PATH"'"' >> ~/.bash_profile
```
## git xclone
```bash
git xclone remote-url remote-url

```

## git xpull
```bash
git xpull repo-dir-1 repo-dir-2
git xpull

```

## git xgrep
```bash
git xgrep -noE keywords -- -- repo-dir-1 repo-dir-2
git xgrep -noE keywords

```

## git blame-stat
![example-git-blame-stat](example-git-blame-stat.png)

## git diff-stat
![example-git-diff-stat](example-git-diff-stat.png)

## git diff-blame
![example-git-diff-blame](example-git-diff-blame.png)
