
$(eval $(call project-define,ply))

$(PLY_ANDROID):
	cd $(PLY_ANDROID_BUILD_DIR) && make -j $(THREADS)
	cd $(PLY_ANDROID_BUILD_DIR) && make install
	touch $@

$(PLY_ANDROID_BUILD_DIR): $(ANDROID_CONFIG_SITE)
	cd $(PLY_SRCS) && ./autogen.sh
	-mkdir $@
	cd $@ && $(PLY_SRCS)/configure -v $(ANDROID_EXTRA_CONFIGURE_FLAGS) 

PLY_COMMIT_HASH = fe80ec121676e4ab0e0750ca7888fe5877a73206
PLY_REPO = git@github.com:dodola/ply-android.git

projects/ply/sources:
	git clone $(PLY_REPO) $@
	cd $@ && git checkout $(PLY_COMMIT_HASH)
	cd $@ && ./autogen.sh