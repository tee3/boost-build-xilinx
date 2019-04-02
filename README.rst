Xilinx SDK for Boost.Build
==========================

.. contents::

Overview
--------

This project adds support for the Xilinx tools to Boost.Build.

Rationale
---------

Boost.Build will create a single workspace for all XSDK components
within a project.

Requirements
------------

* Xilinx XSDK 2018.3 (or later)
* Boost.Build from Boost C++ Libraries 1.68.0 (or later)

Example
-------

The following is an example where a XSDK workspace named ``ws`` is
created from a hardware specification in ``example.hdf`` and used,
along with a C++ source file named ``example.cpp`` to create an
application named ``example``.

Note that in order to choose the correct toolset, the toolset should
be made conditional on the ``instruction-set`` in the build system.
One approach for doing this would be to set project requirements in
the Jamroot.  This is required because the ``toolset`` feature cannot
set in ``usage-requirements``.

.. code::

  import xsdk ;

  xsdkws ws
    : # sources
       example.hdf
    : # requirements
      <variant>release

      <xsdk-configuration>"sleep_time psu_ttc_3"

      <xsdk-configuration>"-proc a b"

      <xsdk-configuration>"-os c d"

      <xsdk-configuration>"-lib libx e f"
    : # default-build
    : # usage-requirements
    ;

  exe example
    : # sources
      example.cpp

      ws
    : # requirements
    : # default-build
    : # usage-requirements
    ;

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

   @todo need a version

``xilkernel``

   The minimal Xilinx operating system.

   @todo need a version

``freertos``

   The FreeRTOS operating system.

   @todo need a version

Architectures
~~~~~~~~~~~~~

* ARM (``arm``)
* Microblaze (``microblaze``)

Instruction Sets
~~~~~~~~~~~~~~~~

* ``microblaze``
* ``armv7-a``
* ``armv7-r``
* ``armv8-a``

Main Target
~~~~~~~~~~~

This project will add one main target type.

``xsdkbsp ( name : source : requirements * : default-build * : usage-requirements )``

   This will place an application named ``app``, a board-support
   packaged named ``bsp``, and a hardware definition named ``hw``
   within a workspace named as defined in the rule, ``$(name)``, and
   provide ``usage-requirements`` to users of the named target.

   This will eventually run a script using ``xsct`` commands with
   values translated from Boost.Build features such as
   ``<architecture>``, ``instruction-set``, ``target-os``, and
   others.  Some representative examples of those ``xsct`` commands
   are below.

   Create the workspace (``$(build-dir)/$(name).xsdkws``) from the properties.

   .. code:: tcl

      setws $(build-dir)/$(name).xsdkws


   Generate the hardware definition (``hw``) from the hardware
   definition file specified in ``$(source)``.

   .. code:: tcl

      createhw -name hw -hwspec $(source:G=)

   Generate a board-support package (``bsp``) from the hardware
   definition (``hw``), standard Boost.Build features, and free-form
   configuration options.

   .. code::

      createbsp -name bsp -proc $(xsdk-instruction-set) -hwproject hw -os $(xsdk-os-name)

      configbsp -bsp bsp sleep_timer psu_ttc_3

      updatemss -mss  $ws/bsp/system.mss
      regenbsp -bsp bsp

      projects -build -type bsp -name bsp

   Generate an application (``app``) which provides a linker-command
   file and some options required to properly build an application.

   .. code::

      createapp -name app -app {$(xsdk-template)} -lang $(xsdk-language) -bsp bsp -proc psu_$(xsdk-instruction-set)_$(xsdk-processor-id) -hwproject hw -os $(xsdk-os-name)

Boost.Build Features
~~~~~~~~~~~~~~~~~~~~

The following Boost.Build features are used to configure the XSDK
workspace.

* ``optimization``
* ``link``
* ``architecture``
* ``instruction-set``

XSDK-related Features
~~~~~~~~~~~~~~~~~~~~~

Boost.Build will generally configure the board-support package given
Boost.Build features.  These features can be overridden using the
following toolset flags.

``xsdk-template``

   This feature indicates the application template used to generate
   the application.  The resulting main program can be used to create
   or update the actual application code.

   This defaults to an empty application.

``xsdk-configuration``

   This feature provides information for configuring a board-support
   package.

``xsdk-library``

   This feature adds Xilinx libraries to the board-support package.

``xsdk-processor-id``

   This feature assigns an application to run on a particular
   processor on the SoC.

Testing
-------

There are several test projects in the ``test`` directory.  These can
be run by running the following command.

.. code::

   cd test && b2 --verbose-test -j 8
