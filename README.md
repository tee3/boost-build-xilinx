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
 : # default-build
 : # usage-requirements
 ;
```

## Testing

There are several test projects in the `test` directory.  In order to
run these tests and also allow `b2 --help xsdk` to work, set the
`BOOST_BUILD_PATH` environment variable to the root directory of this
project.

UNIX:

```shell
BOOST_BUILD_PATH=$(pwd)
```

Windows:

```bat
set BOOST_BUILD_PATH=C:\Path\To\Project\Root
```

### `zcu102-empty`

This project is based on the "Empty Application" XSDK application
template and allows building within any supported `<target-os>elf` and
`<instruction-set>`, defaulting to `<target-os>elf` and
`<instruction-set>cortex-r5`.

Note any compatible Boost.Build features can also be specified on the
command line.

```shell
cd test/zcu102-empty && b2 --verbose-test -j 8
```

```shell
cd test/zcu102-empty && b2 --verbose-test -j 8 variant=release target-os=freertos instruction-set=cortex-a53
```

### `zcu102-hello-freertos`

This project is based on the "FreeRTOS Hello World" XSDK application
template for `<target-os>freertos` and allows building within any
supported `<instruction-set>`, defaulting to
`<instruction-set>cortex-r5`.

Note any compatible Boost.Build features can also be specified on the
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

Note any compatible Boost.Build features can also be specified on the
command line.

```shell
cd test/zcu102-rpc-demo && b2 --verbose-test -j 8
```

```shell
cd test/zcu102-rpc-demo && b2 --verbose-test -j 8 variant=release
```

## Reference

See the [module](xsdk.jam) for the user manual and reference
documentation.

The documentation is in AsciiDoc format in a form that can be used by
the Boost.Build project documentation.
