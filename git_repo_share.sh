#!/bin/bash

HERE=$(pwd)

# e.g. /path/to/my/local/git/repo
# with .git in it
GIT_LOCAL=$1

# place I want to untar the remote version of that git repo
# e.g. /path/to/my/share/drive/folder
SHARE_DIR=$2

# name of the repo, usually, but some shared prefix
PREFIX_NAME=$3

# github remote name
# e.g. origin
REMOTE_NAME=$4

# github branch name or tag
# e.g. master
REFSPEC=$5

cd $GIT_LOCAL

echo ""
echo " REMOVING FILES "
echo ""
rm -rvf $SHARE_DIR/$PREFIX_NAME

echo ""
echo " MAKING SNAPSHOT "
echo ""
git archive -v --remote=$REMOTE_NAME --prefix=$PREFIX_NAME/ $REFSPEC | (cd $SHAREDIR && tar xvf -)

cd $HERE