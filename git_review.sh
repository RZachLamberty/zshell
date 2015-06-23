#!/bin/bash

GITDIR=${1:-/home/zlamberty/git}
cd $GITDIR

for i in $(find . -regex ".*.git$"); do
    GITBASE=${i%/*};
    echo "====================================================="
    echo "GIT REPO: ${GITBASE}"
    cd $GITBASE
    git status --porcelain;
    cd $GITDIR
done
