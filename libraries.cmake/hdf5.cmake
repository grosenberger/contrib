##################################################
###       HDF5                                 ###
##################################################
MACRO( OPENMS_CONTRIB_BUILD_HDF5 )
  OPENMS_LOGHEADER_LIBRARY("HDF5")
  #extract: (takes very long.. so skip if possible)
  if(MSVC)
    set(ZIP_ARGS "x -y -osrc")
  else()
    set(ZIP_ARGS "xzf")
  endif(MSVC)
  OPENMS_SMARTEXTRACT(ZIP_ARGS ARCHIVE_HDF5 "HDF5" "INSTALL")

  message( STATUS "Building HDF5 library in  ${HDF5_DIR}")

  # we want out-of-source builds
  set(_HDF5_BUILD_DIR "${HDF5_DIR}/build")
  file(TO_NATIVE_PATH "${_HDF5_BUILD_DIR}" _HDF5_NATIVE_BUILD_DIR)

  if(APPLE)
    set( _HDF5_CMAKE_ARGS
        "-D CMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}"
        "-D CMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}"
        "-D CMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}"
    )
  else()
    set( _HDF5_CMAKE_ARGS "")
  endif()

  execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${_HDF5_NATIVE_BUILD_DIR})

  message(STATUS "Generating HDF5 build system .. in ${_HDF5_NATIVE_BUILD_DIR}")
  message(STATUS "Generating HDF5 build system .. ")
  execute_process(COMMAND ${CMAKE_COMMAND}
                        -G "${CMAKE_GENERATOR}"
                        -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBRARIES}
                        -D CMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
                        ${_HDF5_CMAKE_ARGS}
                        ${HDF5_DIR}
                        WORKING_DIRECTORY ${_HDF5_NATIVE_BUILD_DIR}
                        OUTPUT_VARIABLE _HDF5_CMAKE_OUT
                        ERROR_VARIABLE _HDF5_CMAKE_ERR
                        RESULT_VARIABLE _HDF5_CMAKE_SUCCESS)

  # output to logfile
  file(APPEND ${LOGFILE} ${_HDF5_CMAKE_OUT})
  file(APPEND ${LOGFILE} ${_HDF5_CMAKE_ERR})

  if (NOT _HDF5_CMAKE_SUCCESS EQUAL 0)
    message(FATAL_ERROR "Generating HDF5 build system .. failed")
  else()
    message(STATUS "Generating HDF5 build system .. done")
  endif()


  # the install target on windows has a different name then on mac/lnx
  if(MSVC)
    set(_HDF5_INSTALL_TARGET "INSTALL")
  else()
    set(_HDF5_INSTALL_TARGET "install")
  endif()

  # build release first
  message(STATUS "Building HDF5 library (Release) .. ")
  execute_process(COMMAND ${CMAKE_COMMAND} --build ${_HDF5_NATIVE_BUILD_DIR} --target ${_HDF5_INSTALL_TARGET} --config Release
                          WORKING_DIRECTORY ${_HDF5_NATIVE_BUILD_DIR}
                          OUTPUT_VARIABLE _HDF5_BUILD_OUT
                          ERROR_VARIABLE _HDF5_BUILD_ERR
                          RESULT_VARIABLE _HDF5_BUILD_SUCCESS)

  # output to logfile
  file(APPEND ${LOGFILE} ${_HDF5_BUILD_OUT})
  file(APPEND ${LOGFILE} ${_HDF5_BUILD_ERR})

  if (NOT _HDF5_BUILD_SUCCESS EQUAL 0)
    message(FATAL_ERROR "Building HDF5 library (Release) .. failed")
  else()
    message(STATUS "Building HDF5 library (Release) .. done")
  endif()

ENDMACRO( OPENMS_CONTRIB_BUILD_HDF5 )


