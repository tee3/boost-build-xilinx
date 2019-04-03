Xilinx Tool for Boost.Build
=======================

.. contents::

Overview
--------

This project adds support for the Xilinx tools to
Boost.Build.

Xilinx SDK (XSDK)
~~~~~~~~~~~~~~~~~

The Xilinx SDK (XSDK) provides a tool called ``XSCT``, which generates
components from a Hardware Definition File (HDF) as well as
configuration options and provides support for running code on the
hardware.

Requirements
------------

* Xilinx XSDK 2018.3 (or later)
* Boost.Build from Boost C++ Libraries 1.68.0 (or later)

Usage
-----

Xilinx SDK (XSDK)
~~~~~~~~~~~~~~~~~

The Xilnx Boost.Build module provides the ``xsdk`` tool.

Configuration
`````````````

.. code::

   import xsdk ;

The XSDK tool must be configured as any other Boost.Build tool.  The
tool will automatically detect the location and version of the tool.

.. code::

   using xsdk ;

The desired version can be specified.

.. code::

   using xsdk : 2018.3 ;

The location can also be specified both with and without a desired
version.

.. code::

   using xsdk : : /opt/Xilinx/SDK/2018.3 ;

Note that running with the ``--debug-configuration`` option to
Boost.Build will include the XSDK location and version as well as the
application templates, operating systems, libraries, and drivers
supported by the version of the tool configured.

Targets
```````

This tool provides a top-level target type named ``xsdkws`` that
generates an XSDK Workspace as described above for supported target
operating systems, processors, and configuration options.

The generates the workspace as well as several supporting XSCT
scripts.

See the Reference section for more information.

Toolsets
````````

Note that in order to choose the correct toolset, the toolset should
be made conditional on the ``instruction-set`` in the build system.
One approach for doing this would be to set project requirements in
the Jamroot.  This is required because the ``toolset`` feature cannot
set in ``usage-requirements``.

.. code::

   # Jamroot
   project
     : requirements
       <instruction-set>cortex-a9:<toolset>gcc-7xilinxaarch32
       <instruction-set>cortex-a53:<toolset>gcc-7xilinxaarch64

       <instruction-set>cortex-r5:<toolset>gcc-7xilinxarmr5

       <instruction-set>microblaze:<toolset>gcc-7xilinxmicroblaze
     ;

.. code::

   # project-config.jam

   using xsdk ;

   local xsdk-root = [ xsdk.root ] ;

   using gcc : 7xilinxaarch32 : $(xsdk-root)/gnu/aarch32/lin/gcc-arm-none-eabi/bin/arm-none-eabi-g++ ;
   using gcc : 7xilinxaarch64 : $(xsdk-root)/gnu/aarch64/lin/aarch64-none/bin/aarch64-none-elf-g++ ;

   using gcc : 7xilinxarmr5 : $(xsdk-root)/gnu/armr5/lin/gcc-arm-none-eabi/bin/armr5-none-eabi-g++ ;

   using gcc : 7xilinxmicroblaze : $(xsdk-root)/gnu/microblaze/lin/bin/microblaze-xilinx-elf-g++ ;

