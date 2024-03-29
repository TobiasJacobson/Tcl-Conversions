# Objective: Convert the lab simVascular Tcl scripts to python
# Basis: Jongmin's Tcl scripts for patient 1 called main.tcl

def main():
    # import adapt_model.tcl
    import adapt_modelPy

    # Number of models
    numModels = 1
    # Number of adaptations
    numAdaptations = 3

    # svpre = '/home/jongmin/simvascular/svpre'
    svpre = '/usr/local/sv/svsolver/2019-01-19/svpre'
    # svsolver = '/home/jongmin/Downloads/svSolver-master/BuildWithMake/Bin/svsolver-gcc-gfortran-openmpi.exe'
    svsolver ='/usr/local/sv/svsolver/2019-01-19/svsolver'
    # svpost = '/home/jongmin/simvascular/svpost'
    svpost = '/usr/local/sv/svsolver/2019-01-19/svpost'

    # Simulation timestep
    simTimeTest = 5

    # List of diameters --- Diameters of vein graft to adapt: currently not used
    dia_list = [0.3, 0.5, 0.7, 0.9]

    # ratio between original diamater to the adapted one for svg1 and svg2
    svg1_orig_dia = 0.35
    svg2_orig_dia = 0.28

    nmodel_ii = 0
    # nadapt_ii = ?? # Only used in the adaptive meshing part, so ignore
    nsim_ii = 0

    # for i = nmodel_ii[1] -- while nmodel_ii < numModels -- increment nmodel_ii
    #     print(nmodel_ii)
    for i in range(1, numModels+1):
        nmodel_ii += 1
        modelFolderName = 'model_' + str(nmodel_ii)
        dirpath = '/Users/tobiasjacobson/Documents/TCL(Jongmin)'
        path = dirpath + '/' + modelFolderName
        os.mkdir(path)
        top_sim_dir = dirpath
        rundir = dirpath + modelFolderName
        # Copy all files from cwd
        destination = dirpath + modelFolderName
        for file in dirpath:
            shutil.copy(os.path.join(dirpath,file),path)
        solidName = 'cabg11_y_' + str(nmodel_ii)
        os.chdir(str(rundir))
        a = 0.5
        b = 0.5

        temp = int(nmodel_ii)-1
        targetDiameter = dia_list[temp]

        print('target_dia =' + targetDiameter)
        scale_svg1 = target_dia/svg1_orig_dia
        scale_svg2 = target_dia/svg2_orig_dia
        scale_svg = a*nmodel_ii+b

        # Execute python script that changes that scales the segmentation with the scaling factor
        os.chdir('/Users⁩/⁨tobiasjacobson⁩/⁨Documents⁩/⁨TCL(Jongmin)⁩')
        group_tweaker(svg1,scale_svg)
        group_tweaker(svg2,scale_svg)
        os.chdir(rundir + '/groups')
        import cabg_loft_mesh_writePy.py
        # Now create a 3-D model by lofting segmentations. Look for the "cabg_loft_mesh_write.tcl" to refer GenSolid.
        # Function call from cabg_loft_mesh_write.tcl --------------------
        GenSolid()
        # Move back to model_$nmodel_ii
        os.chdir(rundir)

        # Up to here the model generation is done. Now it goes to the meshing.
        # Used adaptive meshing, which isn't in the open source. So focus on the solid model for now ------------------------------------------------------------


        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

        # # # # # # # # # # # # # #      Meshing Goes Here      # # # # # # # # # # # # # #

        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# end of main



############################################
#                   Main                   #
############################################
import shutil
import os
import sys

main()
