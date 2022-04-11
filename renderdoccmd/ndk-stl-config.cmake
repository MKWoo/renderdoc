# Copy shared STL files to Android Studio output directory so they can be
# packaged in the APK.
# Usage:
#
#   find_package(ndk-stl REQUIRED)
#
# or
#
#   find_package(ndk-stl REQUIRED PATHS ".")
message("minkeewu  ---------------------------------")

message("---------------------------------  ANDROID_STL:${ANDROID_STL} ")
if(NOT ${ANDROID_STL} MATCHES "_shared")
  message("---------------------------------not  ANDROID_STL:${ANDROID_STL} ")
  return()
endif()

function(configure_shared_stl lib_path so_base)
  message("Configuring STL ${so_base} for ${ANDROID_ABI}.   mubiao:${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${so_base}.so")
  configure_file(
    "${ANDROID_NDK}/sources/cxx-stl/${lib_path}/libs/${ANDROID_ABI}/lib${so_base}.so" 
    "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${so_base}.so" 
    COPYONLY)
	
  configure_file(
    "${ANDROID_NDK}/sources/cxx-stl/${lib_path}/libs/${ANDROID_ABI}/lib${so_base}.so" 
    "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/renderdoccmd/libs/lib/${so_base}.so" 
    COPYONLY)
	
endfunction()

if("${ANDROID_STL}" STREQUAL "libstdc++")
  # The default minimal system C++ runtime library.
elseif("${ANDROID_STL}" STREQUAL "gabi++_shared")
  # The GAbi++ runtime (shared).
  message(FATAL_ERROR "gabi++_shared was not configured by ndk-stl package")
elseif("${ANDROID_STL}" STREQUAL "stlport_shared")
  # The STLport runtime (shared).
  configure_shared_stl("stlport" "stlport_shared")
elseif("${ANDROID_STL}" STREQUAL "gnustl_shared")
  # The GNU STL (shared).
  configure_shared_stl("gnu-libstdc++/4.9" "gnustl_shared")
elseif("${ANDROID_STL}" STREQUAL "c++_shared")
  # The LLVM libc++ runtime (static).
  message("minkeewu  configure_shared_stl")
  configure_shared_stl("llvm-libc++" "c++_shared")
else()
   message(FATAL_ERROR "STL configuration ANDROID_STL=${ANDROID_STL} is not supported")
endif()
