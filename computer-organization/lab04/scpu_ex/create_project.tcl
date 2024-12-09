# run: vivado -mode tcl -source create_project.tcl

set project_name "lab4-3"
set target_dir "./prj"

# set project parameters
set_param general.maxThreads 16

# create project
create_project -force $project_name $target_dir -part xc7a100tcsg324-1

# add source files
set source_dirs [list \
  "./user/src" \
  "../../public/common" \
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

# set SOC test module as top when simulation
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

# create RAM_B with D_mem.coe
create_ip -name blk_mem_gen \
  -module_name RAM_B \
  -vendor xilinx.com -library ip -version 8.4
set_property -dict [list \
  CONFIG.Memory_Type {Single_Port_RAM} \
  CONFIG.Operating_Mode_A {NO_CHANGE} \
  CONFIG.Write_Width_A {32} \
  CONFIG.Write_Depth_A {1024} \
  CONFIG.Enable_A {Always_Enabled} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File [file normalize ./user/data/D_mem.coe] \
  CONFIG.Fill_Remaining_Memory_Locations {true} \
  CONFIG.Remaining_Memory_Locations {0} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
] [get_ips RAM_B]
  # CONFIG.Read_Width_A {32} \
  # CONFIG.Use_RSTA_Pin {false} \
  # CONFIG.Port_A_Write_Rate {50} \
  # CONFIG.Port_A_Clock {100} \
  # CONFIG.Port_A_Enable_Rate {100} \

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

start_gui
