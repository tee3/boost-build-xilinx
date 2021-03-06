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

The documentation is based on AsciiDoc and is contained in an within a
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

### `zcu102-empty`

This project is based on the "Empty Application" XSDK application
template builds all valid `<target-os>` and `<instruction-set>`.

Any compatible Boost.Build features can also be specified on the
command line.

```shell
cd test/zcu102-empty && b2 --verbose-test -j 8
```

```shell
cd test/zcu102-empty && b2 --verbose-test -j 8 variant=release target-os=freertos instruction-set=cortex-a53
```

### `zcu102-hello`

This project is based on either the "Hello World" application template
or the "FreeRTOS Hello World" XSDK application template for
`<target-os>freertos` and builds all valid combinations of
`<target-os>` and `<instruction-set>`.

Any compatible Boost.Build features can also be specified on the
command line.

```shell
cd test/zcu102-empty && b2 --verbose-test -j 8
```

```shell
cd test/zcu102-empty && b2 --verbose-test -j 8 variant=release instruction-set=cortex-a53
```

### `zcu102-rpc-demo`

This project is based on the "OpenAMP RPC Demo" XSDK application
template for `<target-os>freertos` and `<instruction-set>cortex-r5`.
The source file containing the main program has been split and that is
used to create a C++ version of the main program as well.

Note any compatible Boost.Build features can also be specified on the
command line.

```shell
cd test/zcu102-rpc-demo && b2 --verbose-test -j 8
```

```shell
cd test/zcu102-rpc-demo && b2 --verbose-test -j 8 variant=release
```

## Reference

See the [documentation](xsdk.adoc) for the user manual and reference
documentation.

The documentation is in AsciiDoc format in a form that can be used by
the Boost.Build project documentation.
