" execute cli without waiting of exit code
function! FastSystem(cmd)
  if has("mac")
    call system(a:cmd)
  else
    call system("nohup " . a:cmd . " &")
  endif
endfunction
"
" Send key to a window of a session, create window if not exist
" call TmuxSendKey("rspec", "main", "rspec --drb")
function! TmuxSendKey(session, window, cmd, ...)
  let r = system("tmux has-session -t " . a:session)
  if v:shell_error != 0
    echo "session " . a:session . " not found"
    return
  endif

  " find window that name start by space
  let find_window_cmd = "tmux list-windows -t " . a:session . " | grep ' " . a:window . "'"
  let r = system(find_window_cmd)
  if v:shell_error != 0
    echo "init window " . a:window . " in session " . a:session
    call system("tmux new-window -t " . a:session . " -n " . a:window)
    if v:shell_error != 0
      echo "failed to init new window"
      return
    end
    let r = system(find_window_cmd)
    sleep 3
  endif

  let mcmd = " q C-u" . a:cmd
  let winid = split(r, ':')[0]
  let sendcmd = "send-keys -t " . a:session . ":" . winid . mcmd
  call FastSystem("tmux " . sendcmd)
  call FastSystem("tmux select-window -t " . a:session . ":" . winid)
  if a:0
    call FastSystem("wmctrl -a 'Main Tmux Session'")
  endif
endfunction

" send cmd line to tmux
function! TmuxSendCmd(session, window, cmd)
  call TmuxSendKey(a:session, a:window, " '" . a:cmd . "' Enter")
endfunction



" function! XTermPasteBegin()
"   set pastetoggle=<Esc>[201~
"   set paste
"   return ""
" endfunction
"
" inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
