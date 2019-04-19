#!/usr/bin/env xsct

set buildroot [file normalize {.}]

set ws [file normalize [file join project xsct test target bin]]

proc get_xilinx_root args {
    set e [info nameofexecutable]
    set e_split [file split $e]
    set k [lsearch -exact $e_split "SDK"]
    set r_split [lrange $e_split 0 $k-1]

    return  [file normalize [join $r_split "/"]]
}

proc get_xilinx_version args {
    set e [info nameofexecutable]
    set e_split [file split $e]
    set k [lsearch -exact $e_split "SDK"]
    set r_split [lrange $e_split 0 $k-1]

    return [lindex $e_split $k+1]
}

set xilinxroot [get_xilinx_root]
set xilinxversion [get_xilinx_version]
set xilinxsdkroot [file join $xilinxroot SDK $xilinxversion]

set hwname ar_sensor_fpga
set hwversion v36-0101
set hwroot [file normalize bin]

set hdf [file join $hwroot $hwversion $hwname.hdf]

# @todo specify processor once, use it to generate the rest
set processor "psu_cortexr5_0"
set processor_type "psu_cortexr5"
set processor_name "Cortex-R5 #0"

proc assert condition {
    if {![uplevel 1 expr $condition]} {
        return -code error "Assertion failed: $condition"
    }
}

proc run-checked args {
    set ss [uplevel 1 $args]
    if {$ss != ""} then {
        return -code error "error: $ss"
        exit 1
    }
}

proc build-ws {} {
    global buildroot

    global ws

    if [file exists $ws] {
        puts "info: removing $ws"
        [file delete -force -- $ws]
    }

    [file mkdir $ws]
}

proc build-hw-and-bsp {} {
    global buildroot

    global ws

    global xilinxsdkroot

    global hdf

    global processor
    global processor_type
    global processor_name

    puts "build-hw-and-bps"

    set bsp "bsp"
    set hw "hw"
    set os "standalone"

    if [file exists $ws/hw] {
        puts "info: removing $ws/hw"
        [file delete -force -- $ws/hw]
    }
    if [file exists $ws/bsp] {
        puts "info: removing $ws/bsp"
        [file delete -force -- $ws/bsp]
    }
    run-checked setws -switch $ws

    run-checked createhw -name $hw -hwspec $hdf

    run-checked createbsp -name $bsp -proc $processor -hwproject $hw -os $os
    configbsp -bsp $bsp sleep_timer psu_ttc_3
    updatemss -mss [file join $ws $bsp system.mss]
    regenbsp -bsp $bsp

    puts " --------- BSP Configuration Begin ---------"
    puts [repo -os]
    puts [repo -libs]
    puts [repo -drivers]
    puts [getos -bsp $bsp]
    puts [configbsp -bsp $bsp -os]
    puts [configbsp -bsp $bsp archiver]
    puts [configbsp -bsp $bsp compiler]
    puts [configbsp -bsp $bsp compiler_flags]
    puts [configbsp -bsp $bsp extra_compiler_flags]
    puts [configbsp -bsp $bsp -proc]
    puts [getlibs -bsp $bsp]
    # foreach l [getlibs -bsp $bsp] {
    #     configbsp -bsp $bsp -lib $l
    # }
    puts [getdrivers -bsp $bsp]
    puts " --------- BSP Configuration End -----------"

    run-checked projects -build -type bsp -name $bsp
}

