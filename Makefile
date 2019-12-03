PKGNAMESUFFIX=	-guest-agent

MAINTAINER=	zhecka@gmail.com
COMMENT=	QEMU guest-agent utilities
USE_RC_SUBR=	qemu-guest-agent
FILESDIR=	${.CURDIR}/files

HAS_CONFIGURE=	yes
#USES=		cpe gmake pkgconfig perl5 python:2.7,build tar:xz
USES=		gmake pkgconfig python:build tar:xz
#USE_GNOME=	glib20
MAKE_ENV+=	BSD_MAKE="${MAKE}" PREFIX=${PREFIX}
CONFLICTS_INSTALL=	qemu-[0-9]* qemu-devel-* qemu-sbruno-*

OPTIONS_EXCLUDE=SAMBA X11 GTK3 OPENGL GNUTLS SASL JPEG PNG CURL \
		CDROM_DMA PCAP USBREDIR GNS3 X86_TARGETS \
		STATIC_LINK NCURSES VDE

OPTIONS_SLAVE=	DOCS

MASTERDIR=	/usr/ports/emulators/qemu
PLIST=		${.CURDIR}/pkg-plist
DESCR=		${.CURDIR}/pkg-descr
EXTRA_PATCHES=	${.CURDIR}/files/patch-configure \
		${.CURDIR}/files/patch-commands-posix \
		${.CURDIR}/files/patch-qga-main \
		${.CURDIR}/files/patch-qga-Makefile-objs
PKGMESSAGE=

PORTDOCS=	

CONFIGURE_ARGS?=--localstatedir=/var --extra-ldflags=-L\"${LOCALBASE}/lib\" \
		--disable-libssh \
		--mandir=${MANPREFIX}/man \
		--prefix=${PREFIX} --cc=${CC} --disable-kvm \
		--disable-linux-user --disable-linux-aio --disable-xen \
		--python=${PYTHON_CMD} \
		--extra-cflags=-I${WRKSRC}\ -I${LOCALBASE}/include\ -DPREFIX=\\\"\"${PREFIX}\\\"\" \
		--disable-curl \
		--disable-gnutls \
		--disable-gtk \
		--disable-vte \
		--disable-vnc-jpeg \
		--disable-opengl \
		--disable-usb-redir \
		--disable-sdl \
		--disable-system \
		--disable-user \
		--disable-guest-agent \
		--disable-nettle \
		--disable-gcrypt \
		--disable-curses \
		--disable-vnc \
		--disable-virtfs \
		--disable-brlapi \
		--disable-fdt \
		--disable-bluez \
		--disable-kvm \
		--disable-rdma \
		--disable-vde \
		--disable-netmap \
		--disable-cap-ng \
		--disable-attr \
		--disable-vhost-net \
		--disable-spice \
		--disable-rbd \
		--disable-libiscsi \
		--disable-libnfs \
		--disable-smartcard \
		--disable-libusb \
		--disable-usb-redir \
		--disable-lzo \
		--disable-snappy \
		--disable-bzip2 \
		--disable-seccomp \
		--disable-coroutine-pool \
		--disable-glusterfs \
		--disable-tpm \
		--disable-numa \
		--disable-blobs \
		--disable-capstone \
		--disable-tcg-interpreter \
		--disable-slirp \
		--enable-guest-agent

LIB_DEPENDS=
INSTALLS_ICONS=

# qemu-guest-agent must patch Makefile during pre-configure, because the master port
# also patches Makefile.  We can't use EXTRA_PATCHES, because that happens
# before do-patch, and causes a conflict with the master port's patch. And we
# can't use post-patch, because the master port also defines that target.
pre-configure:
	${PATCH} ${WRKSRC}/Makefile ${.CURDIR}/files/patch-Makefile


post-install:
	@${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/qemu-*
	@${RM} ${STAGEDIR}${PREFIX}/bin/qemu-nbd
	@${RM} ${STAGEDIR}${PREFIX}/bin/qemu-edid
	@${RM} ${STAGEDIR}${PREFIX}/bin/qemu-img
	@${RM} ${STAGEDIR}${PREFIX}/bin/qemu-io
	@${RMDIR} ${STAGEDIR}${DATADIR}
	${MKDIR} ${STAGEDIR}${PREFIX}/qemu

.include "${MASTERDIR}/Makefile"