###### MACRO( OPENMS_CONTRIB_BUILD_HDF5 )
######   OPENMS_LOGHEADER_LIBRARY("HDF5")
######   #extract: (takes very long.. so skip if possible)
######   if(MSVC)
######     set(ZIP_ARGS "x -y -osrc")
######   else()
######     set(ZIP_ARGS "xzf")
######   endif(MSVC)
######   OPENMS_SMARTEXTRACT(ZIP_ARGS ARCHIVE_HDF5 "HDF5" "INSTALL")
###### 
######   message( STATUS "Building HDF5 library in  ${HDF5_DIR}")
###### 
######   if(MSVC)
######     
######     #### TODO
######     #### if (${BUILD_SHARED_LIBRARIES})
######     ####     # there is a Makefile.am, but it uses (broken) .def export instead of just a simple call to cl. So we just use:
######     ####     execute_process(COMMAND "cl" "sqlite3.c" "-DSQLITE_API=__declspec(dllexport)" "-link" "-dll" "-out:sqlite3.dll"
######     ####                    WORKING_DIRECTORY "${HDF5_DIR}"
######     ####                    RESULT_VARIABLE _SQLITE_RES
######     ####                    OUTPUT_VARIABLE _SQLITE_OUT
######     ####                    ERROR_VARIABLE _SQLITE_ERR
######     ####                    )
######     ####                    
######     #### else()
######     ####     execute_process(COMMAND "cl" "/c" "sqlite3.c"
######     ####                     WORKING_DIRECTORY "${HDF5_DIR}"
######     ####                     RESULT_VARIABLE _SQLITE_RES
######     ####                     OUTPUT_VARIABLE _SQLITE_OUT
######     ####                     ERROR_VARIABLE _SQLITE_ERR
######     ####                     )
######     ####     execute_process(COMMAND "lib" "sqlite3.obj"
######     ####                     WORKING_DIRECTORY "${HDF5_DIR}"
######     ####                     RESULT_VARIABLE _SQLITE_RES
######     ####                     OUTPUT_VARIABLE _SQLITE_OUT
######     ####                     ERROR_VARIABLE _SQLITE_ERR
######     ####                     )
######     #### endif()
######     #### 
######     #### if (NOT _SQLITE_RES EQUAL 0)
######     ####   message( STATUS "Building sqlite failed")
######     ####   file(APPEND ${LOGFILE} "sqlite failed" )
######     ####   message( FATAL_ERROR ${_SQLITE_OUT})
######     #### else()
######     ####   message( STATUS "Building sqlite worked")
######     ####   file(APPEND ${LOGFILE} "sqlite worked" )
######     #### endif()
######     #### 
######     #### file(APPEND ${LOGFILE} ${_SQLITE_ERR})
######     #### file(APPEND ${LOGFILE} ${_SQLITE_OUT})
######     #### 
######     #### configure_file(${HDF5_DIR}/sqlite3.h ${PROJECT_BINARY_DIR}/include/sqlite/sqlite3.h COPYONLY)
######     #### if(${BUILD_SHARED_LIBRARIES})
######     #### configure_file(${HDF5_DIR}/sqlite3.dll ${PROJECT_BINARY_DIR}/lib/sqlite.dll COPYONLY)
######     #### endif()
######     #### configure_file(${HDF5_DIR}/sqlite3.lib ${PROJECT_BINARY_DIR}/lib/sqlite.lib COPYONLY)
######     
######   else()
######     if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
######       set (HDF5_CUSTOM_FLAGS "${CXX_OSX_FLAGS}")
######     endif()
######     
######     # configure -- 
######     set( ENV{CC} ${CMAKE_C_COMPILER} )
######     set( ENV{CXX} ${CMAKE_CXX_COMPILER} )
######     set( ENV{CFLAGS} ${HDF5_CUSTOM_FLAGS})
###### 
######     if (BUILD_SHARED_LIBRARIES)
######       SET(HDF5_ARGS "-S HDF5config.cmake,BUILD_GENERATOR=Unix,INSTALLDIR=${CMAKE_BINARY_DIR},STATIC_ONLY=No -C Release -V -O hdf5.log")
######     else()
######       SET(HDF5_ARGS "-S HDF5config.cmake,BUILD_GENERATOR=Unix,INSTALLDIR=${CMAKE_BINARY_DIR},STATIC_ONLY=Yes -C Release -V -O hdf5.log")
######     endif()
######         
######     message( STATUS "Will configure HDF5 (ctest ${HDF5_ARGS} ... ")
###### 
######     exec_program(${CMAKE_CTEST_COMMAND} "${HDF5_DIR}"
######       ARGS
######       ${HDF5_ARGS}
######       WORKING_DIRECTORY "${HDF5_DIR}"
######       OUTPUT_VARIABLE HDF5_CONFIGURE_OUT
######       RETURN_VALUE HDF5_CONFIGURE_SUCCESS
######       )
###### 
######     # logfile
######     file(APPEND ${LOGFILE} ${HDF5_CONFIGURE_OUT})
###### 
######     if( NOT HDF5_CONFIGURE_SUCCESS EQUAL 0)
######       message( STATUS "Configure HDF5 library (./configure --prefix ${CMAKE_BINARY_DIR} --with-pic --disable-shared) .. failed")
######       message( FATAL_ERROR ${HDF5_CONFIGURE_OUT})
######     else()
######       message( STATUS "Configure HDF5 library (./configure --prefix ${CMAKE_BINARY_DIR} --with-pic --disable-shared) .. done")
######     endif()
######   
######     # make 
######     message( STATUS "Building HDF5 library (make) .. ")
######     # exec_program(${CMAKE_MAKE_PROGRAM} "${HDF5_DIR}"
######     #   ARGS -j ${NUMBER_OF_JOBS}
######     #   OUTPUT_VARIABLE SQLITE_MAKE_OUT
######     #   RETURN_VALUE SQLITE_MAKE_SUCCESS
######     #   )
######     # 
######     # file(APPEND ${LOGFILE} ${SQLITE_MAKE_OUT})
###### 
######     # if( NOT SQLITE_MAKE_SUCCESS EQUAL 0)
######     #   message( STATUS "Building SQLITE library (make) .. failed")
######     #   message( FATAL_ERROR ${SQLITE_MAKE_OUT})
######     # else()
######     #   message( STATUS "Building SQLITE library (make) .. done")
######     # endif()
###### 
######     # make install
######     message( STATUS "Installing HDF5 library (make install) .. ")
######     exec_program(${CMAKE_MAKE_PROGRAM} "${HDF5_DIR}"
######       ARGS "install"
######       -j ${NUMBER_OF_JOBS}
######       OUTPUT_VARIABLE SQLITE_INSTALL_OUT
######       RETURN_VALUE SQLITE_INSTALL_SUCCESS
######       )
###### 
######     file(APPEND ${LOGFILE} ${SQLITE_INSTALL_OUT})
###### 
######     if( NOT SQLITE_INSTALL_SUCCESS EQUAL 0)
######       message( STATUS "Installing SQLITE library (make install) .. failed")      
######       message( FATAL_ERROR ${SQLITE_INSTALL_OUT})
######     else()
######       message( STATUS "Installing SQLITE library (make install) .. done")
######     endif()
###### endif()
###### 
###### ENDMACRO( OPENMS_CONTRIB_BUILD_HDF5 )
