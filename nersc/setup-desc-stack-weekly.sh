#!/bin/bash

export DESC_LSST_INSTALL_DIR=$1


source $DESC_LSST_INSTALL_DIR/loadLSST.bash ""
setup lsst_distrib
[ -d "$LSST_HOME/supreme" ] && setup -r $LSST_HOME/supreme -j
export OMP_NUM_THREADS=1

unset PYTHONSTARTUP

export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

export RUBIN_SIM_DATA_DIR=/global/cfs/cdirs/lsst/groups/CO/rubin_sim

if [ -n "$DESCSTACKUSERENV" ]; then
   conda activate $DESCSTACKUSERENV
   echo "Activated your DESCSTACKUSERENV: $DESCSTACKUSERENV"
    echo "Wondering Why? DESCSTACKUSERENV is likely set in your $HOME/.basrhc, $HOME/.bashrc.ext, or similar config script"
fi


export PYTHONPATH=".:$PYTHONPATH"

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi

