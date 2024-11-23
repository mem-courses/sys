# run: vivado -mode tcl -source create_project.tcl

set project_name "lab4-2"
set target_dir "./prj"

# set project parameters
set_param general.maxThreads 16

# create project
create_project -force $project_name $target_dir -part xc7a100tcsg324-1

# add source files
set source_dirs [list \
  "./user/src" \
  "../../public/ip" \
  "../../public/VGA" 
]
foreach source_dir $source_dirs {
  add_files -scan_for_includes -fileset sources_1 $source_dir
  foreach edf_file [glob -nocomplain -directory $source_dir *.edf] {
    puts "Reading EDIF file: $edf_file"
    read_edif $edf_file
  }
}

# add sim files and constraints
add_files -scan_for_includes -fileset sim_1 ./user/sim
add_files -scan_for_includes -fileset constrs_1 ./user/data

# set socTest_tb.v as top module when simulation
set_property top "socTest_tb" [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# create ROM_D with I_mem.coe
create_ip -name dist_mem_gen \
  -module_name ROM_D \
  -vendor xilinx.com -library ip -version 8.0
set_property -dict [list \
  CONFIG.coefficient_file [file normalize ./user/data/I_mem.coe] \
  CONFIG.depth {1024} \
  CONFIG.data_width {32} \
  CONFIG.memory_type {rom} \
  ] [get_ips ROM_D]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

start_gui
