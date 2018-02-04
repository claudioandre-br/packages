#!/bin/bash -e

function do_Install_Base_Dependencies(){
    echo
    echo '-- Installing Base Dependencies --'

    if [[ $BASE == "ubuntu" ]]; then
        apt-get update -qq

        # Base dependencies
        apt-get -y -qq install build-essential git clang patch python-dev \
                               autotools-dev autoconf gettext pkgconf autopoint yelp-tools \
                               docbook docbook-xsl libtext-csv-perl \
                               zlib1g-dev \
                               libtool libicu-dev libnspr4-dev \
                               policykit-1 > /dev/null

    elif [[ $BASE == "fedora" ]]; then
        dnf -y -q upgrade

        # Base dependencies
        dnf -y -q install @c-development @development-tools redhat-rpm-config gnome-common python-devel \
                          pygobject2 dbus-python perl-Text-CSV perl-XML-Parser gettext-devel gtk-doc ninja-build \
                          zlib-devel libffi-devel \
                          libtool libicu-devel nspr-devel
    else
        echo
        echo '-- Error: invalid BASE code --'
        exit 1
    fi
}

function do_Install_Dependencies(){
    echo
    echo '-- Installing Dependencies --'

    if [[ $BASE == "ubuntu" ]]; then
        # Testing dependencies
        apt-get -y -qq install libgtk-3-dev gir1.2-gtk-3.0 xvfb gnome-desktop-testing dbus-x11 dbus \
                               libreadline6 libreadline6-dev \
                               iptables iptables-dev libavahi-client-dev libavahi-glib-dev ninja-build > /dev/null

    cat <<EOFILE > /etc/default/keyboard
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
EOFILE

        apt-get -y -qq install libtag1-dev libwavpack-dev libpolkit-agent-1-dev libgbm-dev libnss3-dev \
                               libcaribou-dev libxcb-res0-dev libtasn1-6-dev libxcb-xkb-dev libxklavier-dev \
                               xserver-xorg-input-wacom libcanberra-gtk-dev libgudev-1.0-dev libdbus-glib-1-dev \
                               liblcms2-dev uuid-dev libenchant-dev libflac-dev libsystemd-dev libnl-route-3-dev \
                               libxt-dev libp11-kit-dev xutils-dev libplymouth-dev libusb-1.0-0-dev libpolkit-gobject-1-dev \
                               libxkbfile-dev libv4l-dev libcanberra-gtk3-dev libpulse-dev python3-cairo-dev libvpx-dev \
                               libgnutls28-dev python3-dev libxml2-dev libxslt1-dev libudev-dev libndp-dev libnl-3-dev \
                               libstartup-notification0-dev libnl-genl-3-dev libgles2-mesa-dev libical-dev liboauth-dev \
                               libsqlite3-dev libproxy-dev iso-codes libwebkit2gtk-4.0-dev libcups2-dev desktop-file-utils \
                               valac xmlto doxygen xwayland bison cmake flex argyll intltool ragel gperf ruby libdb5.3-dev \
                               ppp-dev libiw-dev libldap2-dev libtiff5-dev libgcrypt20-dev libjpeg-turbo8-dev libwebp-dev \
                               libhyphen-dev libpam0g-dev > /dev/null

    elif [[ $BASE == "fedora" ]]; then
        # Testing dependencies
        dnf -y -q install gtk3 gtk3-devel gobject-introspection Xvfb gnome-desktop-testing dbus-x11 dbus \
                          cairo intltool libxslt bison nspr zlib python3-devel dbus-glib libicu libffi pcre libxml2 libxslt libtool flex \
                          cairo-devel zlib-devel libffi-devel pcre-devel libxml2-devel libxslt-devel \
                          libedit libedit-devel
    fi
}

