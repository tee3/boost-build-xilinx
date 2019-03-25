#!/usr/bin/env xsct

if {$argc != 1} then {
    puts "usage: $argv0 <workspace>"
    exit 1
}

set ws [file normalize [lindex $argv 0]]

if {! [file exists $ws]} {
    puts "error: workspace $ws does not exist"
    exit 1
}
setws $ws

# repo

### @todo do a regexp-based parse
### set applications [list]
### foreach line [lrange [split [repo -apps] "\n"] 3 end] {
###     if {[scan $line "%s%s" name processor operating_system] != 3} then {
###         continue
###     }
###
###     lappend applications $name
### }
puts "[repo -apps]"

set operating_systems [list]
foreach line [lrange [split [repo -os] "\n"] 3 end] {
    if {[scan $line "%s%s%s" name version processor] != 3} then {
        continue
    }

    lappend operating_systems $name
}
puts "operating_systems: $operating_systems"

set libraries [list]
foreach line [lrange [split [repo -libs] "\n"] 3 end] {
    if {[scan $line "%s%s" name version] != 2} then {
        continue
    }

    lappend libraries $name
}
puts "libraries: $libraries"

# @todo do a regexp-based parse
puts "[repo -drivers]"

# app

puts "assembler-flags : [configapp -app app -info assembler-flags]"
puts "build-config : [configapp -app app -info build-config]"
puts "compiler-misc : [configapp -app app -info compiler-misc]"
puts "compiler-optimization : [configapp -app app -info compiler-optimization]"
puts "define-compiler-symbols : [configapp -app app -info define-compiler-symbols]"
puts "include-path : [configapp -app app -info include-path]"
puts "libraries : [configapp -app app -info libraries]"
puts "library-search-path : [configapp -app app -info library-search-path]"
puts "linker-misc : [configapp -app app -info linker-misc]"
puts "linker-script : [configapp -app app -info linker-script]"
puts "undef-compiler-symbols : [configapp -app app -info undef-compiler-symbols]"

puts "assembler-flags : [configapp -app app assembler-flags]"
puts "build-config : [configapp -app app build-config]"
puts "compiler-misc : [configapp -app app compiler-misc]"
puts "compiler-optimization : [configapp -app app compiler-optimization]"
puts "define-compiler-symbols : [configapp -app app define-compiler-symbols]"
puts "include-path : [configapp -app app include-path]"
puts "libraries : [configapp -app app libraries]"
puts "library-search-path : [configapp -app app library-search-path]"
puts "linker-misc : [configapp -app app linker-misc]"
puts "linker-script : [configapp -app app linker-script]"
puts "undef-compiler-symbols : [configapp -app app undef-compiler-symbols]"

# bsp

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

# hw

# @todo is there anything here
