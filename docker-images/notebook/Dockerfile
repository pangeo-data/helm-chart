# jupyter/base-noteobok uploaded 2018-06-13
FROM jupyter/base-notebook:4417b81d04b7

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse vim git \
             man tree build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN conda update conda --yes \
  && conda config --remove channels defaults

RUN conda install --yes  \
    appmode \
    arrow \
    pyviz/label/earthsim::bokeh \
    bqplot \
    cartopy \
    click \
    cython  \
    cytoolz \
    dask \
    dask-kubernetes \
    dask-ml \
    dask-tensorflow \
    datashader \
    distributed \
    esmpy \
    fastparquet \
    fusepy \
    geoviews \
    gcsfs \
    graphviz \
    gsw \
    pyviz/label/earthsim::holoviews \
    hvplot \
    intake::intake \
    intake::intake-xarray \
    ipywidgets \
    ipyleaflet \
    jedi \
    jupyter \
    jupyterlab=0.34.2 \
    jupyterlab_launcher \
    jupyter_client \
    kubernetes \
    libsodium \
    lz4 \
    matplotlib \
    msgpack-python \
    nb_conda_kernels \
    nbserverproxy \
    netcdf4 \
    nomkl \
    numba \
    numcodecs \
    numpy \
    pandas \
    panel \
    python-blosc \
    python-graphviz \
    pyzmq \
    rasterio \
    s3fs \
    scipy \
    scikit-image \
    scikit-learn \
    toolz \
    tornado \
    xarray \
    xesmf \
    zarr \
    zict \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN pip install git+https://github.com/xgcm/xgcm \
                git+https://github.com/Unidata/cftime.git \
                --upgrade --no-cache-dir \
                --upgrade-strategy only-if-needed


RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 @jupyterlab/hub-extension \
                                 @pyviz/jupyterlab_pyviz \
                                 jupyter-leaflet

RUN jupyter serverextension enable --py nbserverproxy jupyterlab --sys-prefix

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /pre-home && chown -R $NB_USER /pre-home

ENV DASK_CONFIG=/home/$NB_USER/config.yaml
COPY config.yaml /pre-home
COPY worker-template.yaml /pre-home

RUN mkdir /gcs && chown -R $NB_USER /gcs
RUN mkdir /opt/app

# Add NB_USER to sudo
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
RUN sed -ri "s#Defaults\s+secure_path=\"([^\"]+)\"#Defaults secure_path=\"\1:$CONDA_DIR/bin\"#" /etc/sudoers
USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh jupyter lab"]
