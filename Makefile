# slic3r settings to use.
FILAMENT ?= temp_250
PRINT ?= fine3_2
PRINTER ?= cr10

# Find all STL files.
STL ?= $(wildcard */*.stl)
# Generate GCode
GSUFFIX ?= _${PRINTER}-${PRINT}-${FILAMENT}

GCODE := $(patsubst %.stl,${GPREFIX}%${GSUFFIX}.gcode,${STL})
# Default to building the stl files.
.DEFAULT: all
.PHONY: all
all: ${GCODE}
	@echo ${GCODE}

.PHONY: stl
stl: ${STL}

${GPREFIX}%${GSUFFIX}.gcode: %.stl
	slic3r --print-center=150,150 \
	    --load=../slic3r_profiles/filament/${FILAMENT} \
	    --load=../slic3r_profiles/print/${PRINT} \
	    --load=../slic3r_profiles/printer/${PRINTER} \
	    --output=${@} \
	    ${<}

.PHONY: clean
clean:
	rm -rf ${GCODE}
