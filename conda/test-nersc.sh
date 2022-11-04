#!/bin/bash

set -eo pipefail

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module unload craype-network-aries
module unload cray-libsci
module unload craype
module load cray-mpich-abi/7.7.10

unset LSST_HOME EUPS_PATH LSST_DEVEL EUPS_PKGROOT REPOSITORY_PATH PYTHONPATH

# Set to 1 to install into the common sofware area
installFlag=$1

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
elif [[ "$installFlag" ]];
then
    if [[ -z "$CI_COMMIT_TAG" ]];
    then
        prodBuildDir=$CI_PIPELINE_ID
    else
        prodBuildDir=$CI_COMMIT_TAG
    fi
    curBuildDir=$commonProdBuildDir/$prodBuildDir
    echo "Prod Build: " $curBuildDir
fi

source $curBuildDir/setup_desc-stack.sh

python -c 'import lsst.daf.butler'

