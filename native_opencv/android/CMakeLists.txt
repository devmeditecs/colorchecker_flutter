cmake_minimum_required(VERSION 3.10.2)

# opencv
set(OpenCV_STATIC ON)
set(OpenCV_DIR $ENV{OPENCV_ANDROID}/sdk/native/jni)
find_package (OpenCV REQUIRED)

# Colorlib
add_library(colorlib STATIC IMPORTED)
set_target_properties(colorlib PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/colorlib/libs/${ANDROID_ABI}/libcolorlib.a)
include_directories(${CMAKE_SOURCE_DIR}/colorlib/include)
include_directories(${CMAKE_SOURCE_DIR}/colorlib/libs/${ANDROID_ABI}/include)

add_library( # Sets the name of the library.
    native_opencv
    SHARED
    # Provides a relative path to your source file(s).
    ../ios/Classes/native_opencv.cpp

#    ../ios/Classes/colorlib/mcc/bound_min.cpp
#    ../ios/Classes/colorlib/mcc/ccm.cpp
#    ../ios/Classes/colorlib/mcc/charts.cpp
#    ../ios/Classes/colorlib/mcc/checker_detector.cpp
#    ../ios/Classes/colorlib/mcc/checker_model.cpp
#    ../ios/Classes/colorlib/mcc/color.cpp
#    ../ios/Classes/colorlib/mcc/colorspace.cpp
#    ../ios/Classes/colorlib/mcc/common.cpp
#    ../ios/Classes/colorlib/mcc/debug.cpp
#    ../ios/Classes/colorlib/mcc/distance.cpp
#    ../ios/Classes/colorlib/mcc/graph_cluster.cpp
#    ../ios/Classes/colorlib/mcc/io.cpp
#    ../ios/Classes/colorlib/mcc/linearize.cpp
#    ../ios/Classes/colorlib/mcc/mcc.cpp
#    ../ios/Classes/colorlib/mcc/operations.cpp
#    ../ios/Classes/colorlib/mcc/utils.cpp
#    ../ios/Classes/colorlib/mcc/wiener_filter.cpp
)

target_include_directories(
    native_opencv PRIVATE
    ../ios/Classes/colorlib
)

find_library(log-lib log)

target_link_libraries( # Specifies the target library.
    native_opencv
    colorlib
    ${OpenCV_LIBS}
    ${log-lib}
)
