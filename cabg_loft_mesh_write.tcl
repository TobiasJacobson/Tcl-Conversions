###################################################################################################
#                           GENERATION OF SOLID MODEL 04-05-10                                    #
###################################################################################################
source createpreop_AM.tcl
source ../tag_face_cabg11.tcl
proc GenSolid { } {
global nmodel_ii
global model_type
set model_type indiv2
set scaleFactor 1.0; # scale factor for final geometry

if {$model_type=="y"} {
set allGroups [list lsubcl3 rcca rima dia_mod_svg1 dia_mod_svg2 rca4 lca2_2 om_bif om rsubcl1 rsubcl_new pda rsubcl2 om1 rsubcl3 om2 om3 rca1_1 lsubcl2_1 rca1_2 lca om4 lca1 lca2_prox lca2 lima lca2_2_1 lcca rsubcl2_1 lsubcl_new lsubcl1 rca aorta lsubcl2 rca1]
 } elseif {$model_type=="seq"} {
 set allGroups [list lsubcl3 rcca rima svg1_temp rca4 lca2_2 om_bif om rsubcl1 rsubcl_new pda rsubcl2 om1 rsubcl3 om2 om3 rca1_1 lsubcl2_1 rca1_2    lca om4 lca1 lca2_prox lca2 lima diamond lca2_2_1 lcca rsubcl2_1 lsubcl_new lsubcl1 rca aorta lsubcl2 rca1]
	} elseif {$model_type=="indiv2"} {
	set allGroups [list lsubcl3 rcca rima svg1_temp svg2_temp rca4 lca2_2 om_bif om rsubcl1 rsubcl_new pda rsubcl2 om1 rsubcl3 om2 om3 		rca1_1 lsubcl2_1 rca1_2 lca om4 lca1 lca2_prox lca2 lima lca2_2_1 lcca rsubcl2_1 lsubcl_new lsubcl1 rca aorta lsubcl2 rca1]
	}

set top [file join [pwd] ]

foreach groupName $allGroups {
set groupAddress($groupName) $top/$groupName
}
# ------- BOILERPLATE : INCLUDE GLOBAL VARIABLES

global gRen3d
global gRen3dCopies
global gPathBrowser
global gOptions
global gFilenames
global symbolicName
global createPREOPgrpKeptSelections
global createPREOPgrpCurLB set gRen3dCopies 1
global gObjects
global gLoftedSolids

# ------- SET SOLID AND MESH KERNELS
# From KenWang thesis can look at setKernel commands --------------------
solid_setKernel -name Parasolid
mesh_setKernel -name MeshSim
set gOptions(meshing_kernel) "MeshSim"
set gOptions(meshing_solid_kernel) "Parasolid"
# Append adds temp to given variable --------------------
append temp cabg11_
append temp $model_type
append temp _
append temp $nmodel_ii
set ::solidName $temp
set ::blendFile [ file join [pwd] .. cabg11_indiv2]

# -------

foreach groupName $allGroups {
  # Catch 'traps' the returned values --------------------
	catch { group_delete $groupName }

# Reading preconstructed profiles
	if { $groupAddress($groupName) != "" } {
		group_readProfiles $groupName $groupAddress($groupName)
	} else {
		group_create $groupName
	}
}


# ---- RENDERING BOILERPLATE
set gPathBrowser(ren) {gRenWin_3D_ren1}
set gPathBrowser(align_mtd_radio) {dist}
set gPathBrowser(solid_opacity) {1}
set gPathBrowser(solid_sample) {20}
set gRen3d [vis_gRenWin_3D]
set gPathBrowser(use_vtkTkRenderWidget) {1}
vis_nodeSize $gRen3d 0.1

# Lofting each group
foreach groupName $allGroups {
  # Outputs to console and sets new gPath 
	puts $groupName
	set gPathBrowser(currGroupName) $groupName
	nateAFLB
}

# Connecting_groups
set createPREOPgrpKeptSelections $allGroups
set gFilenames(preop_solid_file) $::solidName.xmt_txt
catch {createPREOPmodelCreateModel_AM} msg
puts $msg
set ignore 0
if { $msg == "union error" } {
	set ignore 1
	return $ignore
}

# CreatePREOPmodelViewModel
createPREOPmodelSaveModel

puts "Save SolidModel."
preop_solid WriteNative -file $::solidName
preop_solid
puts "Tagging faces."
#catch {repos_delete -obj nate }
#solid_readNative -file $::solidName.xmt_txt -obj nate
set faceids [preop_solid GetFaceIds]


# --------------- BLEND ME PLEASE --------------

puts "Blend SolidModel."
#ShowWindow.guiBLENDS
set gobjects(preblend_solid) $::solidName
set gobjects(blend_solid) $::solidName
append gobjects(blend_solid) _blended
set gFilenames(blend_file) $::blendFile.blends
set gFilenames(blend_solid_file) $gobjects(blend_solid)
set gFilenames(preblend_solid_file) $::solidName.xmt_txt


# AV - commented due to blending error -_-
 guiFNMloadSolidModel preblend_solid_file preblend_solid
 guiBLENDSloadBLENDfile
 guiBLENDSblend
 guiBLENDSsaveModel
# /AV


file delete $::blendFile.blends

puts "Scaling the model."
catch {repos_delete -obj $gobjects(blend_solid)}
solid_readNative -file $gobjects(blend_solid).xmt_txt -obj $gobjects(blend_solid)
$gobjects(blend_solid) Scale -factor $scaleFactor
$gobjects(blend_solid) WriteNative -file abgsc
catch [ file delete -force $gobjects(blend_solid).xmt_txt ]
file copy -force $::solidName.xmt_txt [file join [pwd] ..]
cd ..
tag_face $::solidName

# ------------- IF YOU GET PAST THIS POINT, ON TO MESHING

set dir [file join [pwd]]
set projectname myfavabcdname

puts "Creating mesh."
set mssfile [file join $dir "$::solidName.mss"]
# Create meshsim style script file
set fp [open $mssfile w]
fconfigure $fp -translation lf
puts $fp "msinit"
puts $fp "logon $::solidName.logfile"
puts $fp "loadModel $::solidName.xmt_txt"
puts $fp "newMesh"
puts $fp "option surface optimization 1"
puts $fp "option surface smoothing 3"
puts $fp "option volume optimization 1"
puts $fp "option volume smoothing 1"
puts $fp "option surface 1"
puts $fp "option volume 1"
puts $fp "gsize absolute 0.11"
puts $fp "generateMesh"
puts $fp "writeMesh $::solidName.sms sms 0"
puts $fp "writeStats $::solidName.sts"
puts $fp "deleteMesh"
puts $fp "deleteModel"
puts $fp "logoff"
close $fp

catch {repos_delete -obj mymesh}
mesh_readMSS $mssfile mymesh

set use_ascii_format 0

set guiMMvars(meshControlAttributes) {}


set gFilenames(atdb_solid_file) [file join $dir $::solidName.xmt_txt]
set gFilenames(atdb_solid) $projectname

set $gFilenames(mesh_file) [file join $dir mesh_$projectname.sms ]

set gObjects(mesh_object) mymesh
catch {repos_delete -obj mymesh}
catch {repos delete -obj $gObjects(mesh_object_pd)}
mesh_readMSS $mssfile mymesh


# --- WRITE MESH

guiFNMloadSolidModel atdb_solid_file atdb_solid

set modelobj $gObjects(atdb_solid)

set prefix mesh-complete
set msh_outdir [file join $dir mesh-complete ]

mesh_writeCompleteMesh mymesh $modelobj $prefix $msh_outdir
#file rename -force $::solidName.sms

return 1

}
