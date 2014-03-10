CMakeBoilerplate
================

This Boilerplate helps you to generate build files using CMake quickly. To use this boilerplate you have to:
* install CMake
* install Python
* follow some conventions which are described below

## Quickstart
The following description shows you how to setup the sample project _MyProject_ using CMakeBoilerplate.

At first create the root directory _MyProject_ which should contain the application(main) or/and all libraries of the project. For this Quickstart, we assume that _MyProject_ contains a static library with the name _MyDataAccessObjects_ only. For this static library create a directory with the name _MyDataAccessObjectsStatic_ within the directory _MyProject_. Within the directory _MyDataAccessObjectsStatic_ create two additional directories _src/_ and _include/_. For our sample we create further a source file _src/Person.cpp_ and the header file _include/Person.h_
The prepared directory structure for our sample project looks like:
```
+---MyProject
|   \---MyDataAccessObjectsStatic
|       +---include
|       |       Person.h
|       |       
|       \---src
|               Person.cpp
|
```

now. After preparing the directory structure CMakeBoilerplate expects, copy the CMakeBoilerplate files into the directory _MyProject/_. The final and ready to use directory structure is now:
```
+---MyProject
|   |   CMakeLists.txt
|   \---CMakeBoilerplate
|       + ...
|   \---thirdParty
|       + ...
|   \---MyDataAccessObjectsStatic
|       +---include
|       |       Person.h
|       |       
|       \---src
|               Person.cpp
|
```

Create a directory _build/_ outside the directory _MyProject/_ and lets CMake generate the build files for a specific generator to the directory _build_. 
