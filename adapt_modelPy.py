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
    out_mesh_file = dirpath + 'adapt_' + nadapt_ii + '/adapt_' + nadapt_ii + '.sms']
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
    adapt_newObject -result $adaptobject # <><><><><><><><><><><><><><><><><><><><><><><><><><> # IDK how to replicate this

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
    mesh = '/adapt/internal/meshobject'
    #Read model file as a solid object to write out meshsim mesh related files
    try:
        Repository.List(modelName)
    except:
        print('Resulted an error')
    solid_readNative -file $solid_file -obj $modelName # <><><><><><><><><><><><><><><><><><><><><><><><><><> # IDK how to replicate this
    mesh_writeCompleteMesh $mesh $modelName mesh-complete $out_mesh_dir # <><><><><><><><><><><><><><><><><><><><><><><><><><> # IDK how to replicate this
    os.chdir(out_mesh_dir) # below ??
    cd $out_mesh_dir/.. # <><><><><><><><><><><><><><><><><><><><><><><><><><> #
