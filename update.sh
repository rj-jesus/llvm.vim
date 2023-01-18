#!/bin/bash


set -e

LLVM_GIT=${LLVM_GIT:-$HOME/llvm}
LLVM_TMP=${LLVM_TMP:-`mktemp -du`}
LLVM_URL=${LLVM_URL:-https://github.com/llvm/llvm-project}
LLVM_VIM=${LLVM_VIM:-$HOME/llvm.vim}

[ -d $LLVM_GIT ] || git clone $LLVM_URL $LLVM_GIT

cd $LLVM_GIT
git pull

mkdir -p $LLVM_TMP
cp -a .git $LLVM_TMP/
cp -a --parents llvm/utils/vim $LLVM_TMP/

cd $LLVM_TMP
git filter-repo --subdirectory-filter llvm/utils/vim --force

cd $LLVM_VIM
git pull --no-edit $LLVM_TMP
git log -1 --pretty=oneline | grep -q $LLVM_TMP && git commit --amend -m "Merge upstream into main"
git push origin main
rm -rf $LLVM_TMP
