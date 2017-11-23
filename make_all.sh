#!/usr/bin/env bash

for PRINT_ in $(ls slic3r_profiles/print/*)
do

for PRINTER_ in $(ls slic3r_profiles/printer/*)
do

for FILAMENT_ in $(ls slic3r_profiles/filament/*)
do
export PRINT=$(basename $PRINT_)
export PRINTER=$(basename $PRINTER_)
export FILAMENT=$(basename $FILAMENT_)

THREADS=1 make -j8

done
done
done
