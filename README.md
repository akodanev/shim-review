
*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
BellSoft

https://bell-sw.com

*******************************************************************************
### What product or service is this for?
*******************************************************************************
BellSoft Alpaquita Linux

https://bell-sw.com/alpaquita-linux/

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
Alpaquita Linux is a lightweight operating system optimized for Java.
Alpaquita supports Secure Boot and we would like it to work right out of the box
without additional effort on the part of users.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
BellSoft is an ISV that provides Alpaquita Linux distribution. Therefore, we need
to be able to:

* manage Linux kernel version, compiler used and build options
* customize grub, kernel and its config, have specific kernel flavors
* have several related userspace tools (e.g. in the grub package) built with
  two different libc: musl and glibc
* maintain our own release cycle and support model.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************
- Name: Alexey Kodanev
- Position: Senior Software Engineer
- Email address: aleksei.kodanev@bell-sw.com
- PGP key fingerprint: CC86 C0DE D7EB 33D7 CC5C 99CE DAE6 3D18 7078 62D3

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name: Aleksei Voitylov
- Position: CTO
- Email address: aleksei.voitylov@bell-sw.com
- PGP key fingerprint: E150 0BAE 2B4C 4A48 48DB 3584 9406 C4AE FC38 5C5B

*******************************************************************************
### Were these binaries created from the 15.7 shim release tar?
Please create your shim binaries starting with the 15.7 shim release tar file: https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.7 and contains the appropriate gnu-efi source.

*******************************************************************************
Yes, we are using 15.7 release.

*******************************************************************************
### URL for a repo that contains the exact code which was built to get this binary:
*******************************************************************************
https://github.com/rhboot/shim/tree/15.7

Additional patches: https://github.com/akodanev/shim-review/tree/alpaquita-shim-x64-20231010/patches

