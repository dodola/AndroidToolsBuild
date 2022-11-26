# AndroidToolsBuild

Fork form ExtendedAndroidTools https://github.com/facebookexperimental/ExtendedAndroidTools 


# Usage

## Download NDK 
```
git clone git@github.com:dodola/AndroidToolsBuild.git
cd AndroidToolsBuild
./scripts/download-ndk.sh
```

## Make

```
make ply
```

## Add New Project

Majority of cross-compiled projects use a build files generation tool like
autotools or cmake. To build them one needs to first generate a build
directory and then invoke make or other build system from that directory.
Some of the projects need to be compiled for Android, some for the host
platform and some for both. For those reasons build.mk files under projects/*/
define the following build targets:
- host build directory
- host build rule
- android build directory
- android build rule

By convention android and host build directories for project `myproject` are
`$(ANDROID_BUILD_DIR)/myproject` and `$(HOST_BUILD_DIR)/myproject`
respectively. Corresponding build rules are
`$(ANDROID_BUILD_DIR)/myproject.done` and `$(HOST_BUILD_DIR)/myproject.done`.
Build rules write built artifacts to `$(ANDROID_OUT_DIR)` and `$(HOST_OUT_DIR)`
and artificial `*.done` files are used only to track successfull runs of the
compilation step.

project-define macro defined in this file helps set up build targets by
computing their names and setting up dependencies between them.
  `$(eval $(call project-define,myproject))`
generates the following variables:
- `MYPROJECT_ANDROID`: android build target generating myproject.done file
  after successful compilation of myproject for Android
- `MYPROJECT_ANDROID_BUILD_DIR`: build directory to be used by android build
  rule
- `MYPROJECT_HOST`: host build target generating myproject.done file after
  successful compilation of myproject for the host platform
- `MYPROJECT_HOST_BUILD_DIR`: build directory to be used by the host build
  target
Additionally the call makes the android/host build rule dependent on the
corresponding build directory.

 Intended usage of project-define is shown below:

 ```
    $(eval $(call project-define,myproject))

    $(MYPROJECT_ANDROID):
    	cd $(MYPROJECT_ANDROID_BUILD_DIR) && make ...
    	touch $@

    $(MYPROJECT_ANDROID_BUILD_DIR):
    	dir $@
    	cd $@ && $(CMAKE) ...
    	cd &@ && ./configure ...

    $(MYPROJECT_HOST):
    	cd $(MYPROJECT_HOST_BUILD_DIR) && make ...
    	touch $@

    $(MYPROJECT_HOST_BUILD_DIR):
    	mkdir $@
    	cd $@ && $(CMAKE) ...
    	cd &@ && ./configure ...

    projects/myproject/sources:
    	git clone ...
```

See project-define and `projects/ply/build.mk` to see the details and actual example of usage.