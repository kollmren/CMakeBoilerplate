# Addional includes and libs must be set before or after that macro.
# Parameters:  
# @typeOfModule must be one of the values:lib-static, lib-dynamic, executable
macro(bpCreateModule nameOfModule srcAbsPath addionalSrcFiles addionalIncludeFiles typeOfModule)
  file(GLOB_RECURSE SRC_FILES_${nameOfModule} "${srcAbsPath}/src/*.cpp")
  file(GLOB_RECURSE SRC_FILES_C_${nameOfModule} "${srcAbsPath}/src/*.c")
  set(SRC_FILES_${nameOfModule} ${SRC_FILES_${nameOfModule}} ${SRC_FILES_C_${nameOfModule}} ${addionalSrcFiles})
  file(GLOB_RECURSE INC_FILES_h "${srcAbsPath}/*.h")
  file(GLOB_RECURSE INC_FILES_hpp "${srcAbsPath}/*.hpp")
  set(INC_FILES_${nameOfModule} ${INC_FILES_h} ${INC_FILES_hpp} ${addionalIncludeFiles})
  source_group("include" FILES ${INC_FILES_${nameOfModule}})
  source_group("src" REGULAR_EXPRESSION ".*\\.cpp" FILES ${SRC_FILES_${nameOfModule}})
  include_directories("${srcAbsPath}/include/")
  # add  the include files too, is necessary to visit the files in the IDE
  if(${typeOfModule} STREQUAL "lib-static")
    add_library(${nameOfModule} STATIC ${SRC_FILES_${nameOfModule}} ${INC_FILES_${nameOfModule}})
  elseif(${typeOfModule} STREQUAL "lib-dynamic")
    add_library(${nameOfModule} SHARED ${SRC_FILES_${nameOfModule}} ${INC_FILES_${nameOfModule}})
  elseif(${typeOfModule} STREQUAL "executable")
    add_executable(${nameOfModule} ${SRC_FILES_${nameOfModule}} ${INC_FILES_${nameOfModule}})
  endif(${typeOfModule} STREQUAL "lib-static")
endmacro(bpCreateModule nameOfModule srcAbsPath addionalSrcFiles addionalIncludeFiles typeOfModule)

#
#
#
macro(bpCreateTestForModule nameOfModule srcAbsPath)
  #file(GLOB SRC_FILES_TEST_${nameOfModule} "${srcAbsPath}/*.cpp")
  file(GLOB HEADER_FILES_TEST_${nameOfModule} "${srcAbsPath}/*.h")
  #source_group("src" REGULAR_EXPRESSION ".*\\.cpp" FILES ${SRC_FILES_TEST_${nameOfModule}})
  #source_group("include" REGULAR_EXPRESSION ".*\\.h" FILES ${HEADER_FILES_TEST_${nameOfModule}})
  #include_directories("${srcAbsPath}/include/")  
  # cxxtest test-framework ###  
  if(CXXTEST_FOUND)
    include_directories(${CXXTEST_INCLUDE_DIR})
    CXXTEST_ADD_TEST(${nameOfModule}
      test_${nameOfModule}.cpp     
      "${HEADER_FILES_TEST_${nameOfModule}}")  
    ###
    add_custom_command(TARGET ${nameOfModule}
      POST_BUILD
      COMMAND ${nameOfModule}
      COMMENT "Run test ${nameOfModule} ...")
  elseif(CXXTEST_FOUND)
    message(FATAL_ERROR "Could not setup Unit-Tests for modile:${nameOfModule}")
  endif(CXXTEST_FOUND)
endmacro(bpCreateTestForModule nameOfModule srcAbsPath)

#
#
#
macro(bpTypeOfModule nameOfModule typeOfModule)
  if(${nameOfModule} MATCHES ".*Static$")
    set(${typeOfModule} "lib-static")
  elseif(${nameOfModule} MATCHES ".*Dynamic$")
    set(${typeOfModule} "lib-dynamic")
  elseif(${nameOfModule} MATCHES ".*Main$")
    set(${typeOfModule} "executable")
  else(${nameOfModule} MATCHES ".*Static$")
    set(${typeOfModule} "no")
  endif(${nameOfModule} MATCHES ".*Static$")
endmacro(bpTypeOfModule nameOfModule typeOfModule)

#
#
#
macro(bpRemoveModuleTypeIdentifier nameOfDir nameOfModule)
  set(identifierMatch "NO")
  set(nameOfModuleMatch "")
  # Main
  string(REGEX MATCH "([a-zA-Z_0-9]*)Main$" modulName ${nameOfDir})
  string(LENGTH "${CMAKE_MATCH_1}" lengthOfMatch)
  if(${lengthOfMatch} GREATER "0")
    set(identifierMatch "YES")
    set(nameOfModuleMatch ${CMAKE_MATCH_1})
  endif(${lengthOfMatch} GREATER "0")
  # Static
  string(REGEX MATCH "([a-zA-Z_0-9]*)Static$" modulName ${nameOfDir})  
  string(LENGTH "${CMAKE_MATCH_1}" lengthOfMatch)
  if(${lengthOfMatch} GREATER "0")
    set(identifierMatch "YES")
    set(nameOfModuleMatch ${CMAKE_MATCH_1})
  endif(${lengthOfMatch} GREATER "0")
  # Dynamic
  string(REGEX MATCH "([a-zA-Z_0-9]*)Dynamic$" modulNameDynamic ${nameOfDir})
  string(LENGTH "${CMAKE_MATCH_1}" lengthOfMatch)
  if(${lengthOfMatch} GREATER "0")
    set(identifierMatch "YES")
    set(nameOfModuleMatch ${CMAKE_MATCH_1})
  endif(${lengthOfMatch} GREATER "0")
  #
  if(${identifierMatch})
    set(nameOfModule ${nameOfModuleMatch})
  else(abort)
    message(FATAL_ERROR "The name of a module directory must end with: Main, Dynamic or Static e.g. fooMain/")
  endif(${identifierMatch})

