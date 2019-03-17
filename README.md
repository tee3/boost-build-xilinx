# Xilinx Tools for Boost.Build

## Overview

This project adds support for the Xilinx tools to Boost.Build.

### Xilinx SDK (XSDK)

The Xilinx SDK (XSDK) provides a tool called XSCT, which generates
components from a Hardware Definition File (HDF) as well as
configuration options and provides support for running code on the
hardware.

## Requirements

* Xilinx XSDK 2018.3 (or later)
* Boost.Build from Boost C++ Libraries 1.68.0 (or later)
* AsciiDoctor (for documentation)

## Example

The following is an example where a XSDK workspace named `ws` is
created from a hardware specification in `example.hdf` and used, along
with a C++ source file named `example.cpp` to create an application
named `example`.

Note below that the requirements of both `ws` and `example` match,
which is how Boost.Build matches.

```jam
# Jamfile
import xsdk ;

xsdkws ws
 : # sources
    example.hdf
 : # requirements
   <target-os>elf

   <link>static

   <instruction-set>cortex-r5

   <xsdk-configuration>"sleep_time psu_ttc_3"
 : # default-build
 : # usage-requirements
 ;

exe example
 : # sources
   example.cpp

   ws
 : # requirements
   <target-os>elf

   <link>static

   <instruction-set>cortex-r5
 : # default-build
 : # usage-requirements
 ;
```

## Documentation

The documentation is contained within the Boost.Build module file
(*e.g.*, `xsdk.jam`) using inline documentation based on AsciiDoc.  A
top-level document brings in documentation from each module.

Run the following command to build an HTML version of the
documentation.

``` shell
b2
```

## Testing

There are several test projects in the `test` directory.  All tests
are run by default using the default build configuration when
Boost.Build is run in the `test` directory.  Each test can also be run
individually by running Boost.Build in the directory of the desired
test to run.

Run the following command to run all the tests using the default build
configuration.

``` shell
cd test && b2 --verbose-test -j 8
```

In order to run these tests and also allow `b2 --help xsdk` to work,
set the `BOOST_BUILD_PATH` environment variable to the root directory
of this project.

UNIX:

```shell
BOOST_BUILD_PATH=$(pwd)
```

Windows:

```bat
set BOOST_BUILD_PATH=C:\Path\To\Project\Root
```

### `configure`

This project just checks the configuration of the `xsdk` module.

```shell
cd test/configure && b2 --verbose-test -j 8
```
