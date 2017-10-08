# slic3r profiles to use.
FILAMENT ?= temp_250
PRINT ?= fine3_2
PRINTER ?= cr10

# Find all STL files.
# STL ?= $(wildcard */*.stl)
# Search deeper than with just wildcard.
STL ?= $(shell find . -name "*.stl" | sort)

# Setup a directory structure for the output gcode.
GPREFIX := build/${PRINTER}/
# Add suffix to base .stl
GSUFFIX := -${PRINTER}-${FILAMENT}-${PRINT}

# Determine the gcode files to make.
GCODE := $(patsubst %.stl,${GPREFIX}%${GSUFFIX}.gcode,${STL})

# Default to building the stl files.
.DEFAULT: all
.PHONY: all
all: ${GCODE}

# Slice the STL files into G-code
${GPREFIX}%${GSUFFIX}.gcode: %.stl
	@mkdir -p ${dir ${@}}
	@echo Slicing: ${<}
	@slic3r --print-center=150,150 \
	  --load=slic3r_profiles/filament/${FILAMENT} \
	  --load=slic3r_profiles/print/${PRINT} \
	  --load=slic3r_profiles/printer/${PRINTER} \
	  --output=${@} \
	  ${<}

# Update slicer profiles.

#	git submodule init
#	git submodule update

# Clean up the g-code.
.PHONY: clean
clean:
	git clean -fdn
