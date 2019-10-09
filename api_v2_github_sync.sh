#!/bin/sh
env=develop
git_branch='develop'
root_path='/var/www/html/'

hostname=`hostname`

echo "starting to sync up code"

# start to folder
if [ -d "$root_path$env" ]
then
	echo "$path found."
else
    mkdir $root_path$env
    cd $root_path
    git clone --recursive https://bomdicsw:8a2f18dd1438acab59fd0c4fbcd114c440f0b29a@github.com/bOMDIC/API_GoMore2.0.git $env
    git submodule init
    git submodule update --init --recursive
fi

git submodule update --init --recursive

cd $root_path$env

current_branch=`git rev-parse --abbrev-ref HEAD`

git reset --hard
git checkout $git_branch

echo pull code
git pull origin $git_branch
git rev-list --count --first-parent HEAD > build_number.txt

composer update

# git submodule foreach --recursive git pull origin master
cd $root_path$env/lib/PHPMailer
git checkout v5.2.18
git pull origin v5.2.18

cd $root_path$env/lib/facebook
git checkout 5.4
git pull origin 5.4

build_number=`git rev-list --count --first-parent HEAD`

echo build_number $git_branch $build_number

echo end of task....

path=$root_path$env'/tmp'

if [ -d "$path" ]
then
	echo "$path found."
else
    mkdir $path
    chmod 777 $path
fi

path=$root_path$env'/log'

if [ -d "$path" ]
then
	echo "$path found."
else
    mkdir $path
    chmod 777 $path
fi

curl -X POST -H 'Content-type: application/json' \
--data '{"text":"git sync PHP_API host:'$hostname' env: '$env' branch: '$git_branch' build_number: '$build_number'"}' \
 https://hooks.slack.com/services/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
