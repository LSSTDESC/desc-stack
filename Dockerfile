#FROM lsstsqre/centos:7-stack-lsst_distrib-w_2020_07
FROM lsstdesc/stack-sims:w_2020_36-sims_w_2020_36
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG LSST_STACK_DIR=/opt/lsst/software/stack
ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

ARG LSST_DESC_OBS_LSST=w.2020.36

WORKDIR $LSST_STACK_DIR

RUN echo "Environment: \n" && env | sort

USER root
RUN yum install -y libffi-devel 
USER lsst

# git clone https://github.com/lsst/obs_lsst.git; \
#                  cd obs_lsst; \
#                  git checkout $LSST_DESC_OBS_LSST; \
#                  setup -r . -j; \
#                  scons; \
#                  cd ..; \

#                  conda list --export > $CONDA_PREFIX/conda-meta/pinned; \

                  
# obs_lsst dc2/run2.2 branch is not compatible with the recent weeklies
RUN echo "Installing DESC requested packages" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \ 
                  setup lsst_distrib; \
                  setup lsst_sims; \
                  pip freeze > $LSST_STACK_DIR/require.txt; \
                  cat $LSST_STACK_DIR/require.txt; \
                  sed '/binutils/d' $LSST_STACK_DIR/require.txt; \
                  sed '/lcms2/d' $LSST_STACK_DIR/require.txt; \
                  sed '/llvm-openmp/d' $LSST_STACK_DIR/require.txt; \
                  sed '/sysroot/d' $LSST_STACK_DIR/require.txt; \
                  cat $LSST_STACK_DIR/require.txt; \
                  conda list; \
                  eups list; \
                  pip install -c $LSST_STACK_DIR/require.txt GCR==0.8.8; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/LSSTDESC/gcr-catalogs/archive/v0.19.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/LSSTDESC/CatalogMatcher.git; \
                  pip install -c $LSST_STACK_DIR/require.txt psycopg2-binary; \
                  pip install -c $LSST_STACK_DIR/require.txt healsparse; \
                  pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/LSSTDESC/supreme.git; \   
                  conda install -y --freeze-installed ipykernel jupyter_console; \
                  conda install -y --freeze-installed pyccl; \
                  pip install -c $LSST_STACK_DIR/require.txt fast3tree; \
                  pip install -c $LSST_STACK_DIR/require.txt fitsio; \
                  pip install -c $LSST_STACK_DIR/require.txt healsparse; \
                  pip install -c $LSST_STACK_DIR/require.txt https://bitbucket.org/yymao/helpers/get/v0.3.2.tar.gz; \
                  conda install -y --freeze-installed nose; \
                  conda install -y --freeze-installed parsl; \
                  conda install -y --freeze-installed pymssql; \
                  pip install -c $LSST_STACK_DIR/require.txt tables; \
                  conda install -y --freeze-installed TreeCorr; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/LSSTDESC/descqa/archive/v2.0.0-0.7.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/LSSTDESC/desc-dc2-dm-data/archive/v0.5.0.tar.gz; \
                  conda install -y --freeze-installed corner; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/yymao/FoFCatalogMatching/archive/v0.1.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/msimet/Stile; \
                  conda install -y --freeze-installed scikit-image; \
                  conda install -y --freeze-installed emcee; \
                  conda install -y --freeze-installed extinction; \
                  conda install -y --freeze-installed seaborn; \
                  pip install -c require.txt git+https://github.com/LSSTDESC/supreme.git; \
                  conda install -y --freeze-installed bokeh; \
                  conda install -y --freeze-installed dask; \
                  conda install -y --freeze-installed datashader; \
                  conda install -y --freeze-installed fastparquet; \
                  conda install -y --freeze-installed google-cloud-bigquery; \
                  conda install -y --freeze-installed holoviews; \
                  conda install -y --freeze-installed ipympl; \
                  conda install -y --freeze-installed namaster; \
                  conda install -y --freeze-installed dustmaps; \
                  python -c "from dustmaps.config import config; config[\"data_dir\"] = \"/global/common/software/lsst/common/miniconda/dustmaps\"; print(config[\"data_dir\"])"; '
                  

RUN echo "Finish Installing fast3tree" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                 echo -e "from fast3tree.make_lib import make_lib\nmake_lib(3, True)\nmake_lib(3, False)\nmake_lib(2, True)\nmake_lib(2, False)" >> $LSST_STACK_DIR/stack/install_fast3tree.py; \
                 python $LSST_STACK_DIR/stack/install_fast3tree.py'


ENV HDF5_USE_FILE_LOCKING FALSE

RUN echo "hooks.config.site.lockDirectoryBase = None" >> $LSST_STACK_DIR/stack/current/site/startup.py
