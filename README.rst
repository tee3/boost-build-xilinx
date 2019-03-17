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

This project will add several target types.

``xsdkhw``

   Generate a hardware definitions from an ``.hdf`` file.

   This will run the following ``xsct`` commands to generate a
   hardware definition named ``example-hw`` from a hardware
   specification named ``example.hdf``.

   .. code:: tcl

      createhw -name example-hw -hwspec example.hdf

``xsdkbsp``

   Generate a board-support package given an ``xsdkhw``
   and free-form configuration options.  This will also print a file
   with all configuration options.

   This will run the following ``xsct`` commands to generate a
   board-support package named ``example-bsp`` from a hardware
   definition named ``example-hw`` for Boost.Build features such as
   ``architecture`` and ``target-os``.

   .. code::

      # @todo note that architecture and target-os must be translated
      createbsp -name example-bsp -proc $(architecture) -hwproject example-hw -os $(target-os)

      # @todo and whatever else are added
      configbsp -bsp example-bsp sleep_timer psu_ttc_3

      updatemss -mss  $(ws)/example-bsp/system.mss
      regenbsp -bsp example-bsp

      projects -build -type bsp -name example-bsp

Boost.Build will generally configure the board-support package given
Boost.Build features.  These features can be overridden using the
following toolset flags.

``xsdk-configuration``

   This feature provides information for configuring a board-support
   package.

Target Operating Systems
~~~~~~~~~~~~~~~~~~~~~~~~

``elf``

   The ``standalone`` Xilinx operating system.

   Note that ``elf`` is the standard Boost.Build name for a bare-metal
   program.

   @todo need a version

``xilsystem``

   The minimal Xilinx operating system.

   @todo need a version

``freertos``

   The FreeRTOS operating system.

   @todo need a version

Example
-------

The goal is to able to do something like the following.

.. code::

  import xsdk ;

  # @todo require a concept of workspace ... i think everything should go into a single workspace ...

  xsdkhw example-hw
    : # sources
       example.hdf
    : # requirements
    : # default-build
    : # usage-requirements
    ;

  xsdkbsp example-bsp
    : # sources
       example-hw
    : # requirements
      <variant>release

      <xsdk-configuration>"sleep_time psu_ttc_3"
      <xsdk-configuration>"-proc a b"
      <xsdk-configuration>"-os c d"
      <xsdk-configuration>"-lib libx e f"
    : # default-build
    : # usage-requirements
    ;

  exe example-app
    : # sources
      main.cpp

      example-bsp
    : # requirements
    : # default-build
    : # usage-requirements
    ;

Testing
-------

.. code::

   cd test && b2 --verbose-test -j 8
