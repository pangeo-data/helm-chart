#!/bin/bash

set -eu
openssl aes-256-cbc -K $encrypted_058f1ad78f7f_key -iv $encrypted_058f1ad78f7f_iv -in deploy-key.rsa.enc -out deploy-key.rsa -d
set -x
chmod 0400 deploy-key.rsa
docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
helm init --client-only
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm dependency update pangeo
export GIT_SSH_COMMAND="ssh -i ${PWD}/deploy-key.rsa"
chartpress --commit-range ${TRAVIS_COMMIT_RANGE} --publish-chart --push
git diff
