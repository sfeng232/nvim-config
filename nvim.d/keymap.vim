function! RefreshWithoutSavedView()
  let l:view = winsaveview()
  :e
  call winrestview(l:view)
endfunction
nnoremap qe :call RefreshWithoutSavedView()<cr>

" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction
" Moving back and forth between lines of same or lower indentation.
nnoremap <silent> <m-k> :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> <m-j> :call NextIndent(0, 1, 0, 1)<CR>
vnoremap <silent> <m-k> <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> <m-j> <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
onoremap <silent> <m-k> :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> <m-j> :call NextIndent(0, 1, 0, 1)<CR>

" move to line in same indentation level
" with vv : top to bottom
" with vV : bottom to top
" with va : indent the whole block and add new line after that
nnoremap <silent> vv :call SelectIndent(1)<cr>
nnoremap <silent> vV :call SelectIndent(-1)<cr>
function! SelectIndent(dir)
  exe "normal V"
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let old_indent = indent(line)
  while (line > 0 && line <= lastline)
    let line = line + a:dir
    if indent(line) <= old_indent
      if (strlen(getline(line)) > 0)
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Code block selection
" c-h increase selection indentation
" c-l reduce selection indentation
vnoremap <silent> <c-h> <esc>:call SelectLeft()<cr>
vnoremap <silent> <c-l> <esc>:call SelectRight()<cr>
" expand line visual selection by indentation
function! SelectLeft()
  let nstart = line("'<")
  let nend = line("'>")
  let lastline = line('$')
  let i = indent(nstart) - 2
  " if not the first line
  "    and indent not equal to original indent - 2
  "    and is not an empty line
  while (nstart > 0 && (indent(nstart) != i || col([nstart, "$"]) == 1))
    let nstart -= 1
  endwhile
  while (nend <= lastline && (indent(nend) != i || col([nend, "$"]) == 1))
    let nend += 1
  endwhile
  exe "normal " . nstart . "GV" . nend . "G"
endfunction

" collapse line visual selection by 1 line
function! SelectRight()
  let nstart = line("'<") + 1
  let nend = line("'>") - 1
  exe "normal " . nstart . "GV" . nend . "G"
endfunction

" search highlighted words
" * & # are built-in support in normal mode
" now add support to visual mode
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" == to tidy up all codes
function! TidyUpCodes()
  let linenumber = line('.') - 1
  execute "normal ggVG=".linenumber."j"
endfunction
noremap <leader>= :call TidyUpCodes()<cr>

" tidy up json
nnoremap <leader>js :%!python -m json.tool<cr>

" " m-s to source one line in n mode
" " s to source selected line in v mode
" " execute current line / highlighted lines as vim script
" " very good for debugging vim script
" nnoremap <m-s> :execute getline(".")<cr>
" vnoremap <silent> s <esc>
"   \ :'<,'>w! /tmp/part.vim<cr>
"   \ :so /tmp/part.vim<cr>
" " find out current highlight group name
nnoremap <leader>hg :echo synIDattr(synID(line("."),col("."),1),"name")<cr>

" cp to clone file in same folder
nnoremap <leader>cp :call CloneFile()<cr>
function! CloneFile()
  let fullpath = expand('%')
  let newpath = input('Clone file to: ', fullpath)
  if newpath != fullpath
    execute "silent ! cp " . fullpath . " " . newpath
    execute "e " . newpath
  endif
  redraw!
endfunction

" mv to move file
nnoremap <leader>mv :call MoveFile()<cr>
function! MoveFile()
  let fullpath = expand('%')
  let newpath = input('Move file to: ', fullpath)
  exe "! mv " . fullpath . " " . newpath
  exe "edit " . newpath
  redraw!
endfunction

" " alt-f to open file browser on pwd
" nnoremap <m-f> :silent !nautilus `pwd`<cr>
" " shift alt f to open file browser on current file folder
" nnoremap <m-s-f> :silent !nautilus %:p:h<cr>

" Select a block, <space>c to clone and select
vnoremap <silent> <leader>c y:call CloneSelection()<cr>
function! CloneSelection()
  let nstart = line("'<")
  let nend = line("'>")
  let lines = nend - nstart
  exe "normal " . nend . "Go"
  exe "normal pV" . lines . "j"
endfunction
