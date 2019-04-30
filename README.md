[![Flatpak Build](https://gitlab.com/claudioandre-br/packages/badges/master/pipeline.svg)](https://gitlab.com/claudioandre-br/packages/pipelines)
[![Windows Build](https://ci.appveyor.com/api/projects/status/hd7cp5qt34xfu7d8?svg=true)](https://ci.appveyor.com/project/claudioandre-br/johntheripper)
[![FreeBSD Build](https://api.cirrus-ci.com/github/claudioandre-br/JohnTheRipper.svg)](https://cirrus-ci.com/github/claudioandre-br/JohnTheRipper)
[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://github.com/claudioandre-br/packages/blob/master/LICENSE.txt)

# Packages

[Snap](http://snapcraft.io/) and [Flatpak](http://flatpak.org/) are cool new ways
of distributing Linux applications among a wide range of different distros. They
are technologies to deploy applications in a secure, sandboxed and containerised way.

In here there are **Snap**, **Flatpak**, and **Windows** packages.

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

Our CI (continuous integration) testing scheme stresses John the Ripper source code
 using:

- CentOS 6, Ubuntu 12.04, Ubuntu 14.04, Ubuntu 16.04, Ubuntu 17.10, Ubuntu 19.04
(devel), and Fedora 29;
- FreeBSD 11 and FreeBSD 12;
- Windows Server 2012 R2 and Windows Server 2016;
- gcc 4.4, gcc 4.6, gcc 4.8, gcc 5.4, gcc 6.2[^1], gcc 7.2, gcc 7.4, gcc 8.3, and gcc 9.0;
- clang 3.9, clang 4.0, clang 5.0, clang 6.0, clang 7.0, and clang 8.0;
- SIMD and non-SIMD builds (including AVX512);
- OpenMP and non-OpenMP builds;
- LE (Little Endian) and BE (Big Endian) builds;
- ASAN (address sanitizer) and UBSAN (undefined behavior sanitizer);
- Fuzzing (<https://en.wikipedia.org/wiki/Fuzzing>);
- MinGW + Wine (on Fedora Linux);
- CygWin on Windows Server;
- OpenCL on CPU using AMD drivers and POCL (<http://portablecl.org/>);
- And a final assessment using ARMv7 (armhf), ARMv8 (aarch64), PowerPC64 Little-Endian,
and IBM System z.

[^1]: will be decomissioned in May 2019.

## License

GNU General Public License v2.0
