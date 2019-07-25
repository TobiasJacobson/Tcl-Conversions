# geodesic_groups_file 2.3

#
proc group_autoload {} {
  global gFilenames
  set grpdir $gFilenames(groups_dir)
  # Group Stuff
  group_readProfiles {lsubcl3} [file join $grpdir {lsubcl3}]
  group_readProfiles {rcca} [file join $grpdir {rcca}]
  group_readProfiles {rima} [file join $grpdir {rima}]
  group_readProfiles {svg1} [file join $grpdir {svg1}]
  group_readProfiles {rca4} [file join $grpdir {rca4}]
  group_readProfiles {svg2} [file join $grpdir {svg2}]
  group_readProfiles {lca2_2} [file join $grpdir {lca2_2}]
  group_readProfiles {rsubcl1} [file join $grpdir {rsubcl1}]
  group_readProfiles {rsubcl_new} [file join $grpdir {rsubcl_new}]
  group_readProfiles {om} [file join $grpdir {om}]
  group_readProfiles {om_bif} [file join $grpdir {om_bif}]
  group_readProfiles {rsubcl2} [file join $grpdir {rsubcl2}]
  group_readProfiles {om1} [file join $grpdir {om1}]
  group_readProfiles {pda} [file join $grpdir {pda}]
  group_readProfiles {rsubcl3} [file join $grpdir {rsubcl3}]
  group_readProfiles {om2} [file join $grpdir {om2}]
  group_readProfiles {lsubcl2_1} [file join $grpdir {lsubcl2_1}]
  group_readProfiles {rca1_1} [file join $grpdir {rca1_1}]
  group_readProfiles {om3} [file join $grpdir {om3}]
  group_readProfiles {seq_svg} [file join $grpdir {seq_svg}]
  group_readProfiles {lca} [file join $grpdir {lca}]
  group_readProfiles {rca1_2} [file join $grpdir {rca1_2}]
  group_readProfiles {om4} [file join $grpdir {om4}]
  group_readProfiles {lca1} [file join $grpdir {lca1}]
  group_readProfiles {lca2} [file join $grpdir {lca2}]
  group_readProfiles {lca2_prox} [file join $grpdir {lca2_prox}]
  group_readProfiles {lcca} [file join $grpdir {lcca}]
  group_readProfiles {lca2_2_1} [file join $grpdir {lca2_2_1}]
  group_readProfiles {lima} [file join $grpdir {lima}]
  group_readProfiles {diamond} [file join $grpdir {diamond}]
  group_readProfiles {rsubcl2_1} [file join $grpdir {rsubcl2_1}]
  group_readProfiles {rca} [file join $grpdir {rca}]
  group_readProfiles {lsubcl1} [file join $grpdir {lsubcl1}]
  group_readProfiles {lsubcl_new} [file join $grpdir {lsubcl_new}]
  group_readProfiles {rca1} [file join $grpdir {rca1}]
  group_readProfiles {lsubcl2} [file join $grpdir {lsubcl2}]
  group_readProfiles {aorta} [file join $grpdir {aorta}]
}
proc seg3d_autoload {} {
  global gFilenames
  set grpdir $gFilenames(groups_dir)
# Seg Stuff
}
