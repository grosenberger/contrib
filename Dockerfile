FROM ubuntu:18.04

# install base dependencies
RUN apt-get -y update
RUN apt-get install -y cmake g++ autoconf qt5-default libqt5svg5-dev patch libtool make git software-properties-common libsvm-dev libglpk-dev libzip-dev zlib1g-dev libxerces-c-dev libbz2-dev libboost-all-dev libsqlite3-dev libeigen3-dev libwildmagic-dev seqan-dev coinor-libcoinmp-dev libhdf5-dev

# build contrib
ADD . /contrib
WORKDIR /contrib
RUN cmake -DBUILD_TYPE=KISSFFT
