# dive-manifest

## How to use

Quickly setup test working directory:

```sh
test_name=dive_manifest
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir
```

Run the following command to setup local k8s cluster and deploy Athenz server:

```sh
git clone https://github.com/mlajkim/dive-manifest.git manifest
make -C manifest setup ATHENZ_DIR="../athenz"
```

Once completed, you will have Athenz source code in `athenz` and Athenz server running on the local k8s cluster.

## Note

The setup script currently only supports macOS.
