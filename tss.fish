#!/usr/bin/fish
# required: jq

set github_url git@github.com
set y yarnaimo

read -p 'echo "Project name » "' project_name
read -p 'echo "Scoped? (y/n) » "' is_scoped
read -p 'echo "GitHub repository » "' -c $y/$project_name repository

if test $is_scoped = 'y'
    set package_name @$y/$project_name
    set directory @{$y}_$project_name
else
    set package_name $project_name
    set directory $project_name
end

git clone $github_url:$repository.git $directory
cd $directory

git remote add tss $github_url:$y/tss.git
git fetch --depth 1 tss
git merge --allow-unrelated-histories tss/master

set package_json (cat package.json)
echo $package_json \
 | jq '.name = "'$package_name'" | .repository = "github:'$repository'"' \
 > package.json

yarn add -D @$y/tss
yarn add @$y/rain

node_modules/.bin/sort-package-json
