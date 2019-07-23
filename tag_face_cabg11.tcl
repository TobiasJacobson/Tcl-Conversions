proc tag_face {modelName} {
solid_setKernel -name Parasolid
mesh_setKernel -name MeshSim
set gOptions(meshing_kernel) MeshSim
set gOptions(meshing_solid_kernel) Parasolid  
global gObjects
catch {repos_delete -obj nate }
solid_readNative -file $modelName.xmt_txt -obj nate
set faceids [nate GetFaceIds]
set numberids [ llength $faceids ]
set set_aorta 0
set set_rca 0
set set_lca2 0
set set_lca2_2 0
set set_pda 0
set set_om 0  

for {set n 0 } {$n <= $numberids-1 } {incr n} {
   set faceId [lindex $faceids $n]
   set facename [nate GetFaceAttr -attr gdscName -faceId $faceId]
# set aorta to inflow
 if { $facename == "aorta"} {

    if { $set_aorta==1} {
    nate SetFaceAttr -attr gdscName -value inflow -faceId [lindex $faceids $n ]
    }
    set set_aorta 1    
    }

 if { $facename == "lca2"} {

    if { $set_lca2==1} {
    nate SetFaceAttr -attr gdscName -value wall_occl_lca2 -faceId [lindex $faceids $n ]
    }
    set set_lca2 1    
    }


 if { $facename == "lca2_2"} {

    if { $set_lca2_2==0} {
    nate SetFaceAttr -attr gdscName -value wall_occl_lca2_2 -faceId [lindex $faceids $n ]
    }
    set set_lca2_2 1    
    }


 if { $facename == "om"} {

    if { $set_om==1} {
    nate SetFaceAttr -attr gdscName -value wall_occl_om -faceId [lindex $faceids $n ]
    }
    set set_om 1    
    }


 if { $facename == "pda"} {

    if { $set_pda==0} {
    nate SetFaceAttr -attr gdscName -value wall_occl_pda -faceId [lindex $faceids $n ]
    }
    set set_pda 1    
    }
# set rca to wall_ocl_rca
    if { $facename == "rca"} {
    nate SetFaceAttr -attr gdscName -value wall_occl_rca -faceId [lindex $faceids $n ]
    }

# set rca to wall_ocl_rca
  if { $facename == "rca"} {
    nate SetFaceAttr -attr gdscName -value wall_occl_rca_out -faceId [lindex $faceids $n ]
    }

    
  if { $facename == "lca"} {
    nate SetFaceAttr -attr gdscName -value wall_occl_lca -faceId [lindex $faceids $n ]
    }


  if { $facename == "lca2_prox"} {
    nate SetFaceAttr -attr gdscName -value wall_occl_lca2_prox -faceId [lindex $faceids $n ]
    }
 
  if { $facename == "lca1"} {
    nate SetFaceAttr -attr gdscName -value wall_occl_lca1 -faceId [lindex $faceids $n ]
    }
    }

    puts "Save SolidModel."
    nate WriteNative -file $modelName
}

