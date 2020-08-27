# Pangeo Helm Chart
[![Build Status](https://travis-ci.org/pangeo-data/helm-chart.svg?branch=master)](https://travis-ci.org/pangeo-data/helm-chart) [![CircleCI](https://circleci.com/gh/pangeo-data/helm-chart/tree/master.svg?style=svg)](https://circleci.com/gh/pangeo-data/helm-chart/tree/master)

⚠️  This chart is deprecated. Use `dask/daskhub` from https://helm.dask.org/ instead. ⚠️

If you're migrating from the old helm chart, the primary change will be renaming your
keys from ``pangeo`` to ``daskhub``. If you were manually setting up the `dask-gateway`
JupyterHub service and setting the Dask-Gateway singleuser variables, you can remove
those (though keeping them shouldn't hurt).

See https://github.com/pangeo-data/pangeo-cloud-federation/pull/697 for an
example moving a hubploy-based deployment from the pangeo helm chart to `dask/daskhub`.

This is the helm chart for installing Pangeo.

This chart is mainly going to be a wrapper to subcharts along with custom resources to tie them together.

Chart dependencies:
 - [jupyterhub](https://zero-to-jupyterhub.readthedocs.io/en/latest/)

## Usage

First off you need [helm](https://github.com/kubernetes/helm) if you don't have it already.

You also need to add the pangeo chart repository.

```shell
# Add repos
helm repo add pangeo https://pangeo-data.github.io/helm-chart/

# Update repos
helm repo update
```

You then need to create a `values.yaml` file with your own config options in. As this chart is a collection of dependant charts you will need to refer to their configuration documentation for details. See the [values.yaml](pangeo/values.yaml) file for more information.

```shell
# Install Pangeo
helm install pangeo/pangeo --version=<version> --name=<release name> --namespace=<namespace> -f /path/to/custom/values.yaml

# Apply changes to Pangeo
helm upgrade <release name> pangeo/pangeo -f /path/to/custom/values.yaml

# Delete Pangeo
helm delete <release name> --purge
```

## Default user image

This Helm chart uses the [pangeo/base-notebook](https://hub.docker.com/r/pangeo/base-notebook) Docker image as its default user image. This image is configured and maintained in the [Pangeo-stacks](https://github.com/pangeo-data/pangeo-stacks) repository and only includes a very basic environment. Pangeo-stacks includes other images that can be readily used by this chart.
