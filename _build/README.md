# Develop and build AHK-modules

## Required development tools

* documentation generation from sourcecode: [NaturalDocs](https://www.naturaldocs.org/)

  To install *NaturalDocs*:
  1. just download the [NaturalDocs ZIP-File](https://www.naturaldocs.org/download/)
  2. unzip it to a user defined location
  3. adapt the path to *NaturalDocs.exe* within the file *_build/mkDoc.ahk*

* changelog generation from conventional commits: [git-chglog](https://github.com/git-chglog/git-chglog)
 
   To install *git_chglog*:
   1. just download the [latest release ZIP-File of git-chglog] (https://github.com/git-chglog/git-chglog/tags)
   2. extract *git-chglog.exe* to an user defined location
   3. adapt the path to *git-chglog.exe* within the file *_build/mkDoc.ahk*

## Building the Documentation / Changelog

Go into folder *_build* and run script *mkDoc.ahk* (after you installed and configured the development tools above).

## Auto-Build documentation/changelog on commit

You can use [git hooks](https://www.atlassian.com/git/tutorials/git-hooks) to build the distribution and documentation/changelog files on the fly: on each commit those files can be generated via git hook and be added to the current commit. To enable this you have to add the following files/hooks to your folder *.git/hooks*:

1.) Filename *pre-commit* (Fullpath: *.git/hooks/pre-commit*)

Contents:
```bash
#!/bin/sh
echo 
touch .commit 
exit
```

2.) Filename *pre-commit* (Fullpath: *.git/hooks/post-commit*)

Contents:
```bash
#!/bin/sh
#
echo
if [ -a .commit ]
    then
    rm .commit
	pushd _build
	../../_build/autohotkey.exe mkDoc.ahk
	popd
    git add docs
    git add CHANGELOG.md
    git commit --amend -C HEAD --no-verify
fi
exit
```
