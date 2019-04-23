# John the Ripper

> John the Ripper password cracker

[Openwall](http://openwall.com/) John the Ripper (JtR) is a fast password cracker,
currently available for many flavors of Unix, Windows, DOS, and OpenVMS. Its primary
purpose is to detect weak Unix passwords. Besides several crypt(3) password hash
types most commonly found on various Unix systems, supported out of the box are
Windows LM hashes, plus lots of other hashes and ciphers.

## Snap

> Built and deployed using Launchpad

[**A Snap**](http://snapcraft.io/) is a fancy zip file containing an application
together with its dependencies, and a description of how it should safely be run
on your system.

You can install JtR by following the instructions at
[https://snapcraft.io/john-the-ripper](https://snapcraft.io/john-the-ripper).

Terminal-based users should [enable snap support](https://docs.snapcraft.io/core/install),
then install JtR like this:

```bash
 sudo snap install john-the-ripper
```

Also, You can download the packages for all supported architectures at
[**uAppExplorer**](https://uappexplorer.com/snap/ubuntu/john-the-ripper).

John runs confined under a restrictive security sandbox by default. Nevertheless,
you can access and audit any file located in your home. Below, an usage example:

```bash
 john-the-ripper -list=build-info
 john-the-ripper -list=format-tests | cut -f3 > ~/alltests.in
 john-the-ripper -form=SHA512crypt ~/alltests.in
```

For your convenience, the snap installed on your system contains the file
`/snap/john-the-ripper/current/snap/manifest.yaml` which field `build_url`
points to its build log.

The highlights:

- fallback for CPU[*] and OMP;
- prince mode available;
- OpenCL available (GPU driver installation is needed);
- also available via the alias **john**, e.g. `john -list=build-info`;
- a stable version (John 1.9.0 Jumbo 1):
  - is available for X86_64, armhf, arm64, ppc64el, i386, powerpc, and s390x;
  - has regex mode available;
- a development version:
  - is available for X86_64, arm64, ppc64el, and s390x.

[*] John the Ripper runs using the best SIMD instructions available on the host
it's running on.

### Running a non-OpenMP build

In some situations a non-OpenMP build may be faster. You can ask to fallback to a
non-OpenMP build specifying `OMP_NUM_THREADS=1 john <options>` in the command line.
You avail the best SIMD instructions at one's disposal without any OpenMP stuff. E.g.:

```bash
OMP_NUM_THREADS=1 john --list=build-info
```

### Enabling Aliases

You are free to pick and set up aliases. To enable the usage of aliases with John
the Ripper snap, run `sudo snap alias john-the-ripper <alias>`. For example:

```bash
 sudo snap alias john-the-ripper my-john
 sudo snap alias john-the-ripper.dmg2john dmg2john
 sudo snap alias john-the-ripper.hccap2john hccap2john
 sudo snap alias john-the-ripper.racf2john racf2john
 sudo snap alias john-the-ripper.vncpcap2john vncpcap2john
 sudo snap alias john-the-ripper.zip2john zip2john
 sudo snap alias john-the-ripper.gpg2john gpg2john
 sudo snap alias john-the-ripper.keepass2john keepass2john
 sudo snap alias john-the-ripper.putty2john putty2john
 sudo snap alias john-the-ripper.rar2john rar2john
 sudo snap alias john-the-ripper.uaf2john uaf2john
 sudo snap alias john-the-ripper.wpapcap2john wpapcap2john
```

Once enabled, John itself plus the *2john tools can be invoked using the aliases.
In the example, to run John type `my-john`.

### Acessing OpenCL

To run JtR OpenCL version you must install the snap using `developer mode`. It
enables users to install snaps without enforcing security policies. To do this,
you must install John using (**UNTESTED**):

```bash
 sudo snap install john-the-ripper --devmode
```

When installed this way, snaps behave similarly to traditional *.deb* packages in
terms of accessing system resources.

To run JtR OpenCL binary:

```bash
 john-the-ripper.opencl -list=build-info
 john-the-ripper.opencl -list=opencl-devices
```

### Snap Deployments

If you followed the above instructions, you installed the stable version of John
the Ripper Jumbo 1.9.0.J1 in your system. If you want to access the hot and bleeding
developing version of JtR, you must follow a development channel. For a clean
installation:

```bash
 sudo snap install --channel=edge john-the-ripper
```

If you already has JtR installed:

```bash
 sudo snap refresh --channel=edge john-the-ripper
```

If you do so, you will be running the development version available on GitHub.
The average gap expected is 1 week.

## Flatpak

> Built and deployed using FlatHub and GitLab CI

[**Flatpak**](http://flatpak.org//) is a new framework for desktop applications
on Linux, built to be distribution agnostic and allow deployment on any Linux
operating system out there.

Flatpak is available for the [most common Linux distributions](http://flatpak.org/getting.html).

You can install JtR by following the instructions at
[https://flathub.org/apps/detais/com.openwall.John](https://flathub.org/apps/detais/com.openwall.John).

John runs confined under a restrictive security sandbox by default. Nevertheless,
you can access and audit any file located in your home. Below, an usage example:

```bash
 flatpak run com.openwall.John -list=build-info
 flatpak run com.openwall.John -list=format-tests | cut -f3 > ~/alltests.in
 flatpak run com.openwall.John -form=SHA512crypt ~/alltests.in
```

The highlights:

- fallback for CPU[*] and OMP;
- prince mode available.
- a stable version (John 1.9.0 Jumbo 1):
  - is available for X86_64, arm, aarch64, and i386;
  - has regex mode available;
- a development version:
  - is available for X86_64.

[*] John the Ripper runs using the best SIMD instructions available on the host
it's running on.

### Flatpak Deployments

If you followed the above instructions, you installed the stable version of John
the Ripper Jumbo 1.9.0.J1 in your system. If you want to access the hot and bleeding
developing version of JtR, you must install a bundle.

John the Ripper single-file flatpak bundle was built and tested on
[GitLab](https://gitlab.com/claudioandre-br/packages/pipelines). You can get it
[here](https://rebrand.ly/JtRFlatpak).

The necessary steps to install the package are listed below. They were tested on
a clean Fedora 29 docker image, but they should work for every supported distro
out there. Don't worry, it can't hurt your Linux environment.

Install and configure flatpak itself:

```bash
 dnf install -y flatpak # or 'yum install', 'apt-get install', etc.
 flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo # flatpak repository
 flatpak install -y flathub org.freedesktop.Platform//18.08 # install the runtime (base "container")
```

Navigate to where you downloaded the john.flatpak file. Now, let's install the
software:

```bash
 flatpak --user install --bundle john.flatpak # per-user installation (not system wide)
```

Run John the Ripper and check if it is working:

```bash
 flatpak run com.openwall.John
 flatpak run com.openwall.John --list=build-info
```

## Windows

> Built and deployed using AppVeyor CI

To install John the Ripper by downloading the .zip file and installing manually,
follow these steps:

- Download the ZIP file to your machine.
- Navigate to where you downloaded the file and double click the compressed file.
- Extract it to a directory such as `C:\john-the-ripper`.
- Start a command prompt.
- Navigate to the directory you extracted the .zip file, e.g., `cd C:\john-the-ripper\run`.
- Run JtR:

```powershell
C:\john-the-ripper\run>john --list=build-info
C:\john-the-ripper\run>john --test --format=SHA512crypt
```

The link below contains all the executables and libraries needed to run a fresh
John the Ripper installation.

- [Stable John 1.9.0 Jumbo 1 32bit version](https://openwall.info/wiki/_media/john/1.9.0J1/x32_win.zip)
[(libs)](https://openwall.info/wiki/_media/john/1.9.0J1/x32_optional.zip)
[(logs)](https://openwall.info/wiki/_media/john/1.9.0J1/x32_log.txt)
- [Stable John 1.9.0 Jumbo 1 64bit version](https://openwall.info/wiki/_media/john/1.9.0J1/x64_win.zip)
[(libs)](https://openwall.info/wiki/_media/john/1.9.0J1/x64_optional.zip)
[(logs)](https://openwall.info/wiki/_media/john/1.9.0J1/x64_log.txt)
- [A 64bit development version](https://rebrand.ly/JtRWin64)

The highlights:

- fallback for CPU[*] and OMP;
- prince mode available;
- OpenCL available (GPU driver installation is needed);
- generic crypt(3) format available;
- security feature Address Space Layout Randomisation (ASLR) enabled;
- security feature Data Execution Prevention (DEP) enabled;
- a stable version (John 1.9.0 Jumbo 1):
  - is available for X86_64 and i386;
- a development version:
  - is available for X86_64.

[*] John the Ripper runs using the best SIMD instructions available on the host
it's running on.

### Running a non-OpenMP build on Windows

In some situations a non-OpenMP build may be faster. You can ask to fallback to
a non-OpenMP build specifying the value of OMP_NUM_THREADS in the command line.
You avail the best SIMD instructions at one's disposal without any OpenMP stuff. E.g.:

```powershell
C:\john-the-ripper\run>set OMP_NUM_THREADS=1
C:\john-the-ripper\run>john --list=build-info
```

### Running OpenCL

Some adjustments may be necessary to allow John the Ripper detect your GPU
hardware. If you are facing problems, please ask for support.

- That being said, the first advice to be given to anyone facing Windows problems
would be:
  - replacing cygwin's OpenCL library `cygOpenCL-1.dll` with `OpenCL.dll` installed
  in the System32 folder should make everything _almost_ work.

Benchmarking:

```bash
C:\bleeding\run>john --test=5 --format=sha512crypt-opencl
Device 0: Juniper [AMD Radeon HD 6700 Series]
Benchmarking: sha512crypt-opencl, crypt(3) $6$ (rounds=5000) [SHA512 OpenCL]... DONE
Speed for cost 1 (iteration count) of 5000
Raw:	11522 c/s real, 819200 c/s virtual
```

Real cracking:

```bash
C:\bleeding\run>john --format=sha512crypt-opencl d:\hash.txt
Device 0: Juniper [AMD Radeon HD 6700 Series]
Using default input encoding: UTF-8
Loaded 2 password hashes with 2 different salts (sha512crypt-opencl, crypt(3) $6$ [SHA512 OpenCL])
Cost 1 (iteration count) is 5000 for all loaded hashes
Press 'q' or Ctrl-C to abort, almost any other key for status
                 (?)
1g 0:00:00:28  3/3 0.03540g/s 5553p/s 9178c/s 9178C/s 123456
```

```bash
C:\bleeding\run>john --format=sha512crypt-opencl d:\hash.txt --mask=Hello?awor?l?l?a
Device 0: Juniper [AMD Radeon HD 6700 Series]
Using default input encoding: UTF-8
Loaded 2 password hashes with 2 different salts (sha512crypt-opencl, crypt(3) $6$ [SHA512 OpenCL])
Remaining 1 password hash
Cost 1 (iteration count) is 5000 for all loaded hashes
Press 'q' or Ctrl-C to abort, almost any other key for status
GPU 0 probably invalid temp reading (-1°C).
Hello world!     (?)
1g 0:00:05:06 DONE (2018-01-01 15:08) 0.003265g/s 11369p/s 11369c/s 11369C/s HelloYworik_..HelloLworurU
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

#### File hash computed by the CI server

File verification is the process of using an algorithm for verifying the integrity
of a computer file. A popular approach is to store checksums (hashes) of files,
also known as message digests, for later comparison.

Accessing the AppVeyor `Console` Tab, you can view the hashes of all relevant
files. For example:

```text
Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
SHA256          228055F2CF88F055A657BCAE3E3A898298B3AEC5766534D2B567D8993F71D2D5       C:\projects\JohnTheRipper\run\win_x64.zip
```

## Docker Image

> Built using Travis CI and deployed using Docker Hub

For testing and future reference, we have a Docker image of John the Ripper
Jumbo 1.9.0.J1. To use it:

```bash
 # CPU only formats
 docker run -it claudioandre/john:v1.9.0J1 <binary id> <john options>

 # To run ztex formats
 docker run -it --device=/dev/ttyUSB0 claudioandre/john:v1.9.0J1 <binary id> <john options>
```

Run John the Ripper and check if it is working:

```bash
 docker run -it claudioandre/john:v1.9.0J1 # => SSE2
 docker run -it claudioandre/john:v1.9.0J1 -list=format-tests | cut -f3 > ~/alltests.in
 docker run -it claudioandre/john:v1.9.0J1 ssse3-no-omp -list=build-info
 docker run -it claudioandre/john:v1.9.0J1 avx2 -test=0 -format=cpu
 docker run -it claudioandre/john:v1.9.0J1 avx512bw
 docker run -it -v "$HOME":/host claudioandre/john:v1.9.0J1 avx -form=SHA512crypt /host/alltests.in --max-run=300
```

The highlights:

- ztex formats available;
- prince mode available.

The available binaries (their IDs are sse2, sse2-no-omp, ssse3, etc):

- /john/run/john-sse2 (default binary)
- /john/run/john-sse2-no-omp
- /john/run/john-ssse3
- /john/run/john-ssse3-no-omp
- /john/run/john-sse4.1
- /john/run/john-sse4.1-no-omp
- /john/run/john-sse4.2
- /john/run/john-sse4.2-no-omp
- /john/run/john-avx
- /john/run/john-avx-no-omp
- /john/run/john-xop
- /john/run/john-xop-no-omp
- /john/run/john-avx2
- /john/run/john-avx2-no-omp
- /john/run/john-avx512f
- /john/run/john-avx512f-no-omp
- /john/run/john-avx512bw
- /john/run/john-avx512bw-no-omp
