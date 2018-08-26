# jupyter/base-noteobok uploaded 2018-06-13
FROM jupyter/base-notebook:4417b81d04b7

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse vim git graphviz \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN conda install --yes \
    -c defaults \
    -c pyviz/label/dev \
    -c bokeh/channel/dev \
    -c intake \
    -c conda-forge \
    bokeh=0.12.16 \
    bqplot \
    cython \
    cytoolz \
    dask=0.18.2 \
    dask-ml \
    datashader \
    distributed=1.22.1 \
    esmpy \
    fastparquet \
    gcsfs=0.1.2 \
    ipywidgets \
    ipyleaflet \
    jupyter \
    jupyterlab=0.34.2 \
    jupyterlab_launcher=0.13.1 \
    jupyter_client \
    holoviews \
    libsodium \
    lz4 \
    matplotlib \
    msgpack-python \
    nb_conda_kernels \
    netcdf4>1.4 \
    nomkl \
    numba \
    numcodecs \
    numpy=1.15.1 \
    pandas=0.23.2 \
    python-blosc \
    pyzmq \
    s3fs \
    scipy \
    scikit-image \
    scikit-learn \
    toolz=0.9.0 \
    tornado=5.0.2 \
    xarray=0.10.8 \
    zarr=2.2.0 \
    zict \
    intake-xarray \
    graphviz \
    python-graphviz \
    gsw \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN pip install fusepy \
                click \
                jedi \
                kubernetes==6.0.0 \
                dask-kubernetes==0.4.0 \
                xesmf \
                nbserverproxy==0.8.1 \
                git+https://github.com/xgcm/xgcm \
                --upgrade --no-cache-dir \
                --upgrade-strategy only-if-needed


RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 @jupyterlab/hub-extension \
                                 @pyviz/jupyterlab_pyviz \
                                 jupyter-leaflet \

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
