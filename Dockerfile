#FROM lsstsqre/centos:7-stack-lsst_distrib-w_2020_07
FROM lsstdesc/stack-sims:w_2020_07-sims_w_2020_07
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG LSST_STACK_DIR=/opt/lsst/software/stack
ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

WORKDIR $LSST_STACK_DIR

RUN echo "Environment: \n" && env | sort

USER root
RUN yum install -y libffi-devel 
USER lsst

#                  conda install -y ipykernel jupyter_console; \
#                  conda install -y markupsafe nose; \
#                   conda install -y cmake swig; \

#echo -e "ca-certificates 2019.1.23\ncertifi 2019.3.9\nopenssl 1.1.1b" > $LSST_STACK_DIR/python/current/envs/lsst-scipipe-4d7b902/conda-meta/pinned; \
#                  cat $LSST_STACK_DIR/python/current/envs/lsst-scipipe-4d7b902/conda-meta/pinned; \

RUN echo "Installing DESC requested packages" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \ 
                  conda list > $CONDA_PREFIX/conda-meta/pinned; \
                  pip freeze > $LSST_STACK_DIR/require.txt; \
                  cat $LSST_STACK_DIR/require.txt; \
                  conda list; \
                  eups list; \
                  pip install -c $LSST_STACK_DIR/require.txt ipykernel jupyter_console; \
                  pip install -c $LSST_STACK_DIR/require.txt camb==1.1.2; \
                  pip install -c $LSST_STACK_DIR/require.txt fast3tree; \
                  pip install -c $LSST_STACK_DIR/require.txt fitsio; \
                  pip install -c $LSST_STACK_DIR/require.txt healpy; \
                  pip install -c $LSST_STACK_DIR/require.txt https://bitbucket.org/yymao/helpers/get/v0.3.2.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt markupsafe nose; \
                  pip install -c $LSST_STACK_DIR/require.txt parsl; \
                  export PYMSSQL_BUILD_WITH_BUNDLED_FREEETDS=1; \
                  pip install -c $LSST_STACK_DIR/require.txt pymssql; \
                  pip install -c $LSST_STACK_DIR/require.txt tables; \
                  pip install -c $LSST_STACK_DIR/require.txt TreeCorr; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/LSSTDESC/descqa/archive/v2.0.0-0.7.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/LSSTDESC/desc-dc2-dm-data/archive/v0.5.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt corner; \
                  pip install -c $LSST_STACK_DIR/require.txt https://github.com/yymao/FoFCatalogMatching/archive/v0.1.0.tar.gz; \
                  pip install -c $LSST_STACK_DIR/require.txt git+https://github.com/msimet/Stile; \
                  pip install -c $LSST_STACK_DIR/require.txt scikit-image; \
                  pip install -c $LSST_STACK_DIR/require.txt emcee; \
                  pip install -c $LSST_STACK_DIR/require.txt psycopg2-binary; \
                  pip install -c $LSST_STACK_DIR/require.txt extinction; \
                  pip install -c $LSST_STACK_DIR/require.txt seaborn; \
                  pip install -c $LSST_STACK_DIR/require.txt cmake; \
                  conda install --no-deps -y automake; \
                  conda install --no-deps -y swig; \
                  setup fftw; \
                  setup gsl; \
                  pip install -c $LSST_STACK_DIR/require.txt pyccl==2.1.0;'

RUN echo "Finish Installing fast3tree" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                 echo -e "from fast3tree.make_lib import make_lib\nmake_lib(3, True)\nmake_lib(3, False)\nmake_lib(2, True)\nmake_lib(2, False)" >> $LSST_STACK_DIR/stack/install_fast3tree.py; \
                 python $LSST_STACK_DIR/stack/install_fast3tree.py'

RUN echo "Installing obs_lsst" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                 setup lsst_distrib; \
                 git clone https://github.com/lsst/obs_lsst.git; \
                 cd obs_lsst; \
                 git checkout dc2/run2.2; \
                 setup -r . -j; \
                 scons; \
                 cd ..'

RUN echo "Installing additional python packages" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                  pip install -c $LSST_STACK_DIR/require.txt bokeh; \
                  pip install -c $LSST_STACK_DIR/require.txt dask; \
                  pip install -c $LSST_STACK_DIR/require.txt distributed; \
                  pip install -c $LSST_STACK_DIR/require.txt datashader; \
                  pip install -c $LSST_STACK_DIR/require.txt fastparquet; \
                  pip install -c $LSST_STACK_DIR/require.txt google-cloud-bigquery; \
                  pip install -c $LSST_STACK_DIR/require.txt holoviews; \
                  pip install -c $LSST_STACK_DIR/require.txt ipympl==0.4.1; \
                  pip install -c $LSST_STACK_DIR/require.txt ipywidgets'


RUN echo "Installing CatalogMatcher" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                 git clone https://github.com/LSSTDESC/CatalogMatcher.git; \
                 cd CatalogMatcher; \
                 python setup.py install'

RUN echo "Installing GCR packages" && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                  pip freeze > $LSST_STACK_DIR/require.txt; \
                  pip install -c $LSST_STACK_DIR/require.txt GCR==0.8.8; \
                  pip install https://github.com/LSSTDESC/gcr-catalogs/archive/v0.17.0.tar.gz' 

ENV HDF5_USE_FILE_LOCKING FALSE

RUN echo "hooks.config.site.lockDirectoryBase = None" >> $LSST_STACK_DIR/stack/current/site/startup.py
