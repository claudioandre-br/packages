# Anatine

> Pristine Twitter app

This app is based the awesome [Mobile Twitter](https://mobile.twitter.com) site, but modifies a lot of things and makes it more usable on the desktop.

### Snap

[**A Snap**](http://snapcraft.io/) is a fancy zip file containing an application together with its dependencies, and a description of how it should safely be run on your system.

If you are using Ubuntu (or if your distro already has a Snap Store), do:

```
$ sudo snap install anatine
```

If you distro do not offer a Store, you can download the package from
[**uAppExplorer**](https://uappexplorer.com/app/anatine.claudioandre-br).
In all cases, packages are hosted and reviewed (automatically) by Ubuntu. The instalation can be done using:

```
$ sudo snap install *.snap
```

Known issues:
- You need to install snapd-xdg-open on your computer `sudo apt-get install snapd-xdg-open`. [1]
- Tray integration. [2]
- No sound. [2]
- On "invalid system call" error, do `sudo snap connect anatine:process-control ubuntu-core:process-control`
- None should use the Ubuntu Software UI to install any snap package: it requires an Ubuntu Store account and it fails.

[1] Upstream is working to fix this. <br />
[2] This is fixed upstream (not released yet).
