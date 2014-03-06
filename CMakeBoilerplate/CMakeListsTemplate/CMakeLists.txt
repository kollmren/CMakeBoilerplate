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
# linker settings 
#
SET_TARGET_PROPERTIES("${nameOfModule}" PROPERTIES LINKER_LANGUAGE C++)

link_directories(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

target_link_libraries("${nameOfModule}"
	# e.g. sqlite
   )


