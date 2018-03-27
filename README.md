# Signing

This is  a repository of public keys used to validate upstream dist files.

You will need [git lfs](https://git-lfs.github.com/) installed to be able to commit / push changes to this repo.


# Using

Currently you will need to add the following to your mk.conf file:

```
# One of gnupg, signify, opmsg
SIG_TYPE ?=	gnupg
# Typically .asc for detached signatures
SIG_SUFX ?=	.asc
SIG_FILE ?=	${DISTNAME}${EXTRACT_SUFX}${SIG_SUFX}
SIG_PATH ?=	${DISTDIR}/${SIG_FILE}

fetch-sig:
	@${ECHO_MSG} "===> Checking signature files for ${FULLPKGNAME}${_MASTER}"
	@if [ ! -f ${SIG_PATH} ]; then \
	  for site in ${MASTER_SITES}; do \
	    if ${_PFETCH} ${FETCH_CMD} -o ${SIG_PATH} $${site}${SIG_FILE}; then \
	      exit 0; \
	    fi; \
	  done; exit 1; \
	fi

verify: fetch fetch-sig
	@if [ ${SIG_TYPE} == "gnupg" ]; then \
		env GNUPGHOME=${PREFIX}/share/signing/gnupg/ \
			${PREFIX}/bin/gpg2 --verify \
			${SIG_PATH} && \
		echo "Signature OK" || \
		echo "Signature NOT VALID!" ; \
	fi ;
	@if [ ${SIG_TYPE} == "opmsg" ]; then \
		${PREFIX}/bin/opmsg -c \
			${PREFIX}/share/signing/opmsg \
			-V ${DISTDIR}/${DISTNAME}${EXTRACT_SUFX} \
			--in ${SIG_PATH} ; \
	fi ;
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
