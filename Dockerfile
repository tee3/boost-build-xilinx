# Copyright 2019 Thomas Brown
# Distributed under the Boost Software License, Version 1.0. (See
# accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

FROM docker.inradar.net/ubuntu-20.04-boost:0.2.0

RUN apt-get -y update && apt-get -y install \
    libidn11 \
    xvfb
