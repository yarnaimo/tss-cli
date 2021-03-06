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
git update-ref -d HEAD

cat package.json \
 | jq ".name = \"$package_name\" | .repository = \"github:$repository\"" \
 > package.json

yarn add -D @$y/tss
yarn add @$y/rain
node_modules/.bin/sort-package-json

git add --all
git commit -a -m '🎉 Initial commit'
git push -f
