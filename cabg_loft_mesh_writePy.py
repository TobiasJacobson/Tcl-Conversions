import createpreop_AM.tcl
# import createpreop_AMPy.py
import ../tag_face_cabg11.tcl
# import ../tag_face_cabg11Py.py
import shutil
import os
import sys

def GenSolid():
    nmodel_ii = 0
    model_type = 'indiv2'
    scaleFactor = 1.0 # scale factor for final geometry

    if model_type == 'y':
        allGroups = [lsubcl3, rcca, rima, dia_mod_svg1, dia_mod_svg2, rca4, lca2_2, om_bif, om, rsubcl1, rsubcl_new, pda, rsubcl2, om1, rsubcl3, om2, om3, rca1_1, lsubcl2_1, rca1_2, lca, om4, lca1, lca2_prox, lca2, lima, lca2_2_1, lcca, rsubcl2_1, lsubcl_new, lsubcl1, rca, aorta, lsubcl2, rca1]
    elif model_type == 'seq':
        allGroups = [lsubcl3, rcca, rima, svg1_temp, rca4, lca2_2, om_bif, om, rsubcl1, rsubcl_new, pda, rsubcl2, om1, rsubcl3, om2, om3, rca1_1, lsubcl2_1, rca1_2, lca, om4, lca1, lca2_prox, lca2, lima, diamond, lca2_2_1, lcca, rsubcl2_1, lsubcl_new, lsubcl1, rca, aorta, lsubcl2, rca1]
    elif model_type == 'indiv2':
    	allGroups = [lsubcl3, rcca, rima, svg1_temp, svg2_temp, rca4, lca2_2, om_bi,f om, rsubcl1, rsubcl_new, pda, rsubcl2, om1, rsubcl3, om2, om3, rca1_1, lsubcl2_1, rca1_2, lca, om4, lca1, lca2_prox, lca2, lima, lca2_2_1, lcca, rsubcl2_1, lsubcl_new, lsubcl1, rca, aorta, lsubcl2, rca1]

    top = os.getcwd()

    for groupName in allGroups:
        groupAddress[groupName] = top + '/' + groupName

    # ------- BOILERPLATE : INCLUDE GLOBAL VARIABLES
    gRen3d = None # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Complete initialization of this
    gRen3dCopies = None # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Complete initialization of this
    gPathBrowser = []
    gOptions = []
    gFilenames = []
    symbolicName = ''
    createPREOPgrpKeptSelections = []
    # createPREOPgrpCurLB set gRen3dCopies 1 # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Need more clarification
    gObjects = []
    gLoftedSolids = [] # Not used anywhere I can see

    # ------- SET SOLID AND MESH KERNELS
    solid_setKernel('Parasolid')
    mesh_setKernel('MeshSim')
    gOptions[meshing_kernel] = 'MeshSim'
    gOptions[meshing_solid_kernel] = 'Parasolid'
    temp = ''
    temp.append(cabg11_)
    temp.append(model_type)
    temp.append(_)
    temp.append(nmodel_ii)
    solidName = temp
    blendFile = top +  '/cabg11_indiv2'
    # -------

    # Reading preconstructed profiles
    for groupName in allGroups:
        try:
            group_delete(groupName)
        else:
            print('group_delete cast an error')
        if groupAddress[groupName] != '':
            group_readProfiles(groupAddress[groupName])
        else:
            group_create(groupName)

    # ---- RENDERING BOILERPLATE
    gPathBrowser[ren] = gRenWin_3D_ren1
    gPathBrowser[align_mtd_radio] = dist
    gPathBrowser[solid_opacity] = 1
    gPathBrowser[solid_sample] = 20
    gRen3d = vis_gRenWin_3D
    gPathBrowser[use_vtkTkRenderWidget] = 1
    vis_nodeSize $gRen3d 0.1 # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Need more clarification

    # Lofting each group
    for groupName in allGroups:
        print(groupName)
        gPathBrowser[currGroupName] = groupName
        nateAFLB() # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Find alternative to nateAFLB in openSource simVascular, or could I still use it since its only used by Jongmin??

    # Connecting_groups
    createPREOPgrpKeptSelections = allGroups
    gFilenames[preop_solid_file] = solidName.xmt_txt
    msg = ''
    try:
        createPREOPmodelCreateModel_AM = msg
    except:
        print('createPREOPmodelCreateModel_AM cast an error')
    print(msg)
    set ignore 0
    if msg == "union error":
    	ignore = 1
    	return ignore

    # CreatePREOPmodelViewModel
    createPREOPmodelSaveModel()

    print("Save SolidModel.")
    preop_solid = WriteNative(solidName)
    preop_solid()
    print("Tagging faces.")
    faceids[preop_solid] = GetFaceIds

    # --------------- BLEND ME PLEASE --------------
    print("Blend SolidModel.")
    #ShowWindow.guiBLENDS
    gobjects[preblend_solid] = solidName
    gobjects[blend_solid] = solidName
    gobjects[blend_solid].append(_blended)
    gFilenames[blend_file] = blendFile +'.blends'
    gFilenames[blend_solid_file] = gobjects(blend_solid)
    gFilenames[preblend_solid_file] = solidName +'.xmt_txt'

    # AV - commented due to blending error -_-
     # guiFNMloadSolidModel preblend_solid_file preblend_solid
     # guiBLENDSloadBLENDfile
     # guiBLENDSblend
     # guiBLENDSsaveModel
    # /AV

    os.remove(blend_solid+'.belnds')

    print("Scaling the model.")
    try:
        repos_delete(gobjects[blend_solid])
    except:
        print('repos_delete cast an error')
    file = gobjects(blend_solid) + '.xmt_txt'
    obj = gobjects(blend_solid)
    solid_readNative(file, obj)
    $gobjects(blend_solid) Scale(scaleFactor) # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Need more clarification
    $gobjects(blend_solid) Scale -factor $scaleFactor
    $gobjects(blend_solid) WriteNative(abgsc) # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Need more clarification
    $gobjects(blend_solid) WriteNative -file abgsc

    try:
        os.remove(gobjects(blend_solid) +'xmt_txt')
    except:
        print('os.remove cast an error')
    shutil.copy(solidName + '.xmt_txt',top)
    os.chdir('..')
    # tag_face $::solidName # skip tag faces

    # Used adaptive meshing (Not available in open source simV), so focus on the solid model for now ------------------------------------------------------------------------------------------------------------------------


# end of GenSolid


############################################
#                   Main                   #
############################################
import shutil
import os
import sys

GenSolid()
