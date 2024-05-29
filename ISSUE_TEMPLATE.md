Confirm the following are included in your repo, checking each box:

 - [x] completed README.md file with the necessary information
 - [x] shim.efi to be signed
 - [x] public portion of your certificate(s) embedded in shim (the file passed to VENDOR_CERT_FILE)
 - [x] binaries, for which hashes are added to vendor_db ( if you use vendor_db and have hashes allow-listed )
 - [x] any extra patches to shim via your own git tree or as files
 - [x] any extra patches to grub via your own git tree or as files
 - [x] build logs
 - [x] a Dockerfile to reproduce the build of the provided shim EFI binaries

*******************************************************************************
### What is the link to your tag in a repo cloned from rhboot/shim-review?
*******************************************************************************
https://github.com/akodanev/shim-review/tree/alpaquita-shim-x64-aarch64-20240528

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
```
f83b753616fab1bffa57a1ea446577c1c20e36d0726885ae6f9da035cf12ef9b  shimaa64.efi
2b2f2dada7a8e0060dfbd8d6d4ef926b0d57a49edb8560623091eedcc9f205fd  shimx64.efi
```

*******************************************************************************
### What is the link to your previous shim review request (if any, otherwise N/A)?
*******************************************************************************
https://github.com/rhboot/shim-review/issues/325

*******************************************************************************
### If no security contacts have changed since verification, what is the link to your request, where they've been verified (if any, otherwise N/A)?
*******************************************************************************
https://github.com/rhboot/shim-review/issues/325#issuecomment-1755613348
