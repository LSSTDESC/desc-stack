#!/bin/bash

wrapcosmosis() {
    source cosmosis-configure
}

source /opt/lsst/software/stack/loadLSST.bash
setup lsst_distrib
setup -j -r /opt/lsst/software/desc/supreme
export CSL_DIR=$CONDA_PREFIX/lib/python3.10/site-packages/cosmosis/cosmosis-standard-library
export FIRECROWN_SITE_PACKAGES=$CONDA_PREFIX/lib/python3.10/site-packages
export FIRECROWN_DIR=/opt/lsst/software/desc/firecrown
wrapcosmosis
