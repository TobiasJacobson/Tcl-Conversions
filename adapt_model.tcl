proc adapt_model {modelName meshName adapt_tstep nadapt_ii} {

solid_setKernel -name Parasolid
mesh_setKernel -name MeshSim
set gOptions(meshing_kernel) MeshSim
set gOptions(meshing_solid_kernel) Parasolid
global gObjects
global gFilenames
set adaptobject /new/adapt/object
catch {repos_delete -obj $adaptobject}
set out_mesh_dir [file join [pwd] .. adapt_$nadapt_ii/mesh-complete/]
file mkdir $out_mesh_dir
set out_mesh_file [file join [pwd] .. adapt_$nadapt_ii/adapt_$nadapt_ii.sms]
set solid_file [file join [pwd] .. $modelName.xmt_txt]
if {$nadapt_ii == 1}
{
set sms_mesh_file  [file join [pwd] .. $meshName.sms]
}
else
{
set temp [expr $nadapt_ii-1 ]
set sms_mesh_file  [file join [pwd] .. adapt_$temp/adapt_$temp.sms]
}
set vtu_mesh_file  [file join [pwd] "all_results.vtu"]
set discreteFlag 0
set adaptorsphere {-1 0 0 0 0}
set maxRefineFactor 0.01
set maxCoarseFactor 0.13
set reductionRatio 0.4
if {$nadapt_ii == 1}
{
set solution   [file join [pwd] "restart.$adapt_tstep.1"]
set error_file [file join [pwd] "restart.$adapt_tstep.1"]
}
else
{
set solution   [file join [pwd] "restart.$adapt_tstep.0"]
set error_file [file join [pwd] "restart.$adapt_tstep.0"]
}
set out_solution [file join [pwd] "outrestart.$adapt_tstep.1"]
set stepNumber $adapt_tstep
set gOptions(meshing_kernel) MeshSim
set gOptions(meshing_solid_kernel) Parasolid
set gFilenames($solid_file) $solid_file
puts "Running the adaptor..."
adapt_newObject -result $adaptobject
$adaptobject CreateInternalMeshObject -meshfile $sms_mesh_file -solidfile $solid_file
$adaptobject LoadMesh -file $vtu_mesh_file
$adaptobject SetAdaptOptions -flag strategy -value 2
$adaptobject SetAdaptOptions -flag metric_option -value 2
$adaptobject SetAdaptOptions -flag ratio -value $reductionRatio
$adaptobject SetAdaptOptions -flag hmin -value $maxRefineFactor
$adaptobject SetAdaptOptions -flag hmax -value $maxCoarseFactor
$adaptobject SetAdaptOptions -flag instep -value 0
$adaptobject SetAdaptOptions -flag outstep -value $adapt_tstep
$adaptobject SetMetric -input $vtu_mesh_file
$adaptobject SetupMesh
$adaptobject RunAdaptor
$adaptobject GetAdaptedMesh
$adaptobject TransferSolution
$adaptobject WriteAdaptedSolution -file $out_solution
$adaptobject WriteAdaptedMesh -file $out_mesh_file
set mesh /adapt/internal/meshobject
#Read model file as a solid object to write out meshsim mesh related files
catch {repos_delete -obj $modelName}
solid_readNative -file $solid_file -obj $modelName
mesh_writeCompleteMesh $mesh $modelName mesh-complete $out_mesh_dir
cd $out_mesh_dir/..
}
