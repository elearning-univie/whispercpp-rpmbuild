RPMBUILD_DIR := /build/rpmbuild

build: rpm

rpm:
	@echo Build ffmpeg rpm
	mkdir -p $(RPMBUILD_DIR)
	cp -R {BUILD,BUILDROOT,SOURCES,SPECS,RPMS,SRPMS} $(RPMBUILD_DIR)/
	cp -R ../ffmpeg_bin $(RPMBUILD_DIR)/
	cp -R ../ffmpeg_build $(RPMBUILD_DIR)/
	cd $(RPMBUILD_DIR)
	rpmbuild \
		--define '_topdir $(RPMBUILD_DIR)' \
		--nodebuginfo \
		-ba SPECS/ffmpeg.spec