# Procedure: createPREOPmodelCreateModel
# modified for optimization scripts by A. Marsden 5/2/06

# Procedure: createPREOPgrpKeepSel
def createPREOPgrpKeepSel_AM():
    createPREOPgrpKeptSelections = None
    symbolicName = None
    # createPREOPgrpKeptSelections = symbolicName[createPREOPgrpCurLB] get 0 end] # <><><><><><><><><><><><><><><><><><><><><><><><><><> # Don't know the argument inputs

# end of createPREOPgrpKeepSel_AM

def createPREOPmodelCreateModel_AM():
    symbolicName = None
    createPREOPgrpKeptSelections = []
    gFilenames = None
    gObjects = None
    gLoftedSolids = None

    modelname = gObjects[preop_solid]

    if createPREOPgrpKeptSelections.len() == 0:
        print("No solid models selected.  Nothing done!")
        return

    print("Will union together the following SolidModel objects:")
    print('  ' + createPREOPgrpKeptSelections)

    repoList = Repository.List()
    for item in repoList:
        if item == modelName:
            print('Warning: object ' + modelname + 'existed and is being replaced.')
            Repository.Delete(modelname)

    for item in repoList:
        if item == ('/tmp/preop/' + modelname):
            Repository.Delete('/tmp/preop/' + modelname)


    # for convenience, we offer to make any missing solid models for the
    # the user.  In general, people shouldn't do this, but what can you
    # do?
    for i in createPREOPgrpKeptSelections:
        cursolid = ""
        try:
            cursolid = gLoftedSolid[i]
        except:
            print('Resulted in error')
        if cursolid == '' or path.exists(cursolid) == False:
            choice = input('Missing capped solid branch! Create missing solids using defaults? (yes, no cancel)')
            if choice == 'yes':
                # create solids
                for j in createPREOPgrpKeptSelections:
                    cursolid = ''
                    try:
                        cursolid = gLoftedSolids[j]
                    except:
                        print('Resulted in error')
                    if cursolid == "" or (path.exists(cursolid) == False):
                        # loft solid from group
                        gPathBrowser = None
                        keepgrp = gPathBrowser[currGroupName]
                        gPathBrowser[currGroupName] = j
                        #print('align')
                        #vis_img_SolidAlignProfiles
                        #print('fit')
                        #vis_img_SolidFitCurves;
                        #print('loft')
                        #vis_img_SolidLoftSurf;
                        #vis_img_SolidCapSurf;
                        # set it back to original
                        nateAFLB()
                        gPathBrowser[currGroupName] = keepgrp
                    else:
                        print('No action')
            elif choice == 'cancel':
                print('Missing solid branches.  Create preop model failed.')
                return
            elif choice == 'no':
                print('Missing solid branches.  Create preop model failed.')
                return
            else:
                print('Not a valid choice')
                return
        elif cursolid != 'SolidModel':
            print('ERROR: Expected SolidModel for ' + cursolid + '.')
            return

    shortname = createPREOPgrpKeptSelections[0]
    cursolid = gLoftedSolids[shortname]
    solid_copy -src $cursolid -dst $modelname  # <><><><><><><><><><><><><><><><><><><><><><><><><><> # IDK how to replicate this
    print('copy $cursolid to preop model.'),

    for x in range(1, createPREOPgrpKeptSelections.len()-1)
        cursolid = gLoftedSolids[x]
        print('union ' + cursolid + ' into preop model.')'
        if cursolid != 'SolidModel':
            print('Warning: ' + cursolid + ' is being ignored.')'
        # ----------------- Confused what this is doing ----------------- #
        solid_union -result /tmp/preop/$modelname -a $modelname -b $cursolid # <><><><><><><><><><><><><><><><><><><><><><><><><><> # IDK how to replicate this
        Repository.Delete(modelname)
        solid_copy -src /tmp/preop/$modelname -dst $modelname # <><><><><><><><><><><><><><><><><><><><><><><><><><> # IDK how to replicate this
        Repository.Delete('/tmp/preop/' + modelname)
        # --------------------------------------------------------------- #
    repoList = Repository.List()
    for item in repoList:
        if item == ('/tmp/preop/' + modelname):
            Repository.Delete('/tmp/preop/' + modelname)
# end of createPREOPmodelCreateModel_AM






############################################
#                   Main                   #
############################################
import shutil
import os
import sys
from sv import *
