nnoremap <leader>l :call DumpSplit()<cr>
function! DumpSplit()
  let cmd = "tmux splitw -d -fhb -p40 \"read\""
  call system(cmd)
endfunction
