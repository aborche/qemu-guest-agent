
PORTNAME=       qemu
PORTVERSION=    4.1.1
PKGNAMESUFFIX=	-guest-agent
CATEGORIES=     emulators
MASTER_SITES=   https://download.qemu.org/
DIST_SUBDIR=    qemu/${PORTVERSION}
USE_RC_SUBR=	qemu-guest-agent
FILESDIR=	${.CURDIR}/files

MAINTAINER=	zhecka@gmail.com
COMMENT=	QEMU guest-agent utilities

LICENSE=        GPLv2

HAS_CONFIGURE=	yes
USES=		gmake pkgconfig python:build tar:xz
USE_GNOME=	glib20
MAKE_ENV+=	BSD_MAKE="${MAKE}" PREFIX=${PREFIX}
CONFLICTS_INSTALL=	qemu-[0-9]* qemu-devel-* qemu-sbruno-*

OPTIONS_EXCLUDE=SAMBA X11 GTK3 OPENGL GNUTLS SASL JPEG PNG CURL \
		CDROM_DMA PCAP USBREDIR GNS3 X86_TARGETS DOCS\
		STATIC_LINK NCURSES VDE

MASTERDIR=	/usr/ports/emulators/qemu
PLIST=		${.CURDIR}/pkg-plist
DESCR=		${.CURDIR}/pkg-descr
EXTRA_PATCHES=	${.CURDIR}/files/patch-configure \
		${.CURDIR}/files/patch-commands-posix \
		${.CURDIR}/files/patch-qga-main \
		${.CURDIR}/files/patch-qga-Makefile-objs

PKGMESSAGE=

# Port doc section
# OPTIONS_DEFINE=	DOCS
PORTDOCS=
# qemu-doc.html qemu-doc.txt qemu-ga-ref.html qemu-ga-ref.txt
# DOCS_BUILD_DEPENDS=    texi2html:textproc/texi2html \
#                       sphinx-build:textproc/py-sphinx
# DOCS_MAKE_ARGS_OFF=    NOPORTDOCS=1
# DOCS_USES=             makeinfo


CONFIGURE_ARGS?=--localstatedir=/var --extra-ldflags=-L\"${LOCALBASE}/lib\" \
		--enable-debug-info --enable-debug \
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
		--disable-debug-tcg \
		--disable-slirp \
		--disable-bochs \
		--disable-cloop \
		--disable-dmg \
		--disable-qcow1 \
		--disable-vdi \
		--disable-vvfat \
		--disable-qed \
		--disable-parallels \
		--disable-sheepdog \
		--disable-live-block-migration \
		--disable-qom-cast-debug \
		--disable-debug-mutex \
		--disable-vhost-user \
		--disable-vhost-vsock \
		--disable-vhost-scsi \
		--disable-vhost-crypto \
		--disable-vhost-net \
		--disable-iconv \
		--disable-auth-pam \
		--disable-libxml2 \
		--disable-replication \
		--enable-guest-agent

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

.include <bsd.port.options.mk>

.if !defined(STRIP) || ${STRIP} == ""
CONFIGURE_ARGS+=--disable-strip
.endif

.if ${ARCH} == "amd64"
MAKE_ARGS+=	ARCH=x86_64
.endif

.if ${ARCH} == "powerpc"
MAKE_ARGS+=	ARCH=ppc
.endif

.if ${ARCH} == "powerpc64"
MAKE_ARGS+=	ARCH=ppc64
.endif

.if ${ARCH} == "sparc64"
CONFIGURE_ARGS+=	--sparc_cpu=v9
.endif

PLIST_SUB+=	LINUXBOOT_DMA=""

# XXX need to disable usb host code on head while it's not ported to the
# new usb stack yet
post-configure:
	@${REINPLACE_CMD} -E \
		-e "s|^(HOST_USB=)bsd|\1stub|" \
		${WRKSRC}/config-host.mak

.include <bsd.port.mk>
