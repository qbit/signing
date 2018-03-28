# Signing

This is  a repository of public keys used to validate upstream dist files.

You will need [git lfs](https://git-lfs.github.com/) installed to be able to commit / push changes to this repo.


# Using

Currently you will need to add the following to your mk.conf file:

```
.include "/usr/local/share/signing/signing.mk"
```

SIG_SUFX should be set per port. Currently only validating detatched
signatures is supported.

# Adding keys

## gnupg

```
$ git clone https://github.com/qbit/signing.git
$ cd signing
$ pkill gpg-agent; export GNUPGHOME=$PWD/gnupg
$ gpg2 --import newpubkey
```

## opmsg

```
$ git clone https://github.com/qbit/signing.git
$ cd signing
$ opmsg -c ./opmsg --import --in release-key-v1.opmsg --name opmsg-rkey-v1 --phash sha256
```

# Deleting keys

## gnupg
## opmsg
