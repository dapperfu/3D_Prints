.DEFAULT: debug
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

include slic3r_profiles/slice.mk
