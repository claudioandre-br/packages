# John the Ripper

> John the Ripper password cracker

[Openwall](http://openwall.com/) John the Ripper (JtR) is a fast password cracker, currently available for many flavors of Unix, Windows, DOS, and OpenVMS. Its primary purpose is to detect weak Unix passwords. Besides several crypt(3) password hash types most commonly found on various Unix systems, supported out of the box are Windows LM hashes, plus lots of other hashes and ciphers.

## Snap
> Built and deployed using Launchpad

[**A Snap**](http://snapcraft.io/) is a fancy zip file containing an application together with its dependencies, and a description of how it should safely be run on your system.

If you are using Ubuntu (or if your distro already has a Snap Store), do:
```
$ sudo snap install john-the-ripper
```

**Known issues:** snap is evolving. If you see the error message 'invalid syscall', please execute the following command:
```
$ sudo snap connect john-the-ripper:process-control ubuntu-core:process-control
```

If your distro do not offer a Store, you can download the package from [**uAppExplorer**](https://uappexplorer.com/app/john-the-ripper.claudioandre-br). In all cases, packages are hosted and reviewed (automatically) by Ubuntu. The instalation can be done using:

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
Currently, we are deploying a developing version of JtR in all channels (even in the stable channel). That situation might change in the future when a new john Jumbo 2 version becames available. That said, if you want to access the hot and bleeding JtR, you should follow the development channel. For a clean installation:
```
sudo snap install --channel=edge john-the-ripper
```

If you already has JtR installed:
```
sudo snap refresh --channel=edge john-the-ripper
```

If you do so, you will be running the development version available on gitbub. The average gap expected is 1 week.

## Flatpak
> Built and deployed using GitLab CI

[**Flatpak**](http://flatpak.org//) is a new framework for desktop applications on Linux, built to be distribution agnostic and allow deployment on any Linux operating system out there.

Flatpak is available for the [most common Linux distributions](http://flatpak.org/getting.html).

John the Ripper single-file flatpak bundle was built and tested on [GitLab](https://gitlab.com/claudioandre/packages/pipelines). You can get it at [GitHub](https://github.com/claudioandre/packages/releases/download/v1.0/artifacts.zip).

The highlights:
- fallback for CPU and OMP;
- regex and prince modes available.

******
The necessary steps to install the package are listed below. They were tested on a clean Fedora 25 docker image, but they should work for every supported distro out there. Don't worry, it can't hurt your Linux environment.

Install and configure flatpak itself:
```
$ dnf install -y flatpak # or 'yum install', 'apt-get install', etc.
$ flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo # add the flatpak itself repository
$ flatpak install gnome org.freedesktop.Platform//1.4 # install the runtime (base "container")
```

Unzip the downloaded file to get the john.flatpak file stored inside it. Now, let's install the software:
```
$ mkdir repo
$ ostree --repo=repo init --mode=archive-z2
$ flatpak build-import-bundle repo john.flatpak
$ flatpak --user remote-add --no-gpg-verify --if-not-exists tutorial-repo repo # not system wide (--user)
$ flatpak --user install tutorial-repo com.openwall.John
```

Run John the Ripper and check if it is working:
```
$ flatpak run com.openwall.John
$ flatpak run com.openwall.John --list=build-info
```
