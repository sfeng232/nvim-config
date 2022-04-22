nnoremap <leader>l :call DummySplit()<cr>
function! DummySplit()
  let cmd = "tmux splitw -d -fhb -p32 \"read\""
  call system(cmd)
endfunction

nnoremap <leader>ga <cmd>call TmuxPopup('git add * && git commit -am \"untitled updates\" && git push -u origin HEAD; any-key')<cr>
