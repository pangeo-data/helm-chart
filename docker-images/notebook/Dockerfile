# jupyter/base-noteobok uploaded 2018-06-13
FROM jupyter/base-notebook:4417b81d04b7  

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse vim git \
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
    cython \
    cytoolz \
    dask=0.17.5 \
    dask-ml \
    datashader \
    distributed=1.21.8 \
    esmpy \
    fastparquet \
    ipywidgets \
    jupyter \
    jupyterlab=0.32.1 \
    jupyterlab_launcher=0.10.5 \
    jupyter_client \
    holoviews \
    libsodium \
    lz4 \
    matplotlib \
    msgpack-python \
    nb_conda_kernels \
    netcdf4 \
    nomkl \
    numba \
    numcodecs \
    numpy=1.14.3 \
    pandas \
    python-blosc \
    pyzmq \
    s3fs \
    scipy \
    scikit-image \
    scikit-learn \
    tornado=5 \
    zarr=2.2.0 \
    zict \
    intake-xarray \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN pip install fusepy \
                click \
                jedi \
                kubernetes==6.0.0 \
                gcsfs==0.1.0 \
                xarray==0.10.7 \
                xesmf \
                nbserverproxy==0.8.1 \
                git+https://github.com/xgcm/xgcm \
                --upgrade --no-cache-dir \
                --upgrade-strategy only-if-needed

RUN pip install git+https://github.com/dask/dask@0a7fe8de2eef643f797afe5fda4c1b0bda8ad03d\
                git+https://github.com/dask/distributed@7909f27d591612537bb23974d089869edb11d097\
                git+https://github.com/dask/dask-kubernetes@48c4106387d7ccab9a72d6f50df024cec2232a5e\
                --no-cache-dir \
                --upgrade \ 
                --no-deps

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 # @jupyterlab/hub-extension \
                                 @pyviz/jupyterlab_pyviz

RUN jupyter serverextension enable --py nbserverproxy --sys-prefix

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /home/$NB_USER/examples && chown -R $NB_USER /home/$NB_USER/examples
RUN mkdir /pre-home && mkdir /pre-home/examples && chown -R $NB_USER /pre-home
COPY examples/ /pre-home/examples/

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
