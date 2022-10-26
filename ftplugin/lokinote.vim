" https://thoughtbot.com/blog/writing-vim-syntax-plugins
"
" key mappings
nnoremap <buffer> <silent> vv :call SelectIndent(1)<cr>k
nnoremap <buffer> <silent> yy ml^y$`l:delmarks l \| echo 'Copied line'<cr>
" setl foldmethod=indent
" setl foldignore=""
" function! FoldToCurrentLineLevel()
"   let fl = foldlevel(".") - 1
"   let &foldlevel = fl
" endfunction
" nnoremap <buffer> <silent> ZZ :call FoldToCurrentLineLevel()<cr>
" zR: open all fold
" zo: open a fold
" ZZ: set fold level to current line level
" zz: fold current block

" leader l to change bullet style
function! s:ChangeListBulletOnLine(line, style)
  let content = getline(a:line)
  if a:style == '-'
    let content = substitute(content, "\\\([^ ]\\\)", "- \\0", "")
  elseif a:style == '*'
    let content = substitute(content, "- ", "* ", "")
  elseif a:style == '>'
    let content = substitute(content, "* ", "> ", "")
  else
    let content = substitute(content, "> ", "", "")
  endif
  call setline(a:line, content)
endfunction

function! ChangeListBullet(dir, style)
  if a:dir == 0
    let stripped = tlib#string#Strip(getline('.'))[0:1]
    if stripped == '- '
      let style = '*'
    elseif stripped == '* '
      let style = '>'
    elseif stripped == '> '
      let style = ''
    else
      let style = '-'
    end
    call s:ChangeListBulletOnLine(line('.'), style)
    call ChangeListBullet(-1, style)
    call ChangeListBullet(1, style)
  else
    let line = line('.')
    let target_indent_lv = indent(line)
    let lastline = line('$')
    while (line > 0 && line <= lastline)
      let line = line + a:dir
      let current_lv = indent(line)
      if current_lv == target_indent_lv
        call s:ChangeListBulletOnLine(line, a:style)
      elseif current_lv < target_indent_lv
        return 1
      endif
    endwhile
  endif
endfunction
nnoremap <buffer> <silent> <m-b> :call ChangeListBullet(0, '')<cr>

function! AddDateTime()
  exe ":normal a @ " . strftime("%H:%M %d.%m.%Y")
endfunction
nnoremap <buffer> <silent> <leader>ad :call AddDateTime()<cr>
