 #!/bin/bash

set -e # fail script if any commands fail
set -o pipefail

#find Tests/ -type f -exec git update-index --assume-unchanged '{}' \; &> ${temp.dir}/index.out
git remote add origin git@github.com:typhoon-framework/Typhoon.git || true # allow `remote add` to fail without failing script
git remote set-url origin git@github.com:typhoon-framework/Typhoon.git
git fetch origin gh-pages:gh-pages
git fetch origin gh-pages
git stash
git checkout gh-pages
git branch --set-upstream-to=origin/gh-pages gh-pages
git pull
cp -fr ${reports.dir}/build-status/build-status.png ./build-status/build-status.png
#rm -fr ./coverage
#mkdir -p ${reports.dir}/coverage
#cp -fr ${reports.dir}/coverage/ ./coverage
#git add --all --ignore-removal ./coverage
#rm -fr ./api
#cp -fr ${reports.dir}/api ./api
#git add --all --ignore-removal api
#rm -fr ./test-results
#cp -fr ${reports.dir}/test-results/ ./test-results
#git add --all --ignore-removal ./test-results

git commit -a -m "publish reports to gh-pages"
git push -u origin gh-pages
git checkout master
#find Tests -type f -exec git update-index --no-assume-unchanged '{}' \;