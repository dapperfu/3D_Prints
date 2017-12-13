# Default slic3r profiles to use.
FILAMENT ?= temp_H250-240_B70-40
PRINT ?= fine3_2
PRINTER ?= CR10_0.4mm

# Additional slic3r override options.
# Eg: `OPTIONS=--first-layer-speed=10 make`
OPTIONS ?=

# Where to center the print.
PRINT_CENTER ?= 50,50

# Number of threads to use in slic3r
THREADS ?= $(shell grep -c ^processor /proc/cpuinfo)

# Find all STL files if none specified.
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

	@slic3r --print-center=${PRINT_CENTER} \
	  --threads=${THREADS} \
	  --load=slic3r_profiles/filament/${FILAMENT} \
	  --load=slic3r_profiles/print/${PRINT} \
	  --load=slic3r_profiles/printer/${PRINTER} \
	  --output=${@} \
	  ${OPTIONS} \
	  ${<}

# Update slicer profiles.
.PHONY: update
update:
	git submodule init slic3r_profiles/
	git submodule update --remote --merge
	git add slic3r_profiles
	git commit -m "Updated submodules."

# Clean up the g-code.
.PHONY: clean
clean:
	git clean -fdn

.PHONY: debian
debian:
	sudo apt-get install slic3r git

.PHONY: debug
debug:
	$(info $$FILAMENT is [${FILAMENT}])
	$(info $$PRINT is [${PRINT}])
	$(info $$PRINTER is [${PRINTER}])
	$(info $$OPTIONS is [${OPTIONS}])
	$(info $$THREADS is [${THREADS}])
	$(info $$STL is [${STL}])
	@echo