proc build-project project {
    global buildroot

    global ws

    global xilinxsdkroot

    global hdf

    global processor
    global processor_type
    global processor_name

    puts "build-project $project"

    set app $project
    set app_template {}
    set lang "c++"
    set bsp "bsp"
    set hw "hw"
    set os "standalone"

    set sourcepath [file normalize [file join test $app]]
    set librfidfpgatlpath [file normalize [file join src]]

    run-checked setws -switch $ws

    run-checked createapp -name $app -app "$app_template" -lang $lang -proc $processor -bsp $bsp -hwproject $hw -os $os

    puts " --------- Application Configuration Begin -------"
    puts [repo -apps]
    puts "assembler-flags : [configapp -app $app assembler-flags]"
    puts "build-config : [configapp -app $app build-config]"
    puts "compiler-misc : [configapp -app $app compiler-misc]"
    puts "compiler-optimization : [configapp -app $app compiler-optimization]"
    puts "define-compiler-symbols : [configapp -app $app define-compiler-symbols]"
    puts "include-path : [configapp -app $app include-path]"
    puts "libraries : [configapp -app $app libraries]"
    puts "library-search-path : [configapp -app $app library-search-path]"
    puts "linker-misc : [configapp -app $app linker-misc]"
    puts "linker-script : [configapp -app $app linker-script]"
    puts "undef-compiler-symbols : [configapp -app $app undef-compiler-symbols]"
    puts " --------- Application Configuration End ---------"

    # foreach s $sources {
    #     run-checked importsources -name $app -path $s
    # }
    run-checked importsources -name $app -path $sourcepath
    run-checked importsources -name $app -path $librfidfpgatlpath

    # run-checked configapp -app $app define-compiler-symbols RFIDFPGATL_VARIABLE_BASE_ADDRESS
    run-checked configapp -app $app include-path [file normalize [file join $ws $app src]]

    # @todo this does not report compilation errors
    run-checked projects -build -type app -name $app
}

# @todo this fails to run as a function, cut and paste to run the project
proc run-project project {
    global buildroot

    global ws

    global xilinxsdkroot

    global hdf

    global processor
    global processor_type
    global processor_name

    puts "run-project $project"

    set app $project
    set app_template {}
    set lang "c++"
    set bsp "bsp"
    set hw "hw"
    set os "standalone"

    set jtag_cable_name "*"

    set bit [file join [file dirname $hdf] [file rootname $hdf].bit]

    if {! [file exists $ws]} {
        puts "error: workspace $ws does not exist"
        exit 1
    }
    run-checked setws -switch $ws

    connect -url tcp:10.5.1.77:3121 -symbols
    # connect

    source [file normalize [file join $xilinxsdkroot scripts/sdk/util/zynqmp_utils.tcl]]

    targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ $jtag_cable_name} -index 1
    rst -system
    after 3000

    targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ $jtag_cable_name} -index 1
    reset_apu

    targets -set -nocase -filter {name =~"RPU*" && jtag_cable_name =~ $jtag_cable_name} -index 1
    clear_rpu_reset
    enable_split_mode

    targets -set -filter {jtag_cable_name =~ $jtag_cable_name && level==0} -index 0
    fpga -file $bit

    targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ $jtag_cable_name} -index 1
    loadhw -hw [file join $ws $hw system.hdf] -mem-ranges [list {  0x80000000   0xbfffffff} { 0x400000000  0x5ffffffff} {0x1000000000 0x7fffffffff}]

    configparams force-mem-access 1
    targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ $jtag_cable_name} -index 1

    source [file join $ws $hw psu_init.tcl]
    after 3000
    psu_init
    source [file normalize [file join $xilinxsdkroot scripts/sdk/util/fsbl.tcl]]
    after 1000
    psu_ps_pl_isolation_removal
    after 1000
    psu_ps_pl_reset_config
    catch {psu_protection}

    targets -set -nocase -filter {name =~"*R5*0" && jtag_cable_name =~ $jtag_cable_name} -index 1
    rst -processor
    catch {XFsbl_TcmEccInit R5_0}

    dow [file join $ws $app Debug $app.elf]

    bpadd -addr &main

    configparams force-mem-access 0

    con
}

set target ""
if {$argc == 0} then {
} elseif {$argc == 1} then {
    set target [lindex $argv 0]
} else {
    puts "error: too many arguments ($argc)."
    exit 1
}

if {$target == "all" || $target == "build"} then {
    build-ws
    build-hw-and-bsp
    build-project hello
}
