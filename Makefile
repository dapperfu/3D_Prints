VENV ?= .venv

.DEFAULT: all
.PHONY: all
all: gcode

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
	@git clean -xfd


.PHONY: venv
venv: ${VENV}

${VENV}: requirements.txt
	@python3 -mvenv ${@}
	@${VENV}/bin/pip install --upgrade pip
	@${VENV}/bin/pip install --upgrade setuptools wheel
	@${VENV}/bin/pip install --upgrade --requirement requirements.txt

requirements.txt:
	@echo ${@} is missing.

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

include slic3r_profiles/slice.mk
