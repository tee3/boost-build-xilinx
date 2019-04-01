#!/usr/bin/env xsct

if {$argc != 1} then {
    puts "usage: $argv0 <workspace>"
    exit 1
}

set ws [lindex $argv 0]
set app app

if {! [file exists $ws]} {
    puts "error: workspace $ws does not exist"
    exit 1
}
setws $ws

puts "assembler-flags : [configapp -app $app -info assembler-flags]"
puts "build-config : [configapp -app $app -info build-config]"
puts "compiler-misc : [configapp -app $app -info compiler-misc]"
puts "compiler-optimization : [configapp -app $app -info compiler-optimization]"
puts "define-compiler-symbols : [configapp -app $app -info define-compiler-symbols]"
puts "include-path : [configapp -app $app -info include-path]"
puts "libraries : [configapp -app $app -info libraries]"
puts "library-search-path : [configapp -app $app -info library-search-path]"
puts "linker-misc : [configapp -app $app -info linker-misc]"
puts "linker-script : [configapp -app $app -info linker-script]"
puts "undef-compiler-symbols : [configapp -app $app -info undef-compiler-symbols]"

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