syntax clear
syntax on

syntax match h1 "^.*$"
syntax match h2 "^ \{2\}.*$"
syntax match h3 "^ \{4\}.*$"
syntax match h4 "^ \{6\}.*$"
syntax match h5 "^ \{8\}.*$"
syntax match h6 "^ \{10\}.*$"

" setup the highlighting links

hi h1 guifg=#4fc3f7
hi h2 guifg=#dce775
hi h3 guifg=#4db6ac
hi h4 guifg=#ff8a65
hi h5 guifg=#90a4ae
hi h6 guifg=#e57373

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
