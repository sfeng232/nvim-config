" https://thoughtbot.com/blog/writing-vim-syntax-plugins

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
