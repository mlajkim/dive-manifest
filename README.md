# dive-manifest

## How to use

Run the following command to setup local k8s cluster and deploy Athenz server:

```sh
git clone https://github.com/mlajkim/dive-manifest.git manifest
make -C manifest setup
```

Once completed, you will have Athenz source code in `manifest/athenz` and Athenz server running on the local k8s cluster.

## Note

The setup script currently only supports macOS.
