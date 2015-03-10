 #!/bin/bash

reportsDir=build/reports
resourceDir=Resources

#Publish build results
echo '--------------------------------------------------------------------------------'
echo 'Publishing build results'
echo '--------------------------------------------------------------------------------'

git remote add origin git@github.com:typhoon-framework/Typhoon.git || true # allow `remote add` to fail without failing script
git remote set-url origin git@github.com:typhoon-framework/Typhoon.git
git fetch origin gh-pages:gh-pages
git fetch origin gh-pages
git stash
git checkout gh-pages
git branch --set-upstream-to=origin/gh-pages gh-pages
git pull
ditto build/reports/build-status/build-status.png ./build-status/build-status.png
git add build-status

rm -fr ./docs/latest/api
cp -fr ${reportsDir}/api ./docs/latest/api
git add docs/latest/api

git commit -a -m "publish reports to gh-pages" || true # allow `remote add` to fail without failing script (if nothing to add)
git push -u origin gh-pages
git checkout master
git pull
