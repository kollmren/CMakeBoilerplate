CMakeBoilerplate
================

This Boilerplate helps you to generate build files using CMake quickly. To use this boilerplate you have to:
* install CMake
* install Python ( required for Unit-Testing with cxxTest )
* follow some conventions which are described below

## Quickstart
The following description shows you how to setup the sample project _MyProject_ using CMakeBoilerplate.

At first create a root directory _MyProject_ which should contain the application(main) or/and all libraries of the project. For this quickstart, we assume that _MyProject_ contains a static library with the name _MyDataAccessObjects_ only. For this static library create a directory with the name _MyDataAccessObjectsStatic_ within the directory _MyProject_. Within the directory _MyDataAccessObjectsStatic_ create two additional directories _src/_ and _include/_. For our sample we create further a source file _src/Person.cpp_ and the header file _include/Person.h_
The prepared directory structure for our sample project _MyProject_ looks like:
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

now. After preparing the directory structure which CMakeBoilerplate expects, copy the CMakeBoilerplate files into the directory _MyProject/_. The final and ready to use directory structure is now:
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

Create a directory _build/_ outside the directory _MyProject/_ and let CMake generate the build files with a specific generator ( available on your platform ) to the directory _build_. Taken the following directory structure for example:

```
+---MyProject
|   ...
+---build
```
execute the cmake command within the _build_ directory as: 
_cmake -G "Unix Makefiles" ../MyProject_

## Adding a project with Unit-Tests
The quickstart section described the required steps to setup a static library named _MyDataAccessObjectsStatic_ within the project _MyProject_. The _Static_ suffix in the directory name instructs CMakeBoilerplate to configure a static libraray. Next to the _Static_ suffix the following suffixes can be used:
* _Dynamic_ - configures a dynamic loaded library
* _Main_ - configures a application

Now we want to Unit-Test the library  _MyDataAccessObjectsStatic_. Therefore we create a directory _MyDataAccessObjectsTest_ within the directory _MyProject/_ . CMakeBoilerplate uses the cxxTest framework (http://cxxtest.com/) to setup the Unit-Tests. Copy the sample file _MyProject/thiryParty/cxxtest/sample/SimpleTest.h_ to the directory _MyDataAccessObjectsTest_ and rename the file to _PersonTest.h_. Tailor the file _PersonTest.h_ e.g. including the header file _Person.h_. The required dependencies will be configured by CMakeBoilerplate.
> If you add new source files (.h. .hpp, .c, .cpp) to a already processed directory you have to call the _cmake_ command **manually** again. The same applies if you create or add new directories which contain source files!

## Adding third party libraries
The source code of third party libraries should be saved to the directory _thirdParty/_ considering the same conventions as described above.

## Tailoring the _CMakeLists.txt_ files within each subdirectory
When the CMake-Script _CMakeLists.txt_ is processed by CMake it checks if each subdirectory of the project contains a _CMakeLists.txt_. If not, it copies a template _CMakeLists.txt_ to such a directory. The copied templates contain documented CMake commands and variables which you must customise to your specfic project dependencies etc.
