# Objective: Convert the lab simVascular Tcl scripts to python
# Basis: Jongmin's Tcl scripts for patient 1 called adapt_model.tcl



def adapt_model(modelName, meshName, adapt_tstep, nadapt_ii):
    solid_setKernel = Parasolid
