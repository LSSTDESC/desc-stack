#!/bin/bash

# Brief doc:
# git clone https://github.com/LSSTDESC/desc-stack
# cd desc-stack
# git checkout apptainer
# cd ..
# /cvmfs/sw.lsst.eu/linux-x86_64/apptainer/v1.1.3/bin/apptainer exec -H $PWD /cvmfs/sw.lsst.eu/containers/apptainer/lsst_distrib/w_2023_03.sif ./desc-stack/update-apptainer.sh

# Once that installation is complete, you can then start up a new apptainer
# shell and utilize your cloned and updated environment
# If installation is on a local machine, the GCRCatalog data will need to be
# downloaded, see: https://data.lsstdesc.org/doc/install_gcr  for some instructions
# /cvmfs/sw.lsst.eu/linux-x86_64/apptainer/v1.1.3/bin/apptainer shell -H $PWD /cvmfs/sw.lsst.eu/containers/apptainer/lsst_distrib/w_2023_03.sif 
# source /opt/lsst/software/stack/loadLSST.bash
# conda activate $PWD/mydesc
# setup lsst_distrib
# python -m GCRCatalogs.user_config set root_dir /path/to/the/download/directory

unset LSST_HOME EUPS_PATH LSST_DEVEL EUPS_PKGROOT REPOSITORY_PATH PYTHONPATH

source /opt/lsst/software/stack/loadLSST.bash
setup lsst_distrib

mamba create --clone lsst-scipipe-5.1.0 -p $PWD/mydesc
conda activate $PWD/mydesc

# If you want to utilize your local mpich libraries rather than the ones
# provided by conda-forge
#mamba install -c conda-forge -y mpich=3.4.*=external_*
#export LD_LIBRARY_PATH=/opt/cray/pe/mpt/7.7.19/gni/mpich-gnu-abi/8.2/lib:$LD_LIBRARY_PATH

# Install supreme
git clone https://github.com/lsstdesc/supreme
cd supreme
setup -r . -j

cd ..

mamba install -c conda-forge -y --file $PWD/desc-stack/conda/packlist.txt
pip install --no-cache-dir -r $PWD/desc-stack/conda/piplist.txt

