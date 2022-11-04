#!/bin/bash

linkName=$1

commonWeeklyBuildDir=/global/common/software/lsst/gitlab/desc-stack-weekly
commonDevBuildDir=/global/common/software/lsst/gitlab/desc-stack-weekly
commonProdBuildDir=/global/common/software/lsst/gitlab/desc-stack-weekly

if [ "$CI_COMMIT_REF_NAME" = "weekly" ];
then
    curBuildDir=$commonWeeklyBuildDir/$CI_PIPELINE_ID
    echo "Weekly Install Build: " $curBuildDir
elif [ "$CI_COMMIT_REF_NAME" = "dev" ];
then
    curBuildDir=$commonDevBuildDir/$CI_PIPELINE_ID
    echo "Dev Install Build: " $curBuildDir
else 
    if [[ -z "$CI_COMMIT_TAG" ]];
    then
        prodBuildDir=$CI_PIPELINE_ID
    else 
        prodBuildDir=$CI_COMMIT_TAG
    fi
    curBuildDir=$commonProdBuildDir/$prodBuildDir
    echo "Prod Build: " $curBuildDir
fi

cd $curBuildDir/../
unlink $linkName
ln -s $curBuildDir $linkName



