#!/usr/bin/fish
# jq typesync sort-package-json

read -p 'echo "Project name » "' project_name
read -p 'echo "GitHub repository » "' -c yarnaimo/$project_name repository

git clone --depth=1 git@github.com:yarnaimo/tss.git $project_name
cd $project_name
rm -rf .git
git init
git remote add origin git@github.com:$repository.git
git fetch origin
git checkout master
git branch -u origin/master master
git merge

set package_json (cat package.json)
echo $package_json \
 | jq '.repository = "github:'$repository'"' \
 > package.json

yarn init
yarn add config js-yaml
yarn add -D typescript ts-node jest ts-jest @types/node
typesync
yarn

sort-package-json
