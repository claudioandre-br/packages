# John the Ripper

> John the Ripper password cracker

[Openwall](http://openwall.com/) John the Ripper (JtR) is a fast password cracker, currently available for many flavors of Unix, Windows, DOS, and OpenVMS. Its primary purpose is to detect weak Unix passwords. Besides several crypt(3) password hash types most commonly found on various Unix systems, supported out of the box are Windows LM hashes, plus lots of other hashes and ciphers.

## Snap

[**A Snap**](http://snapcraft.io/) is a fancy zip file containing an application together with its dependencies, and a description of how it should safely be run on your system.

If you are using Ubuntu (or if your distro already has a Snap Store), do:
```
$ sudo snap install john-the-ripper
```

**Known issues:** snap is evolving. If you see the error message 'invalid syscall', please execute the following command:
```
$ sudo snap connect john-the-ripper:process-control ubuntu-core:process-control
```

If you distro do not offer a Store, you can download the package from [**uAppExplorer**](https://uappexplorer.com/app/john-the-ripper.claudioandre-br). In all cases, packages are hosted and reviewed (automatically) by Ubuntu. The instalation can be done using:

```
$ sudo snap install *.snap
```

John run confined under a restrictive security sandbox by default. Nevertheless, you can access and audit any file located in your home. Below, an usage example:
```
$ john-the-ripper -list=build-info
$ john-the-ripper -list=format-tests | cut -f3 > ~/alltests.in
$ john-the-ripper -form=SHA512crypt ~/alltests.in
```

The highlights:
- fallback for CPU and OMP;
- regex and prince modes available;
- available for X86_64, armhf, arm64 and ppc64.

### Acessing OpenCL
It is possible to run the JtR OpenCL binary using the workaround seen below. To see the installed revision (**Rev**), execute:
```
$ snap list john-the-ripper
Name             Version          Rev  Developer        Notes
john-the-ripper  1.8-J1-fb051f3+  60   claudioandre-br  -
```

Then (replace 60 with your current version number):
```
$ /snap/john-the-ripper/60/john-the-ripper.opencl -list=build-info
$ /snap/john-the-ripper/60/john-the-ripper.opencl -list=opencl-devices
```

### Deployments
Currently, we are deploying a developing version of JtR in all channels (even in the stable channel). That situation might change in the future when a new jumbo 2 stable john version becames available. That said, if you want to access the hot and bleeding JtR, you should follow the development channel. For a clean installation:
```
sudo snap install --channel=edge john-the-rippper
```

If you already has JtR installed:
```
sudo snap refresh --channel=edge john-the-rippper
```

If you do so, you will be running the development version available on gitbub. The expected average gap should be 1 week.

## Flatpak

[**Flatpak**](http://flatpak.org//) is a new framework for desktop applications on Linux, built to be distribution agnostic and allow deployment on any Linux operating system out there.

Flatpak is available for the [most common Linux distributions](http://flatpak.org/getting.html).

It is our first alpha version of John the Ripper single-file flatpak bundle; it is working fine. You can get it at [github](https://github.com/claudioandre/packages/releases/tag/v0.1-alpha). To import it, do:
```
$ flatpak build-import-bundle ~/repo john.flatpak
```

The highlights:
- fallback for CPU and OMP;
- regex and prince modes available.

******
It is not clear to me what you really need to do in order to execute the flatpak bundle. Below, a list os commands you might need (don't worry, they can't hurt your environment).

```
$ dnf install -y flatpak # install the flatpak (or 'yum install', 'apt-get install', etc.)
$ flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo # add the remote (flatpak itself) repository
$ flatpak install gnome org.freedesktop.Platform//1.4 org.freedesktop.Sdk//1.4 # add the runtime (the base "container")
# 
# So, you have a local repository, let's install the software.
$ flatpak --user remote-add --no-gpg-verify --if-not-exists tutorial-repo ~/repo # --user means you only (not system wide)
$ flatpak --user install tutorial-repo com.openwall.John
$ flatpak run com.openwall.John
```
