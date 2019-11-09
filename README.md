# Packages

[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://github.com/claudioandre-br/packages/blob/master/LICENSE.txt)

This repository contains Snaps, a Flatpak, Windows packages, and a Docker Image.

[Snap](http://snapcraft.io/) and [Flatpak](http://flatpak.org/) are cool new ways
of distributing Linux applications among a wide range of different distros. They
are technologies to deploy applications in a secure, sandboxed and containerised way.

#### Ubuntu Snap Packages

- John the ripper, a password auditing software: check [John the Ripper](https://github.com/magnumripper/JohnTheRipper) for more details. See the [Installation notes](https://github.com/claudioandre-br/packages/tree/master/john-the-ripper#john-the-ripper).
- IRPF, a Brazilian government tool: check this [text](https://claudioandre-br.github.io/outros/irpf_package.htm?id=git) for more details.
- Namebench, a benchmark tool: check [namebench](https://code.google.com/archive/p/namebench)
for more details.
- B1, a file archiver: check [B1](http://b1.org/) for more details.

All the Snap packages are built using a build server. At this moment, I'm using
**Launchpad** to build the Snap packages.

Anyone can get, for free (as in beer), the reviewed packages from [**uAppExplorer**](https://uappexplorer.com/snaps?q=author%3AClaudio+Andr%C3%A9&sort=-points). Despite
 the fact it is an unofficial repository, all packages are hosted and reviewed
 (automatically) by Ubuntu.

#### Flatpak Package

- John the Ripper also has a Flatpak package available. [Click here](https://github.com/claudioandre-br/packages/tree/master/john-the-ripper#flatpak)
for more details.

At this moment, I'm using **FlatHub** and **GitLab** to build the Flatpak package.

#### Windows Package

- John the Ripper also has a Windows package available. [Click here](https://github.com/claudioandre-br/packages/blob/master/john-the-ripper/readme.md#windows)
 for more details.

At this moment, I'm using **AppVeyor CI** to build the Windows package.

#### Docker Image

- John the Ripper also has a Docker image. [Click here](https://github.com/claudioandre-br/packages/blob/master/john-the-ripper/readme.md#docker-image)
 for more details.

At this moment, I'm using **Travis CI** to build the Docker image.

## Testing

Using multiple providers, I've created my DevOps infrastructure. I am mostly interested
in quality assurance, CI (continuous integration), and CD (continuous delivery). To achieve
this goal, my testing scheme builds and inspects the source code of John the Ripper
using:

- Microsoft Windows:
  - Windows Server 2012 R2 Datacenter (6.3.9600 N/A Build 9600);
  - Windows Server 2016 Datacenter (10.0.14393 N/A Build 14393);
  - Windows Server 2019 Datacenter (10.0.17763 N/A Build 17763);
- Unix®-like BSD:
  - FreeBSD 11 (11.2-RELEASE);
  - FreeBSD 12 (12.0-RELEASE);
- MacOS:
  - macOS 10.13 (Darwin Kernel Version 17.4.0);
  - macOS 10.14 (Darwin Kernel Version 18.5.0);
- Linux:
  - CentOS 6 and Fedora 31;
  - Ubuntu 12.04, Ubuntu 14.04, Ubuntu 16.04, Ubuntu 18.04, Ubuntu 19.10, and Ubuntu 20.04
 (devel);
- Compilers:
  - gcc 4.4, gcc 4.6, gcc 4.8, gcc 7.4, gcc 8.3, gcc 9.2, and gcc 10.0;
  - clang 5.0, clang 6.0, and clang 9.0;
  - Xcode 9.4; Apple LLVM version 9.1.0 (clang-902.0.39.2);
  - Xcode 10.2; Apple LLVM version 10.0.1 (clang-1001.0.46.4);
  - Xcode 11.2; Apple LLVM version 10.0.1 (clang-1001.0.46.4);
- Builds:
  - SIMD and non-SIMD builds;
  - OpenMP and non-OpenMP builds;
  - LE (Little Endian) and BE (Big Endian) builds;
  - ASAN (address sanitizer) and UBSAN (undefined behavior sanitizer);
  - Fuzzing (<https://en.wikipedia.org/wiki/Fuzzing>);
  - MinGW and Wine on Fedora Linux;
  - CygWin on Windows Server;
  - OpenCL on CPU using Apple, Intel, and POCL (<http://portablecl.org/>) runtimes;
  - OpenCL on GPU using Azure cloud (_work in progress_);
  - And a final assessment using ARMv7 (armhf), ARMv8 (aarch64), PowerPC64 Little-Endian,
and IBM System z.

Plans and future vision:

- Develop a fully automated build and release pipeline using Azure DevOps Services
  to create the CI/CD pipeline and Azure Services for deploying to development/staging and
  production.
  See the [release workflow here](https://github.com/claudioandre-br/packages/blob/master/john-the-ripper/CI-workflow.pdf).

#### Supported and Tested SIMD Extensions

| Architecture | SIMD |
| :-: | :-: |
| ARM | NEON, ASIMD |
| PowerPC | Altivec |
| S390x | SIMD is not supported |
| x86| AVX512BW, AVX512F, AVX2, XOP, AVX, SSE4.2, SSE4.1, SSSE3, SSE2 |

#### Development Builds and Artifacts

| Provider   | OS | Artifacts |
| ------------- | ------------- | ----- |
| AppVeyor CI | Windows | ✓ Build artifacts available |
| Azure | Linux and Windows | ✓ Build artifacts available |
| Azure | OpenCL on GPU | ∅ Under development |
| Circle CI | Linux | ✗ No build artifacts |
| Cirrus CI | FreeBSD | ✗ No build artifacts |
| GitLab CI | Linux (FlatPak app) | ✓ Build artifacts available |
| LaunchPad | Linux (Snap app) | ✓ Build artifacts available |
| Travis CI | Linux and macOS | ✗ No build artifacts |

## Security

Please inspect all packages prior to running any of them to ensure safety.
We already know they're safe, but you should verify the security and contents of any
binary from the internet you are not familiar with.

We take security very seriously.

## License

GNU General Public License v2.0
