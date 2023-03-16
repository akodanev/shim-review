FROM docker.io/bellsoft/alpaquita-linux-gcc:12.2-glibc-230223

COPY . /shim-review

RUN apk update && apk add abuild git
RUN abuild-keygen -an
RUN git clone -b stream https://github.com/bell-sw/alpaquita-aports.git

WORKDIR /alpaquita-aports/core/shim
RUN abuild -Fr

WORKDIR /
RUN mkdir apk && tar -C apk -xzvf /$(whoami)/packages/core/$(arch)/shim-15.7-r2.apk

RUN sha256sum /shim-review/shimx64.efi /apk/boot/efi/EFI/alpaquita/shimx64.efi

RUN hexdump -Cv /apk/boot/efi/EFI/alpaquita/shimx64.efi > build && \
    hexdump -Cv /shim-review/shimx64.efi > orig && \
    diff -u orig build
