#!/bin/bash

#module unload python
#module swap PrgEnv-intel PrgEnv-gnu
#module unload craype-network-aries
#module unload cray-libsci
#module unload craype
#module load cray-mpich-abi/7.7.19

unset LSST_HOME EUPS_PATH LSST_DEVEL EUPS_PKGROOT REPOSITORY_PATH PYTHONPATH

dmver=$1
installDir=$2

mkdir -p $installDir

cp conda/packlist.txt $installDir
cp conda/piplist.txt $installDir
#cp apptainer/setup-desc-stack-weekly.sh $installDir
#sed -i 's|$1|'$installDir'|g' $installDir/setup-desc-stack-weekly.sh
cd $installDir
/cvmfs/sw.lsst.eu/linux-x86_64/apptainer/v1.1.3/bin/apptainer shell -H $installDir /cvmfs/sw.lsst.eu/containers/apptainer/lsst_distrib/$dmver.sif

source /opt/lsst/software/stack/loadLSST.bash
setup lsst_distrib

mamba create --clone lsst-scipipe-5.1.0 -p $installDir/mydesc
conda activate $installDir/mydesc

#mamba install -c conda-forge -y mpich=3.4.*=external_*
#export LD_LIBRARY_PATH=/opt/cray/pe/mpt/7.7.19/gni/mpich-gnu-abi/8.2/lib:$LD_LIBRARY_PATH

# Install supreme
git clone https://github.com/lsstdesc/supreme
cd supreme
setup -r . -j

cd $installDir

mamba install -c conda-forge -y --file ./packlist.txt
pip install --no-cache-dir -r ./piplist.txt

conda clean -y -a 

#conda config --set env_prompt "(lsst-scipipe-$1)" --system
