# vivado -mode tcl -source create_project.tcl

set target_dir "./vivado"
set project_name "FPGA-project"

set_param general.maxThreads 32 

create_project -force $project_name $target_dir -part xc7k160tffg676-2L

add_files -scan_for_includes -fileset sources_1 ./src/rtl
add_files -scan_for_includes -fileset sim_1 ./src/sim
# add_files -scan_for_includes -fileset constrs_1 ./src/constraints
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

start_gui