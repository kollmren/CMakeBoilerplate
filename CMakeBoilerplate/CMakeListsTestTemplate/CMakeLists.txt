##########################################################################
# TEST-Project specific settings
##########################################################################
if(BP_ENABLE_UNIT_TESTS)
  bpCurrentScrDir(nameOfDir)
  bpRemoveModuleTestIdentifier(${nameOfDir} nameOfModule) 
  message(STATUS "Create build files for test-module:[${nameOfDir}]")
  #
  # add include dependencies here
  #

  include_directories("${CMAKE_SOURCE_DIR}/${nameOfDir}/include"
	  "${CMAKE_SOURCE_DIR}/${nameOfModule}Static/include"
	  "${CMAKE_SOURCE_DIR}/${nameOfModule}Dynamic/include"
    	  "${CMAKE_CURRENT_BINARY_DIR}"
	  ${BP_THIRD_PARTY_DIR}/sqliteStatic/include)
  
  #
  # Write the path to the testData directory to a header-file.
  #  
  # file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/cmakeGenerated.h" "#define TEST_DATA_ROOT_PATH \"${CMAKE_CURRENT_SOURCE_DIR}/testData/\"\n")
  # file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/cmakeGenerated.h" "#define TEST_DATA_TMP_DIR \"${CMAKE_CURRENT_BINARY_DIR}\"") 
  #  
  
  #
  # collect source- and header-files, setup the project
  #
  bpCreateTestForModule("${nameOfDir}" "${CMAKE_CURRENT_SOURCE_DIR}")
  target_link_libraries("${nameOfDir}"
	${nameOfModule} 
	# add further dependencies e.g. core dao
	)

endif(BP_ENABLE_UNIT_TESTS)
