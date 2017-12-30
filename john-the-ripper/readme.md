# John the Ripper

> John the Ripper password cracker

[Openwall](http://openwall.com/) John the Ripper (JtR) is a fast password cracker, currently available for many flavors of Unix, Windows, DOS, and OpenVMS. Its primary purpose is to detect weak Unix passwords. Besides several crypt(3) password hash types most commonly found on various Unix systems, supported out of the box are Windows LM hashes, plus lots of other hashes and ciphers.

## Snap
> Built and deployed using Launchpad

[**A Snap**](http://snapcraft.io/) is a fancy zip file containing an application together with its dependencies, and a description of how it should safely be run on your system.

To install from the Snap Store, do:
```
$ sudo snap install john-the-ripper
$ sudo snap connect john-the-ripper:process-control core:process-control
```

You can also download the package from [**uAppExplorer**](https://uappexplorer.com/snap/ubuntu/john-the-ripper). In all cases, the package is hosted and reviewed (automatically) by Ubuntu. Using the second option, the installation can be done using:

```
$ sudo snap install *.snap
$ sudo snap connect john-the-ripper:process-control core:process-control
```

John run confined under a restrictive security sandbox by default. Nevertheless, you can access and audit any file located in your home. Below, an usage example:
```
$ john-the-ripper -list=build-info
$ john-the-ripper -list=format-tests | cut -f3 > ~/alltests.in
$ john-the-ripper -form=SHA512crypt ~/alltests.in
```

The highlights:
- fallback for CPU[1] and OMP;
- regex and prince modes available;
- available for X86_64, armhf, arm64 and ppc64.
- you can also run it using the alias **john**, e.g. `john -list=build-info`.

[1] John the Ripper runs using the best SIMD instructions available on the host it's running on.

### Running a non-OpenMP build
In some situations a non-OpenMP build may be faster. You can ask to fallback to a non-OpenMP build specifying `OMP_NUM_THREADS=1 john <options>` in the command line. You avail the best SIMD instructions at one's disposal without any OpenMP stuff. E.g.:
```
OMP_NUM_THREADS=1 john --list=build-info
```

### Enabling Aliases
You are free to pick and set up aliases. To enable the usage of aliases with John the Ripper snap, run `sudo snap alias john-the-ripper <alias>`. For example:
```
$ sudo snap alias john-the-ripper my-john
$ sudo snap alias john-the-ripper.dmg2john dmg2john
$ sudo snap alias john-the-ripper.hccap2john hccap2john
$ sudo snap alias john-the-ripper.racf2john racf2john
$ sudo snap alias john-the-ripper.vncpcap2john vncpcap2john
$ sudo snap alias john-the-ripper.zip2john zip2john
$ sudo snap alias john-the-ripper.gpg2john gpg2john
$ sudo snap alias john-the-ripper.keepass2john keepass2john
$ sudo snap alias john-the-ripper.putty2john putty2john
$ sudo snap alias john-the-ripper.rar2john rar2john
$ sudo snap alias john-the-ripper.uaf2john uaf2john
$ sudo snap alias john-the-ripper.wpapcap2john wpapcap2john

```

Once enabled, John itself plus the *2john tools can be invoked using the aliases. In the example, to run John type `my-john`.

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

If you do so, you will be running the development version available on GitHub. The average gap expected is 1 week.

## Flatpak
> Built and deployed using GitLab CI

[**Flatpak**](http://flatpak.org//) is a new framework for desktop applications on Linux, built to be distribution agnostic and allow deployment on any Linux operating system out there.

Flatpak is available for the [most common Linux distributions](http://flatpak.org/getting.html).

John the Ripper single-file flatpak bundle was built and tested on [GitLab](https://gitlab.com/claudioandre/packages/pipelines). You can get it [here](https://gitlab.com/claudioandre/packages/-/jobs/46252686/artifacts/download).

The highlights:
- fallback for CPU[2] and OMP;
- regex and prince modes available.

[2] John the Ripper runs using the best SIMD instructions available on the host it's running on.

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

## Windows
> Built and deployed using AppVeyor CI

To install John the Ripper by downloading the .zip file and installing manually, follow these steps:

* Try to find out if your computer is running a 32-bit or 64-bit version of Windows. See also [this](https://support.microsoft.com/en-us/help/827218/how-to-determine-whether-a-computer-is-running-a-32-bit-version-or-64).
* Click the link of the 32-bit or 64-bit .zip to download the appropriate file to your machine.
* Also, download the required 32-bit or 64-bit libraries (this has to be done only once).
* Navigate to where you downloaded the files and double click the compressed file [1].
* Extract the John .zip file to a directory such as `C:\john-the-ripper`.
* Extract the libraries to the subfolder named `run` inside the same directory you picked above. 
  * In the example it will be, `C:\john-the-ripper\run`.
* Start a command prompt.
* Navigate to the directory you extracted the .zip file, e.g., `cd C:\john-the-ripper\run`.
* Run JtR:
```
john --list=build-info
john --test --format=SHA512crypt
```

The links below contains all the executables and libraries needed to run a fresh John the Ripper installation.
- [32-bit version](https://ci.appveyor.com/project/claudioandre/johntheripper/build/1.8J1-1bbe5cf46/job/cjy4a8rc93w524ic/artifacts)
- [64-bit version](https://ci.appveyor.com/project/claudioandre/johntheripper/build/1.8J1-1bbe5cf46/job/y5wrmbfave2btxj0/artifacts)

#### File hashes computed by the CI server
```
Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
SHA256          8D33178EF8802BF83E9A1CC92C12EB721AFA08BF04EB97BF084A9230649B7BFD       C:\projects\johntheripper\run\win_x64.zip
SHA256          A9987FDE847C13E9576606F7885F005A8358E8211F2FC00CC9DCADA7B6EF0ADF       C:\projects\johntheripper\run\win_x32.zip
```

**[1] Note:** This step assumes you already have a recent version of WinZip installed, and that you know how to use it. If not, you can get WinZip and information about the program at www.winzip.com.
