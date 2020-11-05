# mkimage-profile-embedded
mkimage profile for embedded solutions

## Prepare for using with special architectures
```sh
# apt-get install mkimage qemu-user-static-binfmt-$ARCH
```
where ARCH is one of valid maintained architectures:
* ppc
* armh
* aarch64


## Using
For using just run:
```sh
$ make
```
