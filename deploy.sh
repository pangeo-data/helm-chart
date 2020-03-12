#!/bin/bash

# Deploying means to package and make available a Helm chart in the Helm chart
# repostiory hosted as a GitHub pages website. GitHub pages websites are hosted
# by GitHub automatically if we push to a github repository of a certain branch
# called gh-pages.
#
# See:
# - gh-pages branch: https://github.com/pangeo-data/helm-chart/tree/gh-pages
# - Rendered GitHub pages: https://pangeo-data.github.io/helm-chart/

# We need to provide credentails to push to the the git repository configured in
# chartpress.yaml, which is this git repo. The push will be made by chartpress
# and be made to the gh-pages branch specifically.
set -eu
openssl aes-256-cbc -K $encrypted_058f1ad78f7f_key -iv $encrypted_058f1ad78f7f_iv -in deploy-key.rsa.enc -out deploy-key.rsa -d
set -x
chmod 0400 deploy-key.rsa
export GIT_SSH_COMMAND="ssh -i ${PWD}/deploy-key.rsa"

# Initialize helm CLI for use by chartpress to package a helm chart and publish
# it using configuration in chartpress.yaml.
helm init --client-only
chartpress --publish-chart $@

# Provide a trace of what chartpress did for the logs
git diff
