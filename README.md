# dive-manifest

## How to use

Optional, but let's quickly setup test working directory:

```sh
test_name=dive_manifest
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir
```

Run the following command:

```sh
git clone https://github.com/mlajkim/dive-manifest.git manifest
make -C manifest setup
```

Then you will have Athenz source code:

```sh
 tree . -L 2

# .
# └── manifest
#     ├── Makefile
#     ├── README.md
#     ├── athenz
#     └── hack
```

And running Athenz server:

```sh
kubectl get pods -n athenz

# NAME                                 READY   STATUS    RESTARTS        AGE
# athenz-cli-574d747dff-fqwpr          1/1     Running   0               15
# athenz-db-0                          1/1     Running   0               15d
# athenz-ui-59f7f77667-nl994           2/2     Running   0               15d
# athenz-zms-server-6c8d9f4994-b8kjv   1/1     Running   0               4d22h
# athenz-zts-server-8b67d4d5f-vm2t7    1/1     Running   0               15d
```


## Note

The current script does not work for Linux/Windows as most of the time people do use MacOS for local development. If we ever make support for other OS, we will create a separate script, and let Makefile handle the logic (or other logic hack script)