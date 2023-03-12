# Linux-dev
-----

This repo is a development environment to build and boot from scratch
Linux for various SBCs. The purpose is to get a hands on approach to
embedded Linux development.


## Directory Structure

`boards/` - Contains Board configuration

`compiler/` - Contains the repo that builds the GCC cross compiler

`u-boot/` - Contains the U-Boot repo. Builds the Bootloader

`linux/` - Contains the Linux Kernel repo

Generated after the build:

`images/` - Contains the build images

``
## How to Build

Build image:
```
make <board>
```

Build specific target:
```
make <board> target=<target>
```
