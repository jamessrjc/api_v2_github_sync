#!/bin/sh
env=HermesGM
git_branch='master'
root_path='/opt/algorithm/'
stamina_lib_branch='master'
#data_yellowyam_branch='master'

hostname=`hostname`

echo "starting to sync up code"

# start to folder
if [ -d "$root_path$env" ]
then
	echo "$path found."
else
    mkdir -p $root_path$env
    cd $root_path
    git clone https://bomdicsw:8a2f18dd1438acab59fd0c4fbcd114c440f0b29a@github.com/bOMDIC/HermesGM.git $env

    #cd $root_path$env
    #git checkout $git_branch
    #git submodule init
    #git config submodule.submodules/stamina_lib.url https://cklong2kbomdic:31edac175ee40884d42e3b6e27ee8c83e7df8b15@github.com/bOMDIC/stamina_lib.git
    #git config submodule.submodules/stamina_lib.path submodules/stamina_lib
    #git config submodule.submodules/stamina_lib.branch $stamina_lib_branch
    #git config submodule.submodules/Data_YellowYam.url https://cklong2kbomdic:31edac175ee40884d42e3b6e27ee8c83e7df8b15@github.com/bOMDIC/Data_YellowYam.git
    #git config submodule.submodules/Data_YellowYam.path submodules/Data_YellowYam
    #git submodule update --init --recursive
fi

# exit 1

cd $root_path$env

current_branch=`git rev-parse --abbrev-ref HEAD`

git reset --hard
git checkout $git_branch

echo pull code
git pull origin $git_branch
git rev-list --count --first-parent HEAD > build_number.txt

build_number=`git rev-list --count --first-parent HEAD`

echo build_number $git_branch $build_number

cd /opt/algorithm/$env/lib_php_API
chmod 755 integrate_multiple.py
chmod 755 integrate.py
chmod 755 HRMaxCalc.py

cd /opt/algorithm/$env/submodules/stamina_lib/lib_core/src
echo make lib core
make clean
make

echo end of task....

path=$root_path$env'/lib_php_API/transfer_json'
if [ -d "$path" ]
then
	echo "$path found."
else
    mkdir $path
    chmod 777 $path
fi

curl -X POST -H 'Content-type: application/json' \
--data '{"text":"git sync python host:'$hostname' env: '$env' branch: '$git_branch' build_number: '$build_number'"}' \
 https://hooks.slack.com/services/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
