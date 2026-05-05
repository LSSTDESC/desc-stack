ARG LSST_TAG
FROM ghcr.io/lsst/scipipe:al9-$LSST_TAG
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG LSST_TAG
ARG LSST_STACK_DIR=/opt/lsst/software/stack
ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

WORKDIR $LSST_STACK_DIR

USER root

RUN dnf install -y zsh
USER lsst
RUN echo "Environment: \n" && env | sort && touch $HOME/.zshrc
                  
RUN echo "Installing DESC requested packages" && \
    cd /tmp && \
    git clone https://github.com/LSSTDESC/desc-stack && \
    cd desc-stack && \
    git checkout descwl-shear-sims && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \ 
                  setup lsst_distrib; \
                  cd $LSST_STACK_DIR; \
                  pin-it rubin-env > $CONDA_PREFIX/conda-meta/pinned; \
                  cat $CONDA_PREFIX/conda-meta/pinned; \
                  conda list; \
                  eups list; \
                  conda config --env --add channels conda-forge; \
                  python -c "import astropy"; \
                  touch /home/lsst/.astropy/config/astropy.cfg; \
                  echo $LSST_CONDA_ENV_NAME; \
                  conda install -c conda-forge/label/mpi-external -y mpich; \
                  mamba install -c conda-forge --freeze-installed -y --file=/tmp/desc-stack/conda/packlist.txt; \
                  cd /tmp; \
                  git clone https://github.com/LSSTDESC/descwl-shear-sims.git; \
                  cd descwl-shear-sims; \
                  pip install .; \
                  python -c "import astropy"; ' && \
    sed -i 's/# auto_download = True/auto_download = False/g' $HOME/.astropy/config/astropy.cfg && \
    rm -Rf /tmp/desc-stack
                  
ENV HDF5_USE_FILE_LOCKING FALSE

# HMK Path changed, current no longer exists
#RUN echo "hooks.config.site.lockDirectoryBase = None" >> $LSST_STACK_DIR/stack/current/site/startup.py
RUN echo "hooks.config.site.lockDirectoryBase = None" >> ~/.eups/startup.py

