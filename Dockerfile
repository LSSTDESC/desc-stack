#FROM lsstsqre/centos:7-stack-lsst_distrib-w_2020_07
FROM lsstdesc/stack-sims:w_2021_20-sims_w_2021_20
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG LSST_STACK_DIR=/opt/lsst/software/stack
ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

# Using supplied obs_lsst in the weeklies
#ARG LSST_DESC_OBS_LSST=w.2021.05

WORKDIR $LSST_STACK_DIR

USER root
RUN yum install -y libffi-devel zsh
USER lsst
RUN echo "Environment: \n" && env | sort && touch $HOME/.zshrc

#                  conda list --export > $CONDA_PREFIX/conda-meta/pinned; \


# git clone https://github.com/lsst/obs_lsst.git; \
#                  cd obs_lsst; \
#                  git checkout $LSST_DESC_OBS_LSST; \
#                  setup -r . -j; \
#                  scons; \
#                  cd ..; \


#conda env update -n $LSST_CONDA_ENV_NAME --file=/tmp/desc-stack/desc.yml;
                  
# obs_lsst dc2/run2.2 branch is not compatible with the recent weeklies
RUN echo "Installing DESC requested packages" && \
    cd /tmp && \
    git clone https://github.com/LSSTDESC/desc-stack && \
    cd desc-stack && \
    git checkout weekly && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \ 
                  setup lsst_distrib; \
                  setup lsst_sims; \
                  cd $LSST_STACK_DIR; \
                  pin-it rubin-env > $CONDA_PREFIX/conda-meta/pinned; \
                  cat $CONDA_PREFIX/conda-meta/pinned; \
                  pip freeze > $LSST_STACK_DIR/pip-constraints.txt; \
                  sed -i '/@/d' $LSST_STACK_DIR/pip-constraints.txt; \
                  cat $LSST_STACK_DIR/pip-constraints.txt; \
                  sed '/binutils/d' $LSST_STACK_DIR/pip-constraints.txt; \
                  sed '/lcms2/d' $LSST_STACK_DIR/pip-constraints.txt; \
                  sed '/llvm-openmp/d' $LSST_STACK_DIR/pip-constraints.txt; \
                  sed '/sysroot/d' $LSST_STACK_DIR/pip-constraints.txt; \
                  cat $LSST_STACK_DIR/pip-constraints.txt; \
                  conda list; \
                  eups list; \
                  conda config --env --add channels conda-forge; \
                  git clone https://github.com/lsstdesc/supreme; \
                  cd supreme; \
                  setup -r . -j; \
                  cd ..; \
                  echo $LSST_CONDA_ENV_NAME; \
                  conda install -c conda-forge --freeze-installed -y --file=/tmp/desc-stack/conda-require.txt; \
                  pip install -c pip-constraints.txt -r /tmp/desc-stack/pip-require.txt; \
                  python -c "import astropy"; ' && \
    sed -i 's/# auto_download = True/auto_download = False/g' $HOME/.astropy/config/astropy.cfg && \
    rm -Rf /tmp/desc-stack
                  
ENV DUSTMAPS_CONFIG_FNAME /global/common/software/lsst/common/miniconda/dustmaps/dustmaps_config.json
ENV HDF5_USE_FILE_LOCKING FALSE

RUN echo "hooks.config.site.lockDirectoryBase = None" >> $LSST_STACK_DIR/stack/current/site/startup.py
