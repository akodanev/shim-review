FROM docker.io/debian:bookworm-20240423-slim
ENV pkgrel=15.8

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates build-essential wget bsdmainutils dos2unix libelf-dev gcc-aarch64-linux-gnu

COPY . /shim-review
RUN mkdir /pkg

WORKDIR /shim-review
RUN wget https://github.com/rhboot/shim/releases/download/$pkgrel/shim-$pkgrel.tar.bz2
RUN echo "a79f0a9b89f3681ab384865b1a46ab3f79d88b11b4ca59aa040ab03fffae80a9  shim-$pkgrel.tar.bz2" | sha256sum -c
RUN tar -xjvf shim-$pkgrel.tar.bz2

WORKDIR /shim-review/shim-$pkgrel
RUN cp ../sbat.distro.csv data/

ENV CFLAGS="-Os"
RUN mkdir -p build-x86-64 build-aarch64
RUN make -C build-x86-64 ARCH=x86_64 TOPDIR=.. -f ../Makefile \
    VENDOR_CERT_FILE=/shim-review/bellsoft-uefi-ca.der DESTDIR=/pkg/x86_64 EFIDIR=alpaquita install
RUN make -C build-aarch64 ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- TOPDIR=.. -f ../Makefile \
    VENDOR_CERT_FILE=/shim-review/bellsoft-uefi-ca.der DESTDIR=/pkg/aarch64 EFIDIR=alpaquita install

WORKDIR /shim-review
RUN for i in x86_64 aarch64; do \
        case $i in \
            x86_64) shim_name=shimx64.efi;; \
            aarch64) shim_name=shimaa64.efi;; \
        esac; \
        sha256sum /shim-review/$shim_name /pkg/$i/boot/efi/EFI/alpaquita/$shim_name; \
        hexdump -Cv /pkg/$i/boot/efi/EFI/alpaquita/$shim_name > build.$i; \
        hexdump -Cv /shim-review/$shim_name > orig.$i; \
        diff -u orig.$i build.$i; \
    done
