# slic3r profiles to use.
FILAMENT ?= temp_250
PRINT ?= fine3_2
PRINTER ?= cr10

# Find all STL files.
# STL ?= $(wildcard */*.stl)
# Search deeper than with just wildcard.
STL ?= $(shell find . -name "*.stl" | sort)

# Setup a directory structure for the output gcode.
GPREFIX := ${PRINTER/${FILAMENT}_${PRINT}/
# Add suffix to base .stl
GSUFFIX := -${PRINTER}-${FILAMENT}-${PRINT}

GCODE := $(patsubst %.stl,${GPREFIX}%${GSUFFIX}.gcode,$(STL))

# Default to building the stl files.
.DEFAULT: all
.PHONY: all
all: ${GCODE}
	@echo $<

${GPREFIX}%${GSUFFIX}.gcode: %.stl
	@echo ${<} -> ${@}
	@mkdir -p ${dir ${@}}
	@slic3r --print-center=150,150 \
	  --load=slic3r_profiles/filament/${FILAMENT} \
	  --load=slic3r_profiles/print/${PRINT} \
	  --load=slic3r_profiles/printer/${PRINTER} \
	  --output=${@} \
	  ${<}

slic3r_profiles:
	git submodule init
	git submodule update

.PHONY: clean
clean:
	rm -rf ${GCODE}
