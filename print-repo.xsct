#!/usr/bin/env xsct

# @todo this needs a lot more effort to parse
# set applications [list]
# foreach line [lrange [split [repo -apps] "\n"] 3 end] {
#     if {[scan $line "%s%s" name processor operating_system] != 3} then {
#         continue
#     }
# 
#     lappend applications $name
# }
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

puts "[repo -drivers]"
