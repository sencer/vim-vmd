if exists('g:vmd_vim_loaded')
  finish
endif

let g:vmd_vim_loaded = 1

if !exists('g:vmd_command')
  let g:vmd_command = 'vmd'
endif

if !exists('g:vmd_options')
  let g:vmd_options = [ '-e', expand('<sfile>:p:h:h').'/tcl/vim.tcl' ]
endif

command! VMD :call vmd#loadmol()
command! FromVMD :call vmd#pull()
