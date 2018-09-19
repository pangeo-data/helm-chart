#!/bin/bash

#                    .,,,,,.
#               .,(#         #(,
#             .*%               #*.
#            ,#    %%%%%%%%%%%%   #,
#           ,#     %%%%%%%%%%%%    #,
#          .(                       (.
#          ,%    %%%%%%%%%          #,
#          ,#    %%%%%%%%%          #,
#          .(                      .(.
#           ,#     %%%%%%%%%%%%    #,
#            ,#    %%%%%%%%%%%%   #,
#             .*#               #*.
#               .,(#        .#/,
#                   .,,,,,.
#       _____
#      |  __ \
#      | |__) |_ _ _ __   __ _  ___  ___
#      |  ___/ _` | '_ \ / _` |/ _ \/ _ \
#      | |  | (_| | | | | (_| |  __/ (_) |
#      |_|   \__,_|_| |_|\__, |\___|\___/
#                         __/ |
#                        |___/
#
# This script sets up the basic user Jupyter home directory for use on Pangeo.

set -x


################################
# Copy skeleton home directory #
################################

echo "Copying files from skeleton home directory into home..."
cp --update -r -v /etc/skel/. /home/jovyan
echo "Done"


#########################
# Add example notebooks #
#########################

echo "Getting example notebooks..."
if [ -z "$EXAMPLES_GIT_URL" ]; then
    export EXAMPLES_GIT_URL=https://github.com/pangeo-data/pangeo-example-notebooks
fi
rmdir examples &> /dev/null # deletes directory if empty, in favour of fresh clone
if [ ! -d "examples" ]; then
  git clone $EXAMPLES_GIT_URL examples
fi
cd examples
chmod -R 700 *.ipynb
git remote set-url origin $EXAMPLES_GIT_URL
git fetch origin
git reset --hard origin/master
git merge --strategy-option=theirs origin/master
if [ ! -f DONT_SAVE_ANYTHING_HERE.md ]; then
  echo "Files in this directory should be treated as read-only"  > DONT_SAVE_ANYTHING_HERE.md
fi
chmod -R 400 *.ipynb
cd ..
echo "Done"


######################################
# Install additional Python packages #
######################################

echo "Installing extra Python packages..."
if [ -e "/opt/app/environment.yml" ]; then
    echo "Conda environment.yml found. Installing packages"
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
echo "Done"


###################################
# Mount optional FUSE filesystems #
###################################

echo "Mouting FUSE filesystems..."
if [ "$GCSFUSE_BUCKET" ]; then
    echo "Mounting $GCSFUSE_BUCKET to /gcs"
    /opt/conda/bin/gcsfuse $GCSFUSE_BUCKET /gcs --background
fi
echo "Done"


######################
# Run extra commands #
######################
$@
