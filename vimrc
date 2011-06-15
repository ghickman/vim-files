set nocompatible

if version >= 703
  filetype off
  call pathogen#runtime_append_all_bundles()
  call pathogen#helptags()
endif

set number
set ruler
syntax on

" Spelling off
set nospell

set tw=0

" Tab settings.
set nowrap
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
" Show tabs and new line 'hidden' characters.
set list listchars=tab:▸\

" Searching.
set hlsearch
set incsearch
set ignorecase
set smartcase
" Clear search highlighting.
map <Leader>sc :nohls<CR><C-L>

" Preserve resource fork
set backupcopy=yes

" Tab complietion.
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.class

" Status bar.
set laststatus=2

" Syntax error signs
let g:syntastic_enable_signs=1

" More syntax highlighting for Python
let python_highlight_all = 1

" Keep a long history.
set history=1000

" Backspace
set backspace=indent,eol,start

" Remove bells
set novisualbell
set noerrorbells

" NERDTree.
map <Leader>n :NERDTreeToggle<CR>
map <Leader>N :NERDTreeFind<CR>

" Command-T.
let g:CommandTMaxHeight=20

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Load plugins
filetype plugin indent on

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

au FileType markdown set wrap

" Python/PHP have different indent settings.
au FileType python set tabstop=4 softtabstop=4 shiftwidth=4
au FileType php set tabstop=4 softtabstop=4 shiftwidth=4

" Additional files that should be Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

" Additional files that should be Python
au BufRead,BufNewFile {requirements.txt} set ft=python

" Smart indenting
set smartindent cinwords=class,elif,else,except,def,finally,for,if,try,while

" PHP highlight settings
au FileType php let php_sql_query=1
au FileType php let php_htmlInStrings=1

" Mappings to expand the current path (edit, split, vsplit)
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Remove trailing whitespace
command RMTWS :execute '%s/\s\+$//e'

command SFTD :execute 'setfiletype htmldjango'

" Colour scheme
colorscheme vwilight

" Highlight long lines - only care about this in Vim 7.3+ now
if version >= 703
  highlight ColorColumn ctermbg=lightgrey guibg=#464646
  "set cc=+1 tw=80
  " Provide a way to turn it off and on
  nnoremap <Leader>l
    \ :if &cc != '0'<Bar>
    \   set cc=0<Bar>
    \ else<Bar>
    \   set cc=+5<Bar>
    \ endif<CR>
endif

" Highlight trailing whitespace.
hi link TrailingWhiteSpace Search
au BufWinEnter * let w:twsm=matchadd('TrailingWhiteSpace', '\s\+$')
" Setup a toggle.
nnoremap <silent> <Leader>w
  \ :if exists('w:twsm') <Bar>
  \   silent! call matchdelete(w:twsm) <Bar>
  \   unlet w:twsm <Bar>
  \ else <Bar>
  \   let w:twsm = matchadd('TrailingWhiteSpace', '\s\+$') <Bar>
  \ endif<CR>

hi CursorColumn term=underline cterm=underline guibg=#333435
" hidden carriage return character
hi NonText ctermbg=NONE ctermfg=235 guifg=#424242 gui=NONE
" hidden tab character
hi SpecialKey ctermbg=NONE ctermfg=235 guifg=#424242 gui=NONE

" Use :make to see syntax errors. (:cn and :cp to move around, :dist to see
" all errors)
set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

let g:SimpleNoteUserName = "george+simplenote@ghickman.co.uk"
let g:SimpleNotePassword = "J62.DYN7a3{ni/=e"
