#!/bin/bash

# Run this script in the directory you want to clone the relion repo
# Check the brew installed gcc version and edit ENV flags accordingly
# Check path to openMPI and edit ENV flags accordingly
# Edit cmake line with favourite DCMAKE flags, but since this is going 
# to be installed on a Mac, it shouldnt matter too much.
# Instructions obtained from 
# https://blogs.urz.uni-halle.de/kastritislab/2019/06/installation-of-relion-3-on-our-macos/
# and modified by Pranav NM Shah 29.10.2021

VERSION=$1
INSTALLDIR=`realpath ${VERSION}`

export CXX=g++-11
export CC=gcc-11
export OMPI_CXX=g++-11
export OMPI_CC=gcc-11
export CXXFLAGS="-I/opt/homebrew/opt/openmpi/include"
export LDFLAGS="-L/opt/homebrew/opt/openmpi/lib"

git clone https://github.com/3dem/relion.git
cd relion
git pull
git checkout ver$VERSION

cd build
rm -rvf ./*
cmake -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} ../
make -j 8
make install
