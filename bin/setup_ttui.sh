#!/usr/bin/env bash

wget http://www.catb.org/~esr/terminfo/termtypes.tc.gz -O termtypes.tc.gz
gunzip termtypes.tc.gz

mumps -r %TCS
mumps -r %TCC
