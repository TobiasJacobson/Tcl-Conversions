# Objective: Convert the lab simVascular Tcl scripts to python
# Basis: Jongmin's Tcl scripts for patient 1 called adapt_model.tcl

def adapt_model(modelName, meshName, adapt_tstep, nadapt_ii):
    Solid.setKernel('Parasolid')
    MeshObject.setKernel('MeshSim')
    gOptions[meshing_kernel] = MeshSim
    gOptions[meshing_solid_kernel] = Parasolid
    # gObjects = None # Not used anywhere that I can see... Leave it or now ??
    gFilenames = ''
    adaptobject = '/new/adapt/object'
    try:
        Repository.Delete(adaptobject)
    except:
        print('Raised an error')
    dirpath = os.getcwd()
    out_mesh_dir = dirpath + 'adapt_' + nadapt_ii + '/mesh-complete/'
    os.mkdir(out_mesh_dir, 0)
    out_mesh_file = dirpath + 'adapt_' + nadapt_ii + '/adapt_' + nadapt_ii + '.sms'
    solid_file = dirpath + modelName + '.xmt_txt'
    if nadapt_ii == 1:
        sms_mesh_file = dirpath + meshName + '.sms'
    else:
        temp = nadapt_ii-1
        sms_mesh_file = dirpath +  'adapt_' + temp + '/adapt_' + temp + '.sms'
    vtu_mesh_file = dirpath + 'all_results.vtu'
    discreteFlag = 0
    adaptorsphere = [-1, 0, 0, 0, 0]
    maxRefineFactor = 0.01
    maxCoarseFactor = 0.13
    reductionRatio  = 0.4
    if nadapt_ii == 1:
        solution = dirpath + 'restart.' + adapt_tstep + '.1'
        error_file = dirpath + 'restart.' + adapt_tstep + '.1'
    else:
        solution = dirpath + 'restart.' + adapt_tstep + '.0'
        error_file = dirpath + 'restart. ' + adapt_tstep + '.0'
    out_solution = dirpath +  'outrestart.' + adapt_tstep + '.1'
    stepNumber = adapt_tstep
    gOptions[meshing_kernel] = MeshSim
    gOptions[meshing_solid_kernel] = Parasolid
    gFilenames = solid_file
    print('Running the adaptor...')
    # adapt_newObject(adaptobject)
    #
    # # ------------------------- Don't know how to do any of these ------------------------- # <><><><><><><><><><><><><><><><><><><><><><><><><><> # IDK how to replicate any of these
    # $adaptobject CreateInternalMeshObject(sms_mesh_file, solid_file)
    # $adaptobject LoadMesh(vtu_mesh_file)
    # $adaptobject SetAdaptOptions(strategy, 2)
    # $adaptobject SetAdaptOptions(metric_option, 2)
    # $adaptobject SetAdaptOptions(ratio, reductionRatio)
    # $adaptobject SetAdaptOptions(hmin, maxRefineFactor)
    # $adaptobject SetAdaptOptions(hmax, maxCoarseFactor)
    # $adaptobject SetAdaptOptions(instep, 0)
    # $adaptobject SetAdaptOptions(outstep, adapt_tstep)
    # $adaptobject SetMetric(vtu_mesh_file)
    # $adaptobject SetupMesh()
    # $adaptobject RunAdaptor()
    # $adaptobject GetAdaptedMesh()
    # $adaptobject TransferSolution()
    # $adaptobject WriteAdaptedSolution(out_solution)
    # $adaptobject WriteAdaptedMesh(out_mesh_file)
    # mesh = '/adapt/internal/meshobject'
    # # ------------------------------------------------------------------------------------- #

    #Read model file as a solid object to write out meshsim mesh related files
    try:
        Repository.List(modelName)
    except:
        print('Resulted an error')
    solid_readNative(solid_file, modelName)
    mesh_writeCompleteMesh(mesh, modelName, mesh-complete, out_mesh_dir)
    os.chdir(out_mesh_dir)
# end of adapt_model
