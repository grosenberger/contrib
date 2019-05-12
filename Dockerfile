FROM ubuntu:18.04

# install base dependencies
RUN apt-get -y update
RUN apt-get install -y cmake g++ autoconf qt5-default libqt5svg5-dev patch libtool make git software-properties-common libsvm-dev libglpk-dev libzip-dev zlib1g-dev libxerces-c-dev libbz2-dev libboost-all-dev libsqlite3-dev libeigen3-dev libwildmagic-dev seqan-dev coinor-libcoinmp-dev libhdf5-dev

# build contrib
ADD . /code/contrib
WORKDIR /code/contrib
RUN cmake -DBUILD_TYPE=KISSFFT

# build Percolator
WORKDIR /code
RUN git clone https://github.com/percolator/percolator.git
RUN mkdir percolator_build

WORKDIR /code/percolator_build

RUN cmake -DCMAKE_PREFIX_PATH="/usr/;/usr/local" ../percolator
RUN make && make install
