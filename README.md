Packages
=============

[Snap](http://snapcraft.io/) and [Flatpak](http://flatpak.org/) are cool new ways of distributing Linux applications among a wide range of different distros. They are technologies to deploy applications in a secure, sandboxed and containerised way.

In here there are **Snap** and **Flatpak** packages.

#### Ubuntu Snap Packages
- Anatine, a Twitter client: check [anatine](https://github.com/sindresorhus/anatine) for more details. See the [Installation notes] (https://github.com/claudioandre/packages/tree/master/anatine#anatine).
- John the ripper, a password auditing software: check [John the Ripper](https://github.com/magnumripper/JohnTheRipper) for more details. See the [Installation notes] (https://github.com/claudioandre/packages/tree/master/john-the-ripper#john-the-ripper).
- Namebench, a benchmark tool: check [namebench](https://code.google.com/archive/p/namebench) for more details.
- B1, a file archiver: check [B1](http://b1.org/) for more details.
- Corebird, a Twitter client: check [corebird](https://github.com/baedert/corebird) for more details (*not published*).
- doctl, a Digital Ocean tool: check [doctl](https://github.com/digitalocean/doctl) for more details (*not published*).
- Peazip, a file archiver: check [peazip](http://www.peazip.org/) for more details (*not published*; upstream is not working on Linux).
- Polly, a Twitter client: check [polly](https://launchpad.net/polly) for more details (*not published*; upstream is dead).

All the Snap packages are built using a build server. At this moment, I'm using **Launchpad** to build the Snap packages.

Anyone can get, for free (as in beer and in freedom), the reviewed packages from [**uAppExplorer**](https://uappexplorer.com/apps?q=author%3AClaudio+Andr%C3%A9&type=all_types&sort=-points). Despite the fact it is an unofficial repository, all packages are hosted and reviewed (automatically) by Ubuntu.

#### Flatpak Package
- John the Ripper also has a Flatpak package available. [Click here](https://github.com/claudioandre/packages/tree/master/john-the-ripper#flatpak) for more details.

At this moment, I'm using **GitLab** to build the Flatpak package.

#### Windows Package
- John the Ripper also has a Windows package available. [Click here](https://github.com/claudioandre/packages/releases/tag/v1.0) for more details.

At this moment, I'm using **AppVeyor CI** to build the Windows package.

## License

GPL 2.0
