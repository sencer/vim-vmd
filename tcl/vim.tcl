proc load_saved_reps { molid } { return 1 }

proc save_and_delete { } {
  global all
  global viewpoints
  global representations
  set molcur [molinfo top]
  set molnew [expr 1+$molcur]
  save_viewpoint
  save_reps
  set representations($molnew) $representations($molcur)
  set viewpoints($molnew) $viewpoints($molcur)
  catch {
    $all delete
  }
  # display update off
  mol delete top
}

proc load_and_apply {file} {
  global all
  global viewpoints
  global representations

  mol new $file
  restore_viewpoint
  restore_reps
  # display update on # for some reason this causes problem with loading viewpoints

  set all [atomselect top all]
  $all global
}

proc output_xyz {} {
  global all
  set tmp [exec mktemp --suffix .xyz]
  save_xyz $all $tmp
  puts stdout "COOR: $tmp"
}

proc let_vim_know { du m my } {
  global all
  global vmd_pick_atom
  global vmd_pick_shift_state
  lassign [lindex [$all get {x y z}] $vmd_pick_atom] x y z
  if {$vmd_pick_shift_state} {
    puts stdout "VIM. [format "%.2f %.2f %.2f" $x $y $z]"
  } else {
    puts stdout "VIM: [format "%.2f %.2f %.2f" $x $y $z]"
  }
}

trace add variable vmd_pick_event write let_vim_know
