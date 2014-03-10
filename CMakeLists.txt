cmake_minimum_required(VERSION 2.8.7)
#
# boilerplate setup
#
set(BP_MACRO_DIR ${CMAKE_SOURCE_DIR}/CMakeBoilerplate)
set(BP_CMAKE_TEMPLATE ${BP_MACRO_DIR}/CMakeListsTemplate/CMakeLists.txt)
set(BP_CMAKE_TEST_TEMPLATE ${BP_MACRO_DIR}/CMakeListsTestTemplate/CMakeLists.txt)
# location of third party libraries
set(BP_THIRD_PARTY_DIR "${CMAKE_SOURCE_DIR}/thirdParty")
# suffix for directories whith test-cases
set(BP_PROJECT_TEST_SUFFIX "Test")

# CMake-Modules with boilerplate macro definitions
list(APPEND CMAKE_MODULE_PATH ${BP_MACRO_DIR})
include(CMakeBoilerplate)

#
# setup workspace
#
bpCurrentScrDir(nameOfWorkspace)
message(STATUS "Setup workspace:[${nameOfWorkspace}]")
project(${nameOfWorkspace})

#
# global settings
#

# Against the recommendation(see CMake-Doc) not using GLOB 
# to collect a list of source files from the source tree,
# CMakeBoilerplate uses GLOB! If you add new source files 
# to the source tree you MUST execute the
# cmake command manually!
set(CMAKE_SUPPRESS_REGENERATION  true)
# where to store the build executables and libraries
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin) 
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)

#
# Prepare all subdirectories which contain source code, for CMake-processing.
# If a subdirectory contains source code but contsins no CMakeLists.txt file
# a proper CMakeLists.txt script is copied into the subdirectory.
#
bpGetSubDirListWithSourceFiles(${CMAKE_SOURCE_DIR} subDirList)
foreach(dir ${subDirList})
   if(${dir} MATCHES "${BP_PROJECT_TEST_SUFFIX}" AND NOT ${dir} STREQUAL ${BP_THIRD_PARTY_DIR})
      if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${dir}/CMakeLists.txt")
        message(STATUS "Copy (Test) ${BP_CMAKE_TEST_TEMPLATE} to [${dir}]")
	bpCopyFiles("${BP_CMAKE_TEST_TEMPLATE}" "${CMAKE_SOURCE_DIR}/${dir}")    
      endif(NOT EXISTS "${CMAKE_SOURCE_DIR}/${dir}/CMakeLists.txt")
   else(noTestProject)
      bpTypeOfModule(${dir} typeOfModule)
      if(NOT ${typeOfModule} STREQUAL "no" AND NOT EXISTS "${CMAKE_SOURCE_DIR}/${dir}/CMakeLists.txt")
        message(STATUS "Copy ${BP_CMAKE_TEMPLATE} to [${dir}]")
	bpCopyFiles("${BP_CMAKE_TEMPLATE}" "${CMAKE_SOURCE_DIR}/${dir}")    
      endif(NOT ${typeOfModule} STREQUAL "no" AND NOT EXISTS "${CMAKE_SOURCE_DIR}/${dir}/CMakeLists.txt")
  endif(${dir} MATCHES "${BP_PROJECT_TEST_SUFFIX}" AND NOT ${dir} STREQUAL ${BP_THIRD_PARTY_DIR})
endforeach(dir ${subDirList})

#
# global compiler and linker flags
#
if(MSVC)
  # when using Microsoft Visual C
  # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -EHsc")
elseif(UNIX)
  # for UNIX and UNIX like operating systems
  # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall)
endif(MSVC)

#
# enable unit-testing
#
set(BP_ENABLE_UNIT_TESTS true)
if(${BP_ENABLE_UNIT_TESTS})
  set(BP_PATH_TO_UNIT_TEST_FRAMEWORK "${BP_THIRD_PARTY_DIR}/cxxtest")
  set(CXXTEST_INCLUDE_DIR ${BP_PATH_TO_UNIT_TEST_FRAMEWORK})
  set(CXXTEST_PYTHON_TESTGEN_EXECUTABLE "${BP_PATH_TO_UNIT_TEST_FRAMEWORK}/bin/cxxtestgen")
  set(CXXTEST_USE_PYTHON true)
  find_package(CxxTest)
endif(${BP_ENABLE_UNIT_TESTS})

#
# create / setup projects
#
foreach(dir ${subDirList})
  bpTypeOfModule(${dir} typeOfModule)
  if(NOT ${typeOfModule} STREQUAL "no" AND NOT ${dir} MATCHES "${BP_PROJECT_TEST_SUFFIX}" AND NOT ${dir} STREQUAL ${BP_THIRD_PARTY_DIR})
    add_subdirectory(${dir})
  endif(NOT ${typeOfModule} STREQUAL "no" AND NOT ${dir} MATCHES "${BP_PROJECT_TEST_SUFFIX}" AND NOT ${dir} STREQUAL ${BP_THIRD_PARTY_DIR})
endforeach(dir ${subDirList})

#
# create / setup corresponding test-projects
#
if(${BP_ENABLE_UNIT_TESTS})
   foreach(dir ${subDirList})
     if(${dir} MATCHES "${BP_PROJECT_TEST_SUFFIX}" AND NOT ${dir} STREQUAL ${BP_THIRD_PARTY_DIR})
        add_subdirectory(${dir})
     endif(${dir} MATCHES "${BP_PROJECT_TEST_SUFFIX}" AND NOT ${dir} STREQUAL ${BP_THIRD_PARTY_DIR})
   endforeach(dir ${subDirList})
endif(${BP_ENABLE_UNIT_TESTS})

#
# setup thirdParty libs
#
message(STATUS "Configure thirdParty libraries ...")
bpGetSubDirListWithSourceFiles("${BP_THIRD_PARTY_DIR}" thirdPartySubDirList)
foreach(dir ${thirdPartySubDirList})
   set(copyFileTarget "${BP_THIRD_PARTY_DIR}/${dir}/CMakeLists.txt")
   if(NOT ${dir} STREQUAL "cxxtest")
     if(NOT EXISTS ${copyFileTarget})
       message(STATUS "Copy ${BP_CMAKE_TEMPLATE} to [${BP_THIRD_PARTY_DIR}/${dir}]")
       bpCopyFiles("${BP_CMAKE_TEMPLATE}" "${BP_THIRD_PARTY_DIR}/${dir}")
     endif(NOT EXISTS ${copyFileTarget})
     #     
     add_subdirectory(${BP_THIRD_PARTY_DIR}/${dir})
   endif(NOT ${dir} STREQUAL "cxxtest")
endforeach(dir ${thirdPartySubDirList})


