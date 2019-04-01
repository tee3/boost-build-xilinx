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
