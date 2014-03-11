##########################################################################
# Project specific settings
##########################################################################
bpCurrentScrDir(nameOfDirectory)
bpTypeOfModule(${nameOfDirectory} typeOfModule)
bpRemoveModuleTypeIdentifier(${nameOfDirectory} nameOfModule)
message(STATUS "Create build files for:[${nameOfModule}] - (type of module: ${typeOfModule})")
#
# add include dependencies here
# 
include_directories( ${CMAKE_SOURCE_DIR}/${nameOfDirectory}/include
# e.g. ${BP_THIRD_PARTY_DIR}/sqlite/include
    )

#
# add definitions for all source files
#
add_definitions( #-DFOO -DBAR
    )

#
# collect source files and setup project
#
bpCreateModule(${nameOfModule} ${CMAKE_CURRENT_SOURCE_DIR} "" "" ${typeOfModule})

#
# compiler flags
#
if(MSVC)
  # when using Microsoft Visual C
  # for target
  set_target_properties(${nameOfModule} PROPERTIES COMPILE_FLAGS "/EHsc")
  # per file
  # e.g. file(GLOB fullPathToSrcFile "${CMAKE_CURRENT_SOURCE_DIR}/src/Person.cpp")
  # set_source_files_properties(${fullPathToSrcFile} PROPERTIES COMPILE_FLAGS "/EHsc")
elseif(UNIX)
  # for UNIX and UNIX like operating systems
  # for target
  # e.g. set_target_properties(${nameOfModule} PROPERTIES COMPILE_FLAGS "/EHsc")
  # per file
  # e.g. file(GLOB fullPathToSrcFile "${CMAKE_CURRENT_SOURCE_DIR}/src/Person.cpp")
  # set_source_files_properties(${fullPathToSrcFile} PROPERTIES COMPILE_FLAGS "/EHsc")
endif(MSVC)

#
# linker settings 
#
# SET_TARGET_PROPERTIES("${nameOfModule}" PROPERTIES LINKER_LANGUAGE CXX)

link_directories(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

target_link_libraries("${nameOfModule}"
	# e.g. sqlite
   )


