FROM continuumio/miniconda3:4.3.14

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda install --yes \
    -c defaults \
    -c conda-forge \
    cython \
    cytoolz \
    dask=0.17.4 \
    distributed=1.21.8 \
    esmpy \
    fastparquet \
    git \
    lz4 \
    msgpack-python \
    netcdf4 \
    nomkl \
    numba \
    numcodecs \
    numpy=1.14.3 \
    pandas \
    python-blosc \
    scikit-image \
    scipy \
    zict \
    && conda clean -tipsy

RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install click \
                urllib3 \
                fusepy \
                s3fs \
                gcsfs==0.1.0 \
                zarr==2.2.0 \
                xarray==0.10.7 \
                xesmf \
                --upgrade --no-cache-dir --upgrade-strategy only-if-needed

RUN pip install git+https://github.com/dask/dask@0a7fe8de2eef643f797afe5fda4c1b0bda8ad03d\
                git+https://github.com/dask/distributed@7909f27d591612537bb23974d089869edb11d097\
                msgpack \
                --upgrade --no-cache-dir --no-deps

ENV OMP_NUM_THREADS=1
ENV DASK_DISTRIBUTED__ADMIN__TICK__LIMIT=5s

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
RUN mkdir /gcs

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
