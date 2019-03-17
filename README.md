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