Example
```````

The following is an example where a XSDK workspace named ``ws`` is
created from a hardware specification in ``example.hdf`` and used,
along with a C++ source file named ``example.cpp`` to create an
application named ``example``.

Note below that the requirements of both ``ws`` and ``example`` match,
which is how Boost.Build matches.

.. code::

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

Reference
---------

Xilinx FPGA
~~~~~~~~~~~

* Zynq UltraScale+ MPSoC
* Zynq 7000 SoC

Toolsets
~~~~~~~~

This module supports the processor-specific ``gcc`` toolsets delivered
within the Xilinx XSDK.

Target Operating Systems
~~~~~~~~~~~~~~~~~~~~~~~~

``elf``

   The ``standalone`` Xilinx operating system.

   Note that ``elf`` is the standard Boost.Build name for a bare-metal
   program.

``freertos``

   The FreeRTOS operating system.

Architectures
~~~~~~~~~~~~~

* ARM (``arm``)
* Microblaze (``microblaze``)

Instruction Sets
~~~~~~~~~~~~~~~~

* ``cortex-a9``
* ``cortex-a53``
* ``cortex-r5``
* ``microblaze``

Main Target
~~~~~~~~~~~

This project will add one main target type.

``xsdkbsp ( name : source : requirements * : default-build * : usage-requirements )``

   This target will place an application named ``app``, a
   board-support packaged named ``bsp``, and a hardware definition
   named ``hw`` within a workspace named as defined in the rule,
   ``$(name)``, and provide ``usage-requirements`` to users of the
   named target.

   This target will also create several supporting XSCT scripts in the
   build directory.  These script can run using XSCT.

   ``print.tcl``

      This script will print out all the available configuration options
      for the XSDK Workspace.  This can be useful when developing the
      configuration for a project.

   ``run.tcl /path/to/compatible/program.elf``

      This script will run any program built with the XSDK Workspace.

      Note that this script can be used with the Boost.Build
      ``testing`` module as a ``<testing.launcher>``.

   This target works by creating and running an XSCT script containing
   ``xsct`` commands with values translated from Boost.Build features
   such as ``<instruction-set>``, ``<target-os>``, and others.  Some
   representative examples of those ``xsct`` commands are below.

   Create the workspace (``$(build-dir)/$(name).xsdkws``) from the properties.

   .. code:: tcl

      setws $(build-dir)/$(name).xsdkws

   Generate the hardware definition (``hw``) from the hardware
   definition file specified in ``$(source)``.

   .. code:: tcl

      createhw -name hw -hwspec $(source:G=)

   Generate and build a board-support package (``bsp``) from the
   hardware definition (``hw``), standard Boost.Build features, and
   free-form configuration options.

   .. code::

      createbsp -name bsp -proc $(xsdk-instruction-set) -hwproject hw -os $(xsdk-os-name)

      configbsp -bsp bsp sleep_timer psu_ttc_3

      updatemss -mss  $ws/bsp/system.mss
      regenbsp -bsp bsp

      projects -build -type bsp -name bsp

   Generate and build an application (``app``) which provides a
   linker-command file and some options required to properly build an
   application.

   Note that building the application is done as a reference to debug
   build issues with programs not built using the XSCT tool.

   .. code::

      createapp -name app -app {$(xsdk-template)} -lang $(xsdk-language) -bsp bsp -proc psu_$(xsdk-instruction-set)_$(xsdk-processor-id) -hwproject hw -os $(xsdk-os-name)

      projects -build -type app -name app

Boost.Build Features
~~~~~~~~~~~~~~~~~~~~

The following Boost.Build features are used to configure the XSDK.
Workspace.

* ``target-os``
* ``instruction-set``

XSDK-related Features
~~~~~~~~~~~~~~~~~~~~~

Boost.Build will generally configure the board-support package given
Boost.Build features.  These features can be overridden using the
following toolset flags.

``xsdk-template``

   This feature indicates the application template used to generate
   the application.  The application provides the linker script used
   by programs built with the XSDK Workspace.

   The resulting files can be used to create or update the actual
   application code, but are not used when generating programs from
   the XSDK Workspace.

   This defaults to an empty application.

``xsdk-configuration``

   This feature provides information for configuring a board-support
   package.  A configuration is a string added to the end of the call
   to ``configbsp``.

   The system will generate the following for each
   ``<xsdk-configuration>STRING``.

   .. code::

      configbps -bsp bsp STRING

``xsdk-library``

   This feature adds Xilinx libraries to the board-support package.
   These are the library names as described in the XSDK documentation.

``xsdk-processor-id``

   This feature assigns an application to run on a particular
   processor on the SoC, defaulting to 0.

Testing
-------

There are several test projects in the ``test`` directory.

``zcu102-empty``
~~~~~~~~~~~~~~~~~~~~

This project is based on the "Empty Application" XSDK application
template and allows building within any supported ``<target-os>elf``
and ``<instruction-set>``, defaulting to ``<target-os>elf`` and
``<instruction-set>cortex-r5``.

Note any compatible Boost.Build features can also be specified on the
command line.

.. code::

   cd test/zcu102-empty && b2 --verbose-test -j 8

.. code::

   cd test/zcu102-empty && b2 --verbose-test -j 8 variant=release target-os=freertos instruction-set=cortex-a53

``zcu102-freertos-hello``
~~~~~~~~~~~~~~~~~~~~~~~~~

This project is based on the "FreeRTOS Hello World" XSDK application
template for ``<target-os>freertos`` and allows building within any
supported ``<instruction-set>``, defaulting to
``<instruction-set>cortex-r5``.

Note any compatible Boost.Build features can also be specified on the
command line.

.. code::

   cd test/zcu102-empty && b2 --verbose-test -j 8

.. code::

   cd test/zcu102-empty && b2 --verbose-test -j 8 variant=release instruction-set=cortex-a53


``zcu102-rpc-demo``
~~~~~~~~~~~~~~~~~~~

This project is based on the "OpenAMP RPC Demo" XSDK application
template for ``<target-os>freertos`` and
``<instruction-set>cortex-r5``.

Note any compatible Boost.Build features can also be specified on the
command line.

.. code::

   cd test/zcu102-empty && b2 --verbose-test -j 8

.. code::

   cd test/zcu102-empty && b2 --verbose-test -j 8 variant=release
