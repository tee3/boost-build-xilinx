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
set os_parameters [list]
foreach line [lrange [split [configbsp -bsp bsp -os] "\n"] 3 end] {
    if {[scan $line "%s%s" name value] != 2} then {
        continue
    }

    lappend os_parameters $name
}
puts "os_parameters: $os_parameters"
set archiver [configbsp -bsp bsp archiver]
set processor_parameters [list]
foreach line [lrange [split [configbsp -bsp bsp -proc] "\n"] 3 end] {
    if {[scan $line "%s%s" name value] != 2} then {
        continue
    }
    lappend processor_parameters $name
}
puts "processor_parameters: $processor_parameters"
foreach p $processor_parameters {
    set value [configbsp -bsp bsp $p]
    puts "$p: $value"
}
set libraries [list]
foreach line [lrange [split [getlibs -bsp bsp] "\n"] 3 end] {
    if {[scan $line "%s%s" name version] != 2} then {
        continue
    }

    lappend libraries $name
}
foreach library $libraries {
    set parameters [list]
    foreach line [lrange [split [configbsp -bsp bsp -lib $library] "\n"] 3 end] {
        if {[scan $line "%s%s" name value] != 2} then {
            continue
        }

        lappend parameters $name
    }

    puts "library $library parameters: $parameters"
}

puts "[getdrivers -bsp bsp]"
