 #!/bin/bash

set -e # fail script if any commands fail

git remote add origin git@github.com:typhoon-framework/Typhoon.git || true # allow `remote add` to fail without failing script
git remote set-url origin git@github.com:typhoon-framework/Typhoon.git
git fetch origin gh-pages:gh-pages
git fetch origin gh-pages
git stash
git checkout gh-pages
git branch --set-upstream-to=origin/gh-pages gh-pages
git pull
cp -fr build/reports/build-status/build-status.png ./build-status/build-status.png

git commit -a -m "publish reports to gh-pages" || true
git push -u origin gh-pages
git checkout master
