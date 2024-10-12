# vivado -mode tcl -source create_project.tcl

set project_name "lab2"
set target_dir "./prj"

set_param general.maxThreads 16

create_project -force $project_name $target_dir -part xc7a100tcsg324-1

add_files -scan_for_includes -fileset sources_1 ./user/src
add_files -scan_for_includes -fileset sim_1 ./user/sim
add_files -scan_for_includes -fileset constrs_1 ./user/data

set edf_files [glob -nocomplain -directory "./user/src" *.edf]
foreach edf_file $edf_files {
    read_edif $edf_file
}

create_ip -name dist_mem_gen -vendor xilinx.com -library ip -version 8.0 -module_name ROM_D
set_property -dict [list \
  CONFIG.coefficient_file [file normalize ./user/data/I_mem.coe] \
  CONFIG.depth {1024} \
  CONFIG.data_width {32} \
  CONFIG.memory_type {rom} \
] [get_ips ROM_D]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

start_gui
