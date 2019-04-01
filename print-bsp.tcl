#!/usr/bin/env xsct

if {$argc != 1} then {
    puts "usage: $argv0 <workspace>"
    exit 1
}

set ws [lindex $argv 0]

if {! [file exists $ws]} {
    puts "error: workspace $ws does not exist"
    exit 1
}
setws $ws

puts "[getos -bsp bsp]"
puts "[configbsp -bsp bsp -os]"
set os_parameters [list]
foreach line [lrange [split [configbsp -bsp bsp -os] "\n"] 3 end] {
    if {[scan $line "%s%s" name value] != 2} then {
        continue
    }

    lappend os_parameters $name
}
puts "os_parameters: $os_parameters"
set archiver [configbsp -bsp bsp archiver]
puts "$archiver"
set compiler [configbsp -bsp bsp compiler]
puts "$compiler"
set compiler_flags [configbsp -bsp bsp compiler-flags]
puts "$compiler_flags"
set extra_compiler_flags [configbsp -bsp bsp extra-compiler-flags]
puts "$extra_compiler_flags"
set processor [configbsp -bsp bsp -proc]
puts "$processor"
foreach line [lrange [split [getlibs -bsp bsp] "\n"] 3 end] {
    if {[scan $line "%s%s" name version] != 2} then {
        continue
    }

    puts "library $name:"
    puts "[configbsp -bsp bsp -lib $name]"
}
puts "[getdrivers -bsp bsp]"