endmacro(bpRemoveModuleTypeIdentifier nameOfModule)

#
#
#
macro(bpRemoveModuleTestIdentifier nameOfDir nameOfModule)
  set(identifierMatch "NO")
  set(nameOfModuleMatch "")
  # Test
  string(REGEX MATCH "([a-zA-Z_0-9]*)Test$" modulName ${nameOfDir})
  string(LENGTH "${CMAKE_MATCH_1}" lengthOfMatch)
  if(${lengthOfMatch} GREATER "0")
    set(identifierMatch "YES")
    set(nameOfModuleMatch ${CMAKE_MATCH_1})
  endif(${lengthOfMatch} GREATER "0")
  #
  if(${identifierMatch})
    set(nameOfModule ${nameOfModuleMatch})
  else(abort)
    message(FATAL_ERROR "The name of a test-module directory must end with suffix:Test e.g. fooTest/")
  endif(${identifierMatch})
endmacro(bpRemoveModuleTestIdentifier nameOfDir nameOfModule)

#
#
#
macro(bpCopyFiles listOfFiles destinationPath)
  #execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/nameOfFile.txt ${CMAKE_CURRENT_SOURCE_DIR}/nameOfFile.h)
  file(COPY ${listOfFiles} DESTINATION "${destinationPath}") 
endmacro(bpCopyFiles listOfFiles destinationPath)

#
#
#
macro(bpGetSubDirListWithSourceFiles srcAbsPath listOfSubDirs)
  message(STATUS "Search for subdirectories which contain source files with extensions:.c, .cpp, .h, .hpp in:${srcAbsPath}")
#  file(GLOB_RECURSE listOfSource_c RELATIiVE "${srcAbsPath}" "${srcAbsPath}/*.c")
#  file(GLOB_RECURSE listOfSource_cpp RELATIVE "${srcAbsPath}" "${srcAbsPath}/*.cpp")
file(GLOB_RECURSE listOfSourceFiles RELATIVE "${srcAbsPath}" "${srcAbsPath}/*.c" "${srcAbsPath}/*.cpp" "${srcAbsPath}/*.h" "${srcAbsPath}/*.hpp")

#  set(listOfSourceFiles ${listOfSource_c} ${listOfSource_cpp})
  foreach(sourceFile ${listOfSourceFiles})
    string(REGEX MATCH "([a-zA-Z_0-9]*)/" dirName ${sourceFile})
    list(FIND ${listOfSubDirs} ${CMAKE_MATCH_1} dirFoundInList)
    if(${dirFoundInList} EQUAL -1)
      if(IS_DIRECTORY "${srcAbsPath}/${CMAKE_MATCH_1}")
	list(APPEND ${listOfSubDirs} ${CMAKE_MATCH_1})
      endif(IS_DIRECTORY "${srcAbsPath}/${CMAKE_MATCH_1}")
    endif(${dirFoundInList} EQUAL -1)    
  endforeach(sourceFile ${listOfSourceFiles})
endmacro(bpGetSubDirListWithSourceFiles srcAbsPath listOfSubDirs)

#
#
#
macro(bpCurrentScrDir varOut)
  string(REGEX MATCH "[^/]+$" currentDir ${CMAKE_CURRENT_SOURCE_DIR})
  set(${varOut} ${currentDir})
endmacro(bpCurrentScrDir varOut)

#
# filesIn : Headers with the macro Q_OBJECT
#
macro(bpCreateMocFiles filesIn filesOut targetDirectory)
  QT4_WRAP_CPP(mocFilesTemp ${${filesIn}})
  foreach(mocFile ${mocFilesTemp})
    #file(TO_NATIVE_PATH ${targetDirectory} targetPath)
    string(REGEX MATCH "[a-zA-Z_]*\\.[hcpx]*$" fileName ${mocFile})
    set(absPath "${targetPath}/${fileName}")
    QT4_GENERATE_MOC(${mocFile} ${absPath})
    list(APPEND ${filesOut} ${absPath})
  endforeach(mocFile ${mocFilesTemp})
endmacro(bpCreateMocFiles filesIn filesOut targetDirectory)

#
#
#
macro(bpCreateUnitTestClass srcFiles unitClassTemplate classPlaceHolder targetDir)
  foreach(loop_var ${${srcFiles}})
    #consider the content of header files only
    if(${loop_var} MATCHES ".*\\.h$")
      file(READ ${loop_var} contentOfHeader)
      # Empty files are not processed
      if(contentOfHeader)
	string(REGEX MATCH "class ([a-zA-Z]*)" matchValue ${contentOfHeader})
	if(IS_DIRECTORY ${targetDir})
	  set(nameOfUnitClassFile "${CMAKE_MATCH_1}Test.cpp")
	  if(NOT EXISTS "${targetDir}/${nameOfUnitClassFile}")	    
	    string(REPLACE ${classPlaceHolder} ${CMAKE_MATCH_1} testFileContent ${unitClassTemplate})	    
	    file(WRITE "${targetDir}/${nameOfUnitClassFile}" "${testFileContent}")
	  endif(NOT EXISTS "${targetDir}/${nameOfUnitClassFile}")
	endif(IS_DIRECTORY ${targetDir})
      endif(contentOfHeader)
    endif(${loop_var} MATCHES ".*\\.h$")
  endforeach(loop_var)
endmacro(bpCreateUnitTestClass srcFiles unitClassTemplate targetDir
)
