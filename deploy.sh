#!/bin/bash

openssl aes-256-cbc -K $encrypted_058f1ad78f7f_key -iv $encrypted_058f1ad78f7f_iv -in deploy-key.rsa.enc -out deploy-key.rsa -d
chmod 0400 deploy-key.rsa

helm init --client-only
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

helm dependency update pangeo
GIT_SSH_COMMAND="ssh -i ${PWD}/deploy-key.rsa" chartpress --commit-range ${TRAVIS_COMMIT_RANGE} --publish-chart --push
