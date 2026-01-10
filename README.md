# dive-manifest

## How to use

Optional, but let's quickly setup tset working directory:

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


## Note

The current script does not work for Linux/Windows as most of the time people do use MacOS for local development. If we ever make support for other OS, we will create a separate script, and let Makefile handle the logic (or other logic hack script)