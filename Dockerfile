FROM docker.io/debian:bookworm-20230202-slim

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y ca-certificates build-essential wget bsdmainutils dos2unix libelf-dev

COPY . /shim-review
RUN mkdir /pkg

WORKDIR /shim-review
RUN wget https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2
RUN echo "87cdeb190e5c7fe441769dde11a1b507ed7328e70a178cd9858c7ac7065cfade  shim-15.7.tar.bz2" | sha256sum -c
RUN tar -xjvf shim-15.7.tar.bz2

WORKDIR /shim-review/shim-15.7
RUN for p in ../patches/*.patch; do patch -p1 -i $p; done
RUN cp ../sbat.distro.csv data/
RUN CFLAGS="-Os" make VENDOR_CERT_FILE=../bellsoft-uefi-ca.der DESTDIR=/pkg EFIDIR=alpaquita install

WORKDIR /shim-review
RUN sha256sum /shim-review/shimx64.efi /pkg/boot/efi/EFI/alpaquita/shimx64.efi

RUN hexdump -Cv /pkg/boot/efi/EFI/alpaquita/shimx64.efi > build && \
    hexdump -Cv /shim-review/shimx64.efi > orig && \
    diff -u orig build
