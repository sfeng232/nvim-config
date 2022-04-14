nnoremap <leader>l :call DummySplit()<cr>
function! DummySplit()
  let cmd = "tmux splitw -d -fhb -p32 \"read\""
  call system(cmd)
endfunction
