# Xilinx Tools for Boost.Build

## Overview

This project adds support for the Xilinx tools to Boost.Build.

This project currently provides a fairly rigid script for use in
building projects that follow a very strict structure.  A more
flexible approach is the long-term goal of this project.

## Requirements

* Xilinx SDK (XSDK) 2018.3

## Usage

* builds are done from the root of the project
* the FPGA image files (`.bit` and `.hdf`) are located in `bin/v36-0101`
* a program named `PROGRAM` has a source file in `test/PROGRAM/main.cc`
* build products will be built in workspace at `project/xsct/test/target/bin`
  * the hardware is at `project/xsct/test/target/bin/hw`
  * the board-support package is at  `project/xsct/test/target/bin/bsp`
  * the program `PROGRAM` is at  `project/xsct/test/target/bin/PROGRAM`

Download the required version of the FPGA image.

``` shell
mkdir -p bin/v36-0101
python lib/github_helper.py/github_helper.py download-asset automatoninc ar-sensor-fpga v36-0101 ar_sensor_fpga.bit bin/v36-0101/ar_sensor_fpga.bit
python lib/github_helper.py/github_helper.py download-asset automatoninc ar-sensor-fpga v36-0101 ar_sensor_fpga.hdf bin/v36-0101/ar_sensor_fpga.hdf
```

Build the target programs using XSDK.

``` shell
source /opt/Xilinx/SDK/2018.3/settings64.sh
xsct project.tcl build
```

Running the test programs is currently a manual process.  The Xilinx
SDK ``xsct`` program is used to control the process.  There is a
function within the ``project.tcl`` file called ``run-project``, which
contains the commands required to run the project.

Do the following on the machine directly attached to the AR Sensor USB
JTAG and USB Serial.

Prior to running each program, power the AR Sensor up and down.

``` shell
~/bin/power-cycle-poe-port1.exp
```

Run the ``hw_server`` in a terminal.

``` shell
   source /opt/Xilinx/SDK/2018.3/settings64.sh && hw_server
```

Run ``minicom`` in a terminal.

``` shell
minicom --device=/dev/ttyUSB1
```

Run the following representative commands on the development machine
to run the desired program, in this example the ``hello`` program.

.. code:: sh

   $ source /opt/Xilinx/SDK/2018.3/settings64.sh
   $ xsct
   xsct% source project.tcl
   xsct% set project hello
   Xsct% # paste contents of the run-project procedure here
