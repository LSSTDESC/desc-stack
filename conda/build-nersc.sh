#!/bin/bash

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module unload craype-network-aries
module unload cray-libsci
module unload craype
module load cray-mpich-abi/7.7.10

unset LSST_HOME EUPS_PATH LSST_DEVEL EUPS_PKGROOT REPOSITORY_PATH PYTHONPATH

dmver=$1

# Set to 1 to install into the common sofware area
installFlag=$2

commonWeeklyBuildDir=/global/common/software/lsst/gitlab/desc-stack-weekly
commonDevBuildDir=/global/common/software/lsst/gitlab/desc-stack-weekly
commonProdBuildDir=/global/common/software/lsst/gitlab/desc-stack-weekly

if [ "$CI_COMMIT_REF_NAME" = "weekly" ];  # integration
then
    curBuildDir=$commonWeeklyBuildDir/$CI_PIPELINE_ID
    echo "Weekly Install Build: " $curBuildDir
elif [ "$CI_COMMIT_REF_NAME" = "dev" ];  # dev
then
    curBuildDir=$commonDevBuildDir/$CI_PIPELINE_ID
    echo "Dev Install Build: " $curBuildDir
elif [[ "$installFlag" ]];  # Install Prod
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

mkdir -p $curBuildDir
cp conda/packlist.txt $curBuildDir
cp conda/piplist.txt $curBuildDir
cp nersc/setup-desc-stack-weekly.sh $curBuildDir
cp nersc/sitecustomize.py $curBuildDir
sed -i 's|$1|'$curBuildDir'|g' $curBuildDir/setup-desc-stack-weekly.sh
cd $curBuildDir


# Build Steps
curl -LO https://ls.st/lsstinstall
#export LSST_CONDA_ENV_NAME=lsst-scipipe-$1
bash ./lsstinstall -X $1 

source ./loadLSST.bash
eups distrib install -t $1 lsst_distrib

mamba install -c conda-forge -y mpich=3.3.*=external_*

export LD_LIBRARY_PATH=/opt/cray/pe/mpt/7.7.10/gni/mpich-gnu-abi/8.2/lib:$LD_LIBRARY_PATH

setup lsst_distrib

# Install supreme
git clone https://github.com/lsstdesc/supreme
cd supreme
setup -r . -j

mamba install -c conda-forge -y --file ./packlist.txt
pip install --no-cache-dir -r ./piplist.txt

conda clean -y -a 

conda config --set env_prompt "(lsst-scipipe-$1)" --system

conda env export --no-builds > $curBuildDir/desc-stack-weekly-nersc-$CI_PIPELINE_ID-nobuildinfo.yml
conda env export > $curBuildDir/desc-stack-weekly-nersc-$CI_PIPELINE_ID.yml


# Set permissions
setfacl -R -m group::rx $curBuildDir
setfacl -R -d -m group::rx $curBuildDir

setfacl -R -m user:desc:rwx $curBuildDir
setfacl -R -d -m user:desc:rwx $curBuildDir



