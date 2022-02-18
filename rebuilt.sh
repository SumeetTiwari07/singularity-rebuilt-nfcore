#!/bin/bash

#The bash scirpt was used to rebuild the containers using singularity v2 for the nf-core piplelines.
#In case user doesn't have the singularitßy 3.
#Currently tested for the nf-core/mag workflow. 

tool=$1 #name of the nf-core tool git repo to clone

#Checking if the nf-core/config directory exist or not in the current location
#If not found then clone the configs directory at the current location
if [ ! -d "$PWD/configs"]
then
    echo "Clonning Institutional nf-core/configs"
    git clone https://github.com/nf-core/configs
else
    echo "nf-core configs directory exist'"
fi

#checking if the $tool directory exist in current location
#if not found then clone the $tool directory from github.
#if clonning successful then rename the $tool dir to "workflow"
if [ ! -d "PWD/$tool" ]
then
    git clone https://github.com/nf-core/$tool.git
    if [ "$?" -eq "0" ]
    then
        echo "Clonning nf-core/$tool sucessful!"
        mv $PWD/$tool "$PWD/workflow"
    else
        echo "Clonning failed"
    fi
else
    echo "nf-core/$tool exist"
    echo "if its not correct diretory then delete using rm -rf $tool"
fi

#make the directory singularity-images in current location if not found.
#change to the "singularit-images"
if [ ! -d "$PWD/singularity-images" ]
then
    echo "Create singualrity-images"
    mkdir "$PWD/singularity-images"
    cd $PWD/singularity-images
else
   echo "Directory exist"
   cd $PWD/singularity-images
fi
#find all the files with extension '.nf' and pass to array
files=$(find $PWD/../workflow/modules -name "*.nf")


#Rename the image name as required 
#Rename the link to pull the docker images "docker://"
#If $tool.img does not found then built the singularity container

for i in ${files[@]}
do 
    img_name=$(grep "https:" $i | awk -F"https://" '{print $2}' | sed -e "s/\"/.img/g" -e "s/\//-/g" -e "s/:/-/g" -e "s/'/.img/g")
    container=$(grep -E "quay.io/|\"biocontainers/" $i | sed -e "s/\"//g" -e "s/'//g" -e "s/container /docker:\/\//g" | awk '{print $1}')
        
    if [ ! -z "$img_name" ] && [ ! -z "$container" ]
    then
        if [[ ! -f "$PWD/$img_name" ]]
        then
            echo "Building the image $img_name"
            singularity pull --name "$img_name" "$container" 
        fi
    fi
done
