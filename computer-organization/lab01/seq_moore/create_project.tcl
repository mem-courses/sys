# vivado -mode tcl -source create_project.tcl

set project_name "seq_moore"
set target_dir "./prj"

set_param general.maxThreads 32 

create_project -force $project_name $target_dir -part xc7a100tcsg324-1

add_files -scan_for_includes -fileset sources_1 ./user/src
add_files -scan_for_includes -fileset sim_1 ./user/sim
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

start_gui