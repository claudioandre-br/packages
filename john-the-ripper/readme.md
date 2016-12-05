# John the Ripper

> John the Ripper password cracker

[Openwall](http://openwall.com/) John the Ripper is a fast password cracker, currently available for many flavors of Unix, Windows, DOS, and OpenVMS. Its primary purpose is to detect weak Unix passwords. Besides several crypt(3) password hash types most commonly found on various Unix systems, supported out of the box are Windows LM hashes, plus lots of other hashes and ciphers in this community-enhanced version.

### Snap

[**A Snap**](http://snapcraft.io/) is a fancy zip file containing an application together with its dependencies, and a description of how it should safely be run on your system.

If you are using Ubuntu (or if your distro already has a Snap Store), do:
```
$ sudo snap install john-the-ripper
```

To test it, do:
```
$ john-the-ripper --list=build-info
```

If you distro do not offer a Store, you can download the package from [**uAppExplorer**](https://uappexplorer.com/app/john-the-ripper.claudioandre-br). In all cases, packages are hosted and reviewed (automatically) by Ubuntu. The instalation can be done using:

```
$ sudo snap install *.snap
```

John run confined under a restrictive security sandbox by default. Nevertheless, you can access and audit any file located in your home. Below, an example:
```
$ john-the-ripper -list=format-tests | cut -f3 > ~/alltests.in
$ john-the-ripper -form=SHA512crypt ~/alltests.in
```

The highlights:
- fallback for CPU and OMP.
- regex and prince modes available.

