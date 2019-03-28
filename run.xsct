#!/usr/bin/env xsct

source xilinx.xsct

if {$argc != 3} then {
    puts "usage: $argv0 <workspace> <fpga-name> <program>"
    exit 1
}

set xilinxroot [get_xilinx_root]
set xilinxversion [get_xilinx_version]
set xilinxsdkroot [file join $xilinxroot SDK $xilinxversion]

set ws [file normalize [lindex $argv 0]]
set fpga_name [lindex $argv 1]
set program [file normalize [lindex $argv 2]]

set hw hw

set hdf [file join $ws $hw system.hdf]
set bit [file join $ws $hw $fpga_name.bit]

set jtag_cable_name "*"

if {! [file exists $ws]} {
    puts "error: workspace $ws does not exist"
    exit 1
}
setws -switch $ws

connect

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
loadhw -hw $hdf -mem-ranges [list {  0x80000000   0xbfffffff} { 0x400000000  0x5ffffffff} {0x1000000000 0x7fffffffff}]

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

dow $program

bpadd -addr &main

configparams force-mem-access 0

con