function do_Shrink_Image(){
    echo
    echo '-- Cleaning image --'
    jhbuild clean

    if [[ $BASE == "ubuntu" ]]; then
        apt-get -y autoremove
        apt-get -y clean
        rm -rf /var/lib/apt/lists/*

    elif [[ $BASE == "fedora" ]]; then
        dnf -y autoremove
        dnf -y clean all
    fi

    echo '-- Done --'
}

function do_Set_Env(){
    echo
    echo '-- Set Environment --'

    #Save cache on host
    mkdir -p /cwd/.cache
    export XDG_CACHE_HOME=/cwd/.cache

    if [[ -z $DISPLAY ]]; then
        export DISPLAY=":0"
    fi

    echo '-- Done --'
}

function do_Get_JHBuild(){
    echo
    echo '-- Get JHBuild --'

    #Get jhbuild
    rm -rf jhbuild
    git clone --depth 1 https://github.com/GNOME/jhbuild.git

    echo '-- Done --'
}

function do_Patch_JHBuild(){
    echo
    echo '-- Patching JHBuild --'

    # Create and apply a patch
    cd jhbuild
    patch -p1 <<ENDPATCH
diff --git a/jhbuild/main.py b/jhbuild/main.py
index a5cf99b..28c31d6 100644
--- a/jhbuild/main.py
+++ b/jhbuild/main.py
@@ -94,9 +94,9 @@ def main(args):
         localedir = None
     gettext.install('jhbuild', localedir=localedir, unicode=True)
 
-    if hasattr(os, 'getuid') and os.getuid() == 0:
-        sys.stderr.write(_('You should not run jhbuild as root.\n').encode(_encoding, 'replace'))
-        sys.exit(1)
+    # if hasattr(os, 'getuid') and os.getuid() == 0:
+    #    sys.stderr.write(_('You should not run jhbuild as root.\n').encode(_encoding, 'replace'))
+    #    sys.exit(1)
 
     logging.getLogger().setLevel(logging.INFO)
     logging_handler = logging.StreamHandler()
diff --git a/jhbuild/utils/systeminstall.py b/jhbuild/utils/systeminstall.py
index 75b0849..08965fa 100644
--- a/jhbuild/utils/systeminstall.py
+++ b/jhbuild/utils/systeminstall.py
@@ -428,7 +428,7 @@ class AptSystemInstall(SystemInstall):
 
     def _install_packages(self, native_packages):
         logging.info(_('Installing: %(pkgs)s') % {'pkgs': ' '.join(native_packages)})
-        args = self._root_command_prefix_args + ['apt-get', 'install']
+        args = ['apt-get', '-y', 'install']
         args.extend(native_packages)
         subprocess.check_call(args)
ENDPATCH

    echo '-- Done --'
    cd -
}

function do_Build_JHBuild(){
    echo
    echo '-- Building JHBuild --'

    # Build JHBuild
    cd jhbuild
    git log --pretty=format:"%h %cd %s" -1
    echo
    ./autogen.sh
    make -sj2
    make install
    PATH=$PATH:~/.local/bin

    if [[ $1 == "RESET" ]]; then
        git reset --hard HEAD
    fi

    echo '-- Done --'
}

function do_Build_Mozilla(){
    echo
    echo '-- Building Mozilla SpiderMonkey --'

    # Build Mozilla Stuff
    if [[ -n "$SHELL" ]]; then
        export SHELL=/bin/bash
    fi

    #TODO Fix this upstream
    jhbuild update mozjs38
    touch ~/jhbuild/checkout/mozjs-38.0.0/js/src/configure
    jhbuild build mozjs38
}

function do_Build_Package(){
    echo
    echo "-- Building $1 --"
    jhbuild list $1

    # Build package dependencies
    if [[ $BASE == "ubuntu" ]]; then
        jhbuild sysdeps --install $1
    fi
    jhbuild build $1
}

function do_Show_Compiler(){

    if [[ ! -z $CC ]]; then
        echo
        echo '-- Compiler in use --'
        $CC --version
    fi
}

# Show some environment info
echo
echo '-- Environment --'
echo "Running on: $BASE $OS"
echo "Doing: $TYPE"

if [[ $TYPE == "GJS" ]]; then
    #Create the needed docker image
    do_Install_Base_Dependencies
    do_Install_Dependencies
    do_Set_Env

    do_Show_Compiler

    do_Get_JHBuild
    do_Patch_JHBuild
    do_Build_JHBuild

    do_Build_Mozilla
    do_Build_Package gjs

    do_Shrink_Image

elif [[ $TYPE == "GTK" ]]; then
    #Create the needed docker image
    do_Install_Base_Dependencies
    do_Install_Dependencies
    do_Set_Env

    do_Show_Compiler

    do_Get_JHBuild
    do_Patch_JHBuild
    do_Build_JHBuild

    do_Build_Package gtk+-3

    do_Shrink_Image
fi

# Done
echo
echo '-- DONE --'

