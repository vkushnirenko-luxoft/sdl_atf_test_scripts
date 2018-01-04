#!/usr/bin/env sh
# Copyright (c) 2016 Ford Motor Company,
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of Ford Motor Company nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Vars
os=`lsb_release -c | awk '{print $2}'`
if [ $os = xenial ];
  then qtrepo=ppa:beineri/opt-qt593-xenial;
       qt5base=qt59base
       qt5websockets=qt59websockets
elif [ $os = trusty ];
  then qtrepo=ppa:beineri/opt-qt532-trusty;
       qt5base=qt53base
       qt5websockets=qt53websockets
fi

export LC_ALL=C

# Repository for Qt 5.3 (ubuntu14)
#                Qt 5.9 (ubuntu16)
sudo add-apt-repository --yes $qtrepo
sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/test
sudo apt-get update


# SDL build dependencies
sudo apt-get -q -y install cmake gcc-4.9 g++-4.9 libssl-dev libbluetooth3 libbluetooth-dev libudev-dev libavahi-client-dev bluez-tools sqlite3 libsqlite3-dev automake1.11 libexpat1-dev

# ATF build dependencies
sudo apt-get -q -y install $qt5base $qt5websockets liblua5.2-dev libxml2-dev lua-lpeg-dev libgl1-mesa-dev

# sdl_atf_scripts dependencies
sudo apt-get -q -y install python2.7 python-pip python-flake8  openssh-server
sudo pip install fabric  #errors

# Some scripts require managing system network
# So it should be possible to run ifconfig from user
sudo chmod 4755 /sbin/ifconfig