*******************************************************************************
### What patches are being applied and why:
*******************************************************************************
* "Add validation function for Microsoft signing" (https://github.com/rhboot/shim/pull/531)
* 7c76425 "Enable the NX compatibility flag by default."
* 657b248 "Make sbat_var.S parse right with buggy gcc/binutils"

*******************************************************************************
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
*******************************************************************************
Fedora-like implementation.

*******************************************************************************
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of grub affected by any of the CVEs in the July 2020 grub2 CVE list, the March 2021 grub2 CVE list, the June 7th 2022 grub2 CVE list, or the November 15th 2022 list, have fixes for all these CVEs been applied?

* CVE-2020-14372
* CVE-2020-25632
* CVE-2020-25647
* CVE-2020-27749
* CVE-2020-27779
* CVE-2021-20225
* CVE-2021-20233
* CVE-2020-10713
* CVE-2020-14308
* CVE-2020-14309
* CVE-2020-14310
* CVE-2020-14311
* CVE-2020-15705
* CVE-2021-3418 (if you are shipping the shim_lock module)

* CVE-2021-3695
* CVE-2021-3696
* CVE-2021-3697
* CVE-2022-28733
* CVE-2022-28734
* CVE-2022-28735
* CVE-2022-28736
* CVE-2022-28737

* CVE-2022-2601
* CVE-2022-3775
*******************************************************************************
Yes, our GRUB includes fixes for the above CVE list.
The applied patches are here:
https://github.com/bell-sw/alpaquita-aports/tree/stream/core/grub

*******************************************************************************
### If these fixes have been applied, have you set the global SBAT generation on your GRUB binary to 3?
*******************************************************************************
Now, it is `grub,4`, as there have been new fixes for grub ntfs driver recently:
CVE-2023-4693 and CVE-2023-4692.

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
*******************************************************************************
This is our initial review request. Booting the old GRUB2 builds is rejected
with the new SBAT revocation data (`grub,3`).

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
*******************************************************************************
All of the above commits are present. Currently, we are using the upstream stable
v6.1.56 from https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
On top of the stable v6.1 we apply the following security related patches from Debian:
```
arm64: add kernel config option to lock down when in Secure Boot mode
mtd: phram,slram: Disable when the kernel is locked down
efi: Lock down the kernel if booted in secure boot mode
efi: Add an EFI_SECURE_BOOT flag to indicate secure boot mode
```

All the patches can be found here:
https://github.com/bell-sw/alpaquita-aports/tree/stream/core/linux-lts

*******************************************************************************
### Do you use an ephemeral key for signing kernel modules?
### If not, please describe how you ensure that one kernel build does not load modules built for another kernel.
*******************************************************************************
Yes, build time generated key.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
No, we don't use it.

*******************************************************************************
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
*******************************************************************************
We have never signed grub without sbat section.

*******************************************************************************
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
*******************************************************************************
Dockerfile is included in the shim-review.
The command to run the build can look like this: `docker build .`

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************
build.log

*******************************************************************************
### What changes were made since your SHIM was last signed?
*******************************************************************************
N/A. This is the first review request from us.

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
`e8995c52597b49639b12f6d954141280c2d2fc2ba1e1e7761c0af65e44e1a102`

*******************************************************************************
### How do you manage and protect the keys used in your SHIM?
*******************************************************************************
The key is stored in a FIPS-140-2 level 2 compliant HSM.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the SHIM?
*******************************************************************************
No.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( grub2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
*******************************************************************************
shim:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,3,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.alpaquita,1,Alpaquita Linux,shim,15.7,https://bell-sw.com/support/
```

grub:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,4,Free Software Foundation,grub,2.06,https//www.gnu.org/software/grub/
grub.alpaquita,1,Alpaquita Linux,grub,2.06-r18,https://bell-sw.com/support/
```

fwupd: currently not supported.

*******************************************************************************
### Which modules are built into your signed grub image?
*******************************************************************************
`all_video at_keyboard boot btrfs cat configfile cryptodisk disk echo efifwsetup
efinet ext2 f2fs fat font gcry_rijndael gcry_rsa gcry_serpent gcry_sha256 gcry_sha512
gcry_twofish gcry_whirlpool gfxmenu gfxterm gzio halt help hfsplus http iso9660 jpeg
linux loadenv loopback ls lsefi lsefimmap luks lvm mdraid09 mdraid1x memdisk minicmd
normal part_apple part_gpt part_msdos password_pbkdf2 png reboot regexp search
search_fs_file search_fs_uuid search_label serial sleep squash4 test tftp true
video xfs zstd`

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB or other)?
*******************************************************************************
Full version: `grub-2.06-r18`

Our GRUB is based on Alpine version 2.06-r14. Currently, they don't have the
shim package and the sbat section in grub. CVE fixes, EFI and Secure Boot
related patches cherry-picked from Fedora.

GRUB source: https://github.com/bell-sw/alpaquita-aports/tree/stream/core/grub

Patch numbering scheme in the source:

 * 0004..0292: Fedora (https://src.fedoraproject.org/rpms/grub2/tree/rawhide)
 * 1001..1016: cherry-picked upstream fixes
 * 1017..1023: Alpine patches
 * 1030..1035: cherry-picked upstream fixes for NTFS (CVE-2023-4693, CVE-2023-4692)
 * 1101      : Alpaquita specific

*******************************************************************************
### If your SHIM launches any other components, please provide further details on what is launched.
*******************************************************************************
No other components.

*******************************************************************************
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
*******************************************************************************
Linux kernel only.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
*******************************************************************************
GRUB verifies a Linux kernel signature via shim.

*******************************************************************************
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
*******************************************************************************
No.

*******************************************************************************
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
*******************************************************************************
We are using Linux stable kernel v6.1 from
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git.

In addition, lockdown patches from Debian to enforce kernel lockdown
when Secure Boot is turned on.

*******************************************************************************
### Add any additional information you think we may need to validate this shim.
*******************************************************************************
