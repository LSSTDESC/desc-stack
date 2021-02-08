#FROM lsstsqre/centos:7-stack-lsst_distrib-w_2020_07
FROM lsstdesc/stack-sims:w_2021_06-sims_w_2021_06
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

# Pull out helper do to pip resolver issues
#                   pip install -c $LSST_STACK_DIR/require.txt https://bitbucket.org/yymao/helpers/get/v0.3.2.tar.gz; \
# pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/LSSTDESC/CatalogMatcher.git; \
#                  pip install -c $LSST_STACK_DIR/require.txt fast3tree; \
#                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/LSSTDESC/descqa/archive/v2.0.0-0.7.0.tar.gz; \
#                  pip install https://github.com/LSSTDESC/desc-dc2-dm-data/archive/v0.9.0.tar.gz; \
#                 pip install -c $LSST_STACK_DIR/require.txt https://github.com/yymao/FoFCatalogMatching/archive/v0.1.0.tar.gz; \
#                 pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/msimet/Stile; \

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
                  conda update -n $LSST_CONDA_ENV_NAME --freeze-installed -y --file=/tmp/desc-stack/conda-require.txt; \
                  pip install -c pip-constraints.txt -r /tmp/desc-stack/pip-require.txt; ' && \
    sed -i 's/# auto_download = True/auto_download = False/g' $HOME/.astropy/config/astropy.cfg && \
    rm -Rf /tmp/desc-stack
                  
ENV DUSTMAPS_CONFIG_FNAME /global/common/software/lsst/common/miniconda/dustmaps/dustmaps_config.json
ENV HDF5_USE_FILE_LOCKING FALSE

RUN echo "hooks.config.site.lockDirectoryBase = None" >> $LSST_STACK_DIR/stack/current/site/startup.py
