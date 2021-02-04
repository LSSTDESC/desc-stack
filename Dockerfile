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

# treecorr already included in stack-sims
#                  conda install -c conda-forge -y --freeze-installed TreeCorr; \

# git clone https://github.com/lsst/obs_lsst.git; \
#                  cd obs_lsst; \
#                  git checkout $LSST_DESC_OBS_LSST; \
#                  setup -r . -j; \
#                  scons; \
#                  cd ..; \

# Pull out helper do to pip resolver issues
#                   pip install -c $LSST_STACK_DIR/require.txt https://bitbucket.org/yymao/helpers/get/v0.3.2.tar.gz; \


                  
# obs_lsst dc2/run2.2 branch is not compatible with the recent weeklies
RUN echo "Installing DESC requested packages" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \ 
                  setup lsst_distrib; \
                  setup lsst_sims; \
                  cd $LSST_STACK_DIR; \
                  pin-it rubin-env > $CONDA_PREFIX/conda-meta/pinned; \
                  cat $CONDA_PREFIX/conda-meta/pinned; \
                  pip freeze > $LSST_STACK_DIR/require.txt; \
                  sed -i '/@/d' $LSST_STACK_DIR/require.txt; \
                  cat $LSST_STACK_DIR/require.txt; \
                  sed '/binutils/d' $LSST_STACK_DIR/require.txt; \
                  sed '/lcms2/d' $LSST_STACK_DIR/require.txt; \
                  sed '/llvm-openmp/d' $LSST_STACK_DIR/require.txt; \
                  sed '/sysroot/d' $LSST_STACK_DIR/require.txt; \
                  cat $LSST_STACK_DIR/require.txt; \
                  conda list; \
                  eups list; \
                  conda config --env --add channels conda-forge; \
                  conda install -c conda-forge -y --freeze-installed ipykernel jupyter_console; \
                  conda install -c conda-forge -y --freeze-installed pyccl; \
                  conda install -c conda-forge -y --freeze-installed nose; \
                  conda install -c conda-forge -y --freeze-installed parsl; \
                  conda install -c conda-forge -y --freeze-installed corner; \
                  conda install -c conda-forge -y --freeze-installed pymssql; \
                  conda install -c conda-forge -y --freeze-installed scikit-image; \
                  conda install -c conda-forge -y --freeze-installed emcee; \
                  conda install -c conda-forge -y --freeze-installed extinction; \
                  conda install -c conda-forge -y --freeze-installed seaborn; \
                  conda install -c conda-forge -y --freeze-installed bokeh; \
                  conda install -c conda-forge -y --freeze-installed dask; \
                  conda install -c conda-forge -y --freeze-installed datashader; \
                  conda install -c conda-forge -y --freeze-installed fastparquet; \
                  conda install -c conda-forge -y --freeze-installed google-cloud-bigquery; \
                  conda install -c conda-forge -y --freeze-installed holoviews; \
                  conda install -c conda-forge -y --freeze-installed ipympl; \
                  conda install -c conda-forge -y --freeze-installed namaster; \
                  conda install -c conda-forge -y --freeze-installed gcr; \
                  conda install -c conda-forge -y --freeze-installed lsstdesc-gcr-catalogs; \
                  conda install -c conda-forge -y --freeze-installed pytables fitsio; \
                  conda install -c conda-forge -y --freeze-installed psycopg2; \
                  conda install -c conda-forge -y --freeze-installed fast-pt; \
                  pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/LSSTDESC/CatalogMatcher.git; \
                  pip install -c $LSST_STACK_DIR/require.txt fast3tree; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/LSSTDESC/descqa/archive/v2.0.0-0.7.0.tar.gz; \
                  pip install https://github.com/LSSTDESC/desc-dc2-dm-data/archive/v0.9.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/yymao/FoFCatalogMatching/archive/v0.1.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/msimet/Stile; \
                  pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/LSSTDESC/supreme.git; '
                  
ENV DUSTMAPS_CONFIG_FNAME /global/common/software/lsst/common/miniconda/dustmaps/dustmaps_config.json
ENV HDF5_USE_FILE_LOCKING FALSE

RUN echo "hooks.config.site.lockDirectoryBase = None" >> $LSST_STACK_DIR/stack/current/site/startup.py
