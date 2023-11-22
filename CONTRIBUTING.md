# How to contribute to this repository

## General guidelines

* assign someone as reviewer for your pull request
* in PR description: describe what you changed and why

## Workflow with pull requests (PREFERRED)

Work on changes in your own branch and then submit them as a pull request for an Issue.

**Advantage of this approach**: the pull request descriptions will be a way of documentation forcing everyone to explain changes they make.

* make sure your local repository main branch is up to date
* create new branch and switch to it

```
git branch newb
git switch newb
```

* make your local changes
* add the files and commit them

```
git add -A
git commit -m "useful commit message"
```

* push them to your branch with

```
git push origin newb
```

* go to the main page of the repository which will show you a yellow box suggesting a "Compare and Pull Request" of the new branch
* if this is not there just go to the pull requests tab and create a new one selecting your branch

* click on it and in the pull request document the changes you made (what the problem was and how you solved it)

* click on "create pull request"

* then if there are no conflicts click on "merge pull request"

### When working on existing branch update it with

```
git pull origin main
```

### How to use Issues

Whenever you think of something that needs to be implemented later or maybe by someone else create an Issue describing the required changes.

As soon as the pull request that fixed it was made close the issue.

## Centralised workflow

How to contribute something:

* Clone the repo (if not done already)

ssh:

```
git clone git@github.com:ccrownhill/lyraerover
```

https:

```
git clone https://github.com/ccrownhill/lyraerover
```

* make some new changes, for example add file `test.file`

* add the changed files

all files:

```
git add -A
```

specific files:

```
git add test.file
```

* push changes

```
git push origin main
```

* if there was a problem because the central repository has other updates now do

```
git pull --rebase origin main
```

* if there is a merge conflict now:

* change files so conflict is fixed and then use

```
git rebase --continue
```

* then push again

```
git push origin main
```

----

Resources:

* [Git workflows: first describing centralised workflow](https://www.atlassian.com/git/tutorials/comparing-workflows)

* [Free code camp: how to use git in a team like a pro (a little more advanced with different branches, we could consider that later](https://www.freecodecamp.org/news/how-to-use-git-and-github-in-a-team-like-a-pro/)
