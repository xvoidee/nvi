#/bin/bash

# $1 true to probe (=skip install)
# $2 pre-installed path
# $3 binary name
# $4 relative path
# $5 clang path
# $6 target directory
probe_or_install_ccls() {
	if ( $1 ) ; then
		probe_binary $2 $3 $4
		#ccls_path=""
	else
		download_and_extract \
			"temp" \
			"https://github.com/Kitware/CMake/releases/download/v3.14.2" \
			"$archive_cmake" \
			"cmake"
		cmake_command="`pwd`/temp/cmake/bin/cmake"

		cd temp
#		git clone --depth=1 --recursive https://github.com/MaskRay/ccls
		cd ccls

		echo $5/bin/clang++
		exit 0

		eval $cmake_command -H. -BRelease \
			-DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_PREFIX_PATH=$5 \
			-DCMAKE_CXX_COMPILER=$5/bin/clang++
		eval $cmake_command --build Release -j 4
		mkdir $6/ccls
		mkdir $6/ccls/bin
		cp Release/ccls $6/ccls/bin
		cd ../..
#		rm -rf temp/ccls
		rm -rf temp/cmake

		#ccls_path="$thirdparty_path/ccls"
	fi
}

