nnoremap <leader>l :call DummySplit()<cr>
function! DummySplit()
  let cmd = "tmux splitw -d -fhb -p32 \"read\""
  call system(cmd)
endfunction

" nnoremap <leader>ga :! git add *; git commit -a -m "updated config"; git push -u origin master<cr>:echo "Done Sync Notes"<cr>:call TabdoChecktime()<cr>
nnoremap <leader>ga <cmd>call TmuxPopup('set -x; git add * && git commit -am \"untitled updates\" && git push -u origin HEAD; any-key')<cr>
