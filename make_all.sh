#!/usr/bin/env bash

# Generate g-code for a full permutation of profile settings.

# List all of the print profiles.
for PRINT_ in $(ls slic3r_profiles/print/*)
do

# List all of the printer profiles.
for PRINTER_ in $(ls slic3r_profiles/printer/*)
do

# List all of the filament profiles
for FILAMENT_ in $(ls slic3r_profiles/filament/*)
do
export PRINT=$(basename $PRINT_)
export PRINTER=$(basename $PRINTER_)
export FILAMENT=$(basename $FILAMENT_)

# Run make with the given profiles.
#TODO: benchmark and see which way is faster.
THREADS=1 make -j8

done
done
done
