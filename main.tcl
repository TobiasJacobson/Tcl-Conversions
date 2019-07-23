# <^>
#-----
#(~ ~)
# /(`
#   )
# -------------------- General Notes -------------------- #
# For '$' Tcl treats what follows as a variable name instead of its actual value

# ------------------------------------------------------- #


# Evaluates a file or resource as a Tcl script --------------------
source adapt_model.tcl
# Set is assigning values --------------------
# number of models
set nmodel 1
# number of adaptations
set nadapt 3
# File join is creating the path for file --------------------
# File path to svpre, svsolver and svpost
set svpre [file join / home jongmin simvascular svpre]
set svsolver [file join / home jongmin Downloads svSolver-master BuildWithMake Bin svsolver-gcc-gfortran-openmpi.exe]
set svpost [file join / home jongmin simvascular svpost]
# simulation time step for mesh adaptation
set sim_tstep 5
# list of diameters of vein graft to adapt: currently not used
set dia_list [list 0.3 0.5 0.7 0.9]
# ratio between original diamater to the adapted one for svg1
set svg1_orig_dia 0.35
# for svg2
set svg2_orig_dia 0.29
# Sets global acces for variables below --------------------
global nmodel_ii
global nsim_ii
global nadapt_ii

set nsim_ii 0

# Same as any normal for loop --------------------
# Loop1 starts
for {set nmodel_ii 1} {$nmodel_ii<=$nmodel} {incr nmodel_ii} {puts $nmodel_ii

# Generate subdirectories: for different number of models. Copy and paste necessary files to the subdirectories.
set ::modelFolderName model_$nmodel_ii
file mkdir $modelFolderName
set ::top_sim_dir [pwd]
set ::rundir [file join [pwd] $modelFolderName]
# Replicates file with the name of the file join --------------------
file copy -force groups [file join [pwd] $modelFolderName]
file copy -force cabg11_rigid.svpre [file join [pwd] $modelFolderName]
file copy -force solver.inp [file join [pwd] $modelFolderName]
file copy -force cabg_loft_mesh_write.tcl [file join [pwd] $modelFolderName groups]
file copy -force group_tweaker.py $rundir
file copy -force cabg11_indiv2.blends [file join [pwd] $modelFolderName]
# -------------------- tag_face_cabg11 call isn't needed -------------------- #
file copy -force tag_face_cabg11.tcl [file join [pwd] $modelFolderName]
# --------------------------------------------------------------------------- #
file copy -force cabg11_rigid.svpre [file join [pwd] $modelFolderName]
file copy -force numstart.dat [file join [pwd] $modelFolderName]
file copy -force adapt_model.tcl [file join [pwd] $modelFolderName]
file copy -force GenBC [file join [pwd] $modelFolderName]
set ::solidName cabg11_y_$nmodel_ii
# Normal change directory --------------------
cd $rundir
set a 0.5
set b 0.5

# Expr --> concatenates, evaluates, and returns --------------------
# Set the scaling factor for the segmentations
set temp [expr $nmodel_ii-1]
set target_dia [lindex $dia_list $temp]
# Outputs to console --------------------
puts "target_dia = $target_dia"
set scale_svg1 [expr $target_dia/$svg1_orig_dia]
set scale_svg2 [expr $target_dia/$svg2_orig_dia]
set scale_svg [expr $a*$nmodel_ii+$b]
puts "scale_svg = $scale_svg"
# Execute python script that changes that scales the segmentation with the scaling factor
exec python2.7 group_tweaker.py svg1 $scale_svg
exec python2.7 group_tweaker.py svg2 $scale_svg
cd [file join $rundir groups]
source cabg_loft_mesh_write.tcl

# Now create a 3-D model by lofting segmentations. Look for the "cabg_loft_mesh_write.tcl" to refer GenSolid.
# Function call from cabg_loft_mesh_write.tcl --------------------
GenSolid
# Move back to model_$nmodel_ii
# Normal change directory --------------------
cd $rundir

# Up to here the model generation is done. Now it goes to the meshing.

# Used adaptive meshing, so focus on the solid model for now ------------------------------------------------------------------------------------------------------------------------

# start for the Loop2 for sim and adaptation: Comment out when you don't mesh the model.
for {set nadapt_ii 1} {$nadapt_ii<=$nadapt} {incr nadapt_ii} {puts $nadapt_ii
file copy -force ../cabg11_rigid.svpre [pwd]
exec $svpre cabg11_rigid.svpre
puts $nsim_ii
set simdir simfiles_$nsim_ii
if {$nadapt_ii > 1} {
   set simdir [file join [pwd] .. simfiles_$nsim_ii]
}
file mkdir $simdir
file copy -force ../solver.inp $simdir
file copy -force restart.0.1 $simdir
file copy -force geombc.dat.1 $simdir
file copy -force ../numstart.dat $simdir
file copy -force ../GenBC $simdir
file copy -force ../adapt_model.tcl $simdir
cd $simdir

if {$nadapt_ii == 1} {
 exec mpiexec -n 1 $svsolver
 exec $svpost -start $sim_tstep -stop $sim_tstep -vtu all_results.vtu -vtkcombo
 adapt_model $solidName $solidName $sim_tstep $nadapt_ii
 } else {
 exec mpiexec -n 2 $svsolver
 cd 2-procs_case
 exec $svpost -start $sim_tstep -stop $sim_tstep -ph -vtu all_results.vtu -vtkcombo
 file copy -force restart.$sim_tstep.0 ../
 file copy -force all_results.vtu ../
 cd ..
 set temp [expr $nadapt_ii-1 ]
 adapt_model $solidName adapt_$temp $sim_tstep $nadapt_ii
 }

set nsim_ii [expr $nsim_ii+1]
}
# The Loop 2 ends
cd $top_sim_dir
}
# The Loop1 ends
#
#
##file mkdir $::ii
#
##}
#
##end of while loop on nsims
#
##close $f1
#
#
## <^>
##-----
##(~ ~)
## /(`
##   )
#
