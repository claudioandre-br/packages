######################################################################
# Copyright (c) 2019 Claudio André <claudioandre.br at gmail.com>
#
# This program comes with ABSOLUTELY NO WARRANTY; express or implied.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, as expressed in version 2, seen at
# http://www.gnu.org/licenses/gpl-2.0.html
######################################################################

FROM arm64v8/fedora:rawhide
MAINTAINER Claudio André (c) 2018 V1.0

LABEL architecture="aarch64"
LABEL version="1.0"
LABEL description="Multiarch docker image to run CI for GNOME GJS."

ADD x86_64_qemu-aarch64-static.tar.gz /usr/bin

CMD ["/bin/bash"]

