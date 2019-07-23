# Procedure: createPREOPmodelCreateModel
# modified for optimization scripts by A. Marsden 5/2/06

# Procedure: createPREOPgrpKeepSel
proc createPREOPgrpKeepSel_AM {} {
   global createPREOPgrpKeptSelections
   global symbolicName
   set createPREOPgrpKeptSelections [$symbolicName(createPREOPgrpCurLB) get 0 end]
}
proc createPREOPmodelCreateModel_AM {} {
   global symbolicName
   global createPREOPgrpKeptSelections
   global gFilenames
   global gObjects
   global gLoftedSolids

#   createPREOPgrpKeepSel

   set modelname $gObjects(preop_solid)

   if {[llength $createPREOPgrpKeptSelections] == 0} {
      puts "No solid models selected.  Nothing done!"
      return
   }

   puts "Will union together the following SolidModel objects:"
   puts "  $createPREOPgrpKeptSelections"

   if {[repos_exists -obj $modelname] == 1} {
      puts "Warning:  object $modelname existed and is being replaced."
      repos_delete -obj $modelname
   }

    if {[repos_exists -obj /tmp/preop/$modelname] == 1} {
      repos_delete -obj /tmp/preop/$modelname
    }

    # for convenience, we offer to make any missing solid models for the
    # the user.  In general, people shouldn't do this, but what can you
    # do?
    foreach i $createPREOPgrpKeptSelections {
      set cursolid ""
      catch {set cursolid $gLoftedSolids($i)}
	if {$cursolid == "" || [repos_exists -obj $cursolid] == 0} {
         # solid  doesn't exist for current object, ask to create
         set choice [tk_messageBox -title "Missing capped solid branch!"  -message "Create missing solids using defaults?"  -icon question -type yesnocancel]
         switch -- $choice {
           yes {
              # create solids
              foreach j $createPREOPgrpKeptSelections {
                set cursolid ""
		catch {set cursolid $gLoftedSolids($j)}
		  if {$cursolid == "" || [repos_exists -obj $cursolid] == 0} {
                  # loft solid from group
                  global gPathBrowser
                  set keepgrp $gPathBrowser(currGroupName)
                  set gPathBrowser(currGroupName) $j
                  #puts "align"
                  #vis_img_SolidAlignProfiles;
                  #puts "fit"
                  #vis_img_SolidFitCurves;
                  #puts "loft"
                  #vis_img_SolidLoftSurf;
                  #vis_img_SolidCapSurf;
                  # set it back to original
                  nateAFLB
                  set gPathBrowser(currGroupName) $keepgrp
		}
              }
              break
	   }
           cancel {
              return -code error "Missing solid branches.  Create preop model failed."
	   }
           no {
              return -code error "Missing solid braches.  Create preop model failed."
	   }
         }

      } elseif {[repos_type -obj $cursolid] != "SolidModel"} {
         puts  "ERROR: Expected SolidModel for $cursolid."
         return -code error "ERROR: Expected SolidModel for $cursolid."
      }
    }

    set shortname [lindex $createPREOPgrpKeptSelections 0]
    set cursolid $gLoftedSolids($shortname)
    solid_copy -src $cursolid -dst $modelname
    puts "copy $cursolid to preop model."

    foreach i [lrange $createPREOPgrpKeptSelections 1 end] {
      set cursolid $gLoftedSolids($i)
      puts "union $cursolid into preop model."
      if {[repos_type -obj $cursolid] != "SolidModel"} {
         puts "Warning:  $cursolid is being ignored."
         continue
      }
      # ---------------------------------------- Confused what this is doing ---------------------------------------- #
       solid_union -result /tmp/preop/$modelname -a $modelname -b $cursolid
       repos_delete -obj $modelname
       solid_copy -src /tmp/preop/$modelname -dst $modelname
       repos_delete -obj /tmp/preop/$modelname
      # ------------------------------------------------------------------------------------------------------------- #
    }

    if {[repos_exists -obj /tmp/preop/$modelname] == 1} {
      repos_delete -obj /tmp/preop/$modelname
    }
}
