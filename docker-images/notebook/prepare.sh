#!/bin/bash

set -x

echo "Copy files from pre-load directory into home"
cp --update -r -v /pre-home/. /home/jovyan
rm -rf examples
git clone https://github.com/pangeo-data/pangeo_examples examples
echo "Files in this directory should be treated as read-only"  > examples/DONT_SAVE_ANYTHING_HERE.md
mkdir work

if [ -e "/opt/app/environment.yml" ]; then
    echo "environment.yml found. Installing packages"
    /opt/conda/bin/conda env update -f /opt/app/environment.yml
else
    echo "no environment.yml"
fi

if [ "$EXTRA_CONDA_PACKAGES" ]; then
    echo "EXTRA_CONDA_PACKAGES environment variable found.  Installing."
    /opt/conda/bin/conda install $EXTRA_CONDA_PACKAGES
fi

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    /opt/conda/bin/pip install $EXTRA_PIP_PACKAGES
fi

if [ "$GCSFUSE_BUCKET" ]; then
    echo "Mounting $GCSFUSE_BUCKET to /gcs"
    /opt/conda/bin/gcsfuse $GCSFUSE_BUCKET /gcs --background
fi
# Run extra commands
$@
