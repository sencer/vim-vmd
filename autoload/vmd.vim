let g:vmd#matches = []

function! vmd#deletematches()
  for mid in g:vmd#matches
    call matchdelete(mid)
  endfor
  let g:vmd#matches = []
endfunction

function! vmd#parseout(jobid, data, event)
  for data in a:data
    if data[:4] == 'VIM: '
      echo data[:4]
      call vmd#deletematches()
      let l:line = search(substitute(join(map(split(data[5:]), 'v:val[:-2]'), '\d*\s\+'), '\.', '\\.', 'g'))
      call add(g:vmd#matches, matchaddpos('SpecialChar', [l:line]))
    elseif data[:4] == 'VIM. '
      let l:line = search(substitute(join(map(split(data[5:]), 'v:val[:-2]'), '\d*\s\+'), '\.', '\\.', 'g'))
      call add(g:vmd#matches, matchaddpos('SpecialChar', [l:line]))
    elseif data[:5] == 'COOR: '
      let l:file = join(split(data[6:]))
      let l:curline = line(".")
      execute '1,$ delete _'
      execute 'r '.l:file
      execute '1 delete _'
      call delete(l:file, 'rf')
      execute ':'.l:curline
    elseif data[:12] == 'Info) Exiting'
      echom "VMD exiting!"
      let s:vmd_spawned = 0
      call jobclose(a:jobid)
    endif
  endfor
  return 0
endfunction

function! vmd#pull()
  call jobsend(s:vmd_job_id, ['output_xyz', ''])
endfunction

function! vmd#spawn()
  let l:command = extend([g:vmd_command], g:vmd_options)
  let s:vmd_job_id  = jobstart(
        \ l:command,
        \{
        \ 'pty': 1,
        \ 'on_stdout': function('vmd#parseout'),
        \ 'on_stderr': function('vmd#parseout'),
        \}
        \)
  let s:vmd_spawned = 1
  return 1
endfunction

function! vmd#loadmol()
  if exists("s:vmd_spawned") && s:vmd_spawned == 1
    call jobsend(s:vmd_job_id, ['save_and_delete', ''])
  else
    call vmd#spawn()
  endif
  call jobsend(s:vmd_job_id, ['load_and_apply '.expand('%'), ''])
endfunction
