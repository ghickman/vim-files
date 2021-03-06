" Preamble --------------------------------------------------------------- {{{

filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
set nocompatible

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" }}}
" Basics ----------------------------------------------------------------- {{{

set autoindent
set backspace=indent,eol,start
set backupcopy=yes " Preserve resource fork
set dictionary=/usr/share/dict/words
set encoding=utf-8
set hidden
set history=1000
set laststatus=2
set linebreak
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮
set modelines=0
set noerrorbells
set nospell
set novisualbell
set number
set ruler
set showcmd
set showmode
set splitbelow
set splitright
set ttyfast
set undofile
set undoreload=10000

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Time out on key codes but not mappings.
set notimeout
set ttimeout
set ttimeoutlen=10

" Wildmenu Completion ---------------------------------------------------- {{{

set wildmenu
set wildmode=list:longest

set wildignore+=.git,.hg,.svn                            " Version control
set wildignore+=*.bmp,*.gif,*.jpg,*.jpeg,*.png           " Binary images
set wildignore+=*.class,*.dll,*.exe,*.manifest,*.o,*.obj " Compiled object files
set wildignore+=*.spl                                    " Compile spelling word lists
set wildignore+=*.DS_Store                               " OSX
set wildignore+=*.pyc                                    " Python byte code

" }}}
" Tabs, spacing, etc ----------------------------------------------------- {{{

set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=0

" }}}
" Backups ---------------------------------------------------------------- {{{

set backup                        " enable backups
set noswapfile                    " apparently it's 2012

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}
" Leader ----------------------------------------------------------------- {{{

let mapleader = ","
" let localleader = "\\"

" }}}
" Color Scheme ----------------------------------------------------------- {{{

syntax on
set background=dark
colorscheme solarized

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}
" Folding ---------------------------------------------------------------- {{{

set foldlevelstart=0

" Sane current location
nnoremap <c-cr> zvzz

" Toggle a fold
nnoremap <leader>f za

" Open all Folds
nnoremap <leader>F zR

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
"
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()
" }}}
" Buffer/Window Width ---------------------------------------------------- {{{

set winwidth=80
autocmd WinEnter * wincmd =
autocmd VimResized * wincmd =

" }}}
" Trailing Whitespace ---------------------------------------------------- {{{

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

" }}}

" }}}
" GUI -------------------------------------------------------------------- {{{

if has('gui_running')
    set guifont=Monaco\ for\ Powerline:h13

    " Get rid of UI cruft
    set guioptions-=b
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guioptions-=T

    if has('gui_macvim')
        " Fullscreen takes up entire screen
        set fuoptions=maxhorz,maxvert

        " Remove the tab bar
        set showtabline=0
    end
else
    " Console vim

    " Mouse support
    set mouse=a
end
" }}}
" Movement --------------------------------------------------------------- {{{

" Destroy the arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Make life easier
nnoremap j gj
nnoremap k gk

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>v <C-w>v

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

" }}}
" Search ----------------------------------------------------------------- {{{

set hlsearch
set incsearch
set ignorecase
set smartcase

" Clear search highlighting.
map <leader><space> :nohls<cr>

" }}}
" Convenience mappings --------------------------------------------------- {{{

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Sort!
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" Remove trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Set filetype to htmldjango
nnoremap <leader>sd setlocal ft=htmldjango<CR>

" Add the two lines below to this one and get rid of the fucking spaces.
nnoremap <leader>jl JxJxj<cr>

" Faster Esc
inoremap jk <esc>
inoremap JK <esc>

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Map f1 to leave insert/visual mode
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Quick return
inoremap <c-cr> <esc>A<cr>
inoremap <s-cr> <esc>A:<cr>

" Send visual selection to gist.github.com
" Requires gist (brew install gist)
vnoremap <leader>G :w !gist -p -t %:e \| pbcopy<cr>

" Nicked from SJL and stripped further.
" >For some reason ctags refuses to ignore Python variables, so I'll just hack
" >the tags file with sed and strip them out myself.
"
" >Sigh.
nnoremap <leader><cr> :silent !/usr/bin/find . -name "*.py" -exec /usr/local/bin/ctags {} + && sed -i .bak -E -e '/	v	class/d' -e '/	v$/d' -e '/import/d' tags<cr>

" Split/Join {{{
"
" Basically this splits the current line into two new ones at the cursor position,
" then joins the second one with whatever comes next.
"
" Example:                      Cursor Here
"                                    |
"                                    V
" foo = ('hello', 'world', 'a', 'b', 'c',
"        'd', 'e')
"
"            becomes
"
" foo = ('hello', 'world', 'a', 'b',
"        'c', 'd', 'e')
"
" Especially useful for adding items in the middle of long lists/tuples in Python
" while maintaining a sane text width.
nnoremap K h/[^ ]<cr>"zd$jyyP^v$h"zpJk:s/\v +$//<cr>:noh<cr>j^
" }}}
" Handle URL {{{
" Stolen from https://github.com/askedrelic/homedir/blob/master/.vimrc
" OSX only: Open a web-browser with the URL in the current line
function! HandleURI()
    let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
    echo s:uri
    if s:uri != ""
        exec "!open \"" . s:uri . "\""
    else
        echo "No URI found in line."
    endif
endfunction
map <leader>u :call HandleURI()<CR>
" }}}
" Quick Editing {{{

nnoremap <leader>ev <c-w>s:edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" }}}
" Help {{{

nnoremap <buffer> <cr> <c-]>
nnoremap <buffer> <bs> <c-t>

" }}}

" }}}
" Filetype Specific Stuff ------------------------------------------------ {{{

" CSS and SCSS {{{

augroup ft_css
    au!

    au BufNewFile,BufRead *.scss setlocal filetype=scss

    au Filetype scss,css setlocal foldmethod=marker
    au Filetype scss,css setlocal foldmarker={,}
    au Filetype scss,css setlocal omnifunc=csscomplete#CompleteCSS
    au Filetype scss,css setlocal iskeyword+=-

    " Use <leader>S to sort properties.  Turns this:
    "
    "     p {
    "         width: 200px;
    "         height: 100px;
    "         background: red;
    "     }
    "
    " into this:

    "     p {
    "         background: red;
    "         height: 100px;
    "         width: 200px;
    "     }
    " au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <leader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
    " positioned inside of them AND the following code doesn't get unfolded.
    au BufNewFile,BufRead *.sass,*.css inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END

" }}}
" HTML and HTMLDjango {{{

augroup ft_html
    au!

    au BufNewFile,BufRead *.html setlocal filetype=htmldjango
    au FileType html,jinja,htmldjango setlocal foldmethod=manual

    " Use <localleader>f to fold the current tag.
    au FileType html,jinja,htmldjango nnoremap <buffer> <localleader>f Vatzf

    " Use Shift-Return to turn this:
    "     <tag>|</tag>
    "
    " into this:
    "     <tag>
    "         |
    "     </tag>
    au FileType html,jinja,htmldjango nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

    " Django tags
    au FileType jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

    " Django variables
    au FileType jinja,htmldjango inoremap <buffer> <c-f> {{<space><space>}}<left><left><left>
augroup END

" }}}
" Javascript {{{

augroup ft_javascript
    au!

    au BufNewFile,BufRead *.json setlocal filetype=javascript

    " Pretty-print JSON files with Python (& remove the trailing whitespace that
    " Python <2.7 json module adds, sigh)
    nmap <leader>j :%!python -m json.tool<CR>:%s/\s\+$//g<CR>

    au FileType javascript setlocal foldmethod=marker
    au FileType javascript setlocal foldmarker={,}
augroup END

" }}}
" Markdown {{{

augroup ft_markdown
    au!

    au BufNewFile,BufRead *.m*down setlocal filetype=markdown
    au BufNewFile,BufRead *.md setlocal filetype=markdown

    " Use <localleader>1/2/3 to add headings.
    au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
    au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
    au Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>

    au FileType markdown setlocal wrap
    au FileType markdown map j gj
    au FileType markdown map k gk
    au FileType markdown setlocal spell spelllang=en_gb
augroup END

" }}}
" Nginx {{{

augroup ft_nginx
    au!

    au BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
    au BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
    au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
    au BufRead,BufNewFile vhost.nginx                            set ft=nginx

    au FileType nginx setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}
" Puppet {{{

augroup ft_puppet
    au!

    au Filetype puppet setlocal foldmethod=marker
    au Filetype puppet setlocal foldmarker={,}
augroup END

" }}}
" Python {{{

augroup ft_python
    au!

    " Additional files that should be Python
    au BufNewFile,BufRead {dev_,}requirements.txt setlocal filetype=python

    " au Filetype python noremap  <buffer> <localleader>rr :RopeRename<CR>
    " au Filetype python vnoremap <buffer> <localleader>rm :RopeExtractMethod<CR>
    " au Filetype python noremap  <buffer> <localleader>ri :RopeOrganizeImports<CR>

    au FileType python setlocal omnifunc=pythoncomplete#Complete
    au FileType python setlocal define=^\s*\\(def\\\\|class\\)
    au FileType python setlocal foldnestmax=1
    " au FileType python compiler nose
    " au FileType man nnoremap <buffer> <cr> :q<cr>

    " More syntax highlighting for Python
    let python_highlight_all = 1

    " Run nosetests
    au Filetype python noremap <leader>r :!nosetests %<cr>
augroup END

" }}}
" ReStructuredText {{{

augroup ft_rest
    au!

    au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
    au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
    au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
    au Filetype rst nnoremap <buffer> <localleader>4 yypVr`

    au FileType rst setlocal wrap
    au FileType rst map j gj
    au FileType rst map k gk
augroup END

" }}}
" Ruby {{{

augroup ft_ruby
    au!

    " Additional files that should be Ruby
    au BufNewFile,BufRead {Gemfile,Rakefile,Thorfile,config.ru} setlocal filetype=ruby
    au BufNewFile,BufRead *.sass setlocal filetype=sass

    au Filetype ruby,sass setlocal foldmethod=syntax
    au FileType ruby,sass setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" }}}
" Vagrant {{{

augroup ft_vagrant
    au!

    au BufRead,BufNewFile Vagrantfile set ft=ruby
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78

    " Display help in a vsplit
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}

" }}}
" Plugin Specific stuff -------------------------------------------------- {{{

" Ack {{{

map <leader>a :Ack<space>

" }}}
" CtrlP {{{

let g:ctrlp_map = '<leader>t'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_extensions = ['tag']

nnoremap <leader>. :CtrlPTag<cr>

" }}}
" Commentary {{{

nmap <leader>c <Plug>CommentaryLine
xmap <leader>c <Plug>Commentary
au FileType htmldjango setlocal commentstring={#\ %s\ #}
au FileType python setlocal commentstring=#\ %s

" }}}
" Fugitive {{{

nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gp :Git push<cr>
nnoremap <leader>gpl :Git pull<cr>
nnoremap <leader>gr :Gremove<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>

augroup ft_fugitive
    au!

    au BufNewFile,BufRead .git/index setlocal nolist
augroup END

" }}}
" Gundo {{{

nnoremap <leader>u :GundoToggle<cr>

" }}}
" Powerline {{{

let g:Powerline_colorscheme = 'solarized256'
let g:Powerline_symbols = 'fancy'

" }}}
" Python Mode {{{

" General
let g:pymode_breakpoint = 0
let g:pymode_lint = 0
let g:pymode_options_fold = 0
let g:pymode_options_indent = 0
let g:pymode_options_other = 0
let g:pymode_run = 1
let g:pymode_utils_whitespaces = 0
let g:pymode_virtualenv = 1

" Docs
let g:pymode_doc = 1
let g:pymode_doc_key = '<leader>k'
let g:pydoc = 'pydoc'

" Rope
let g:pymode_rope = 1
let g:pymode_rope_always_show_complete_menu = 0
let g:pymode_rope_autoimport_generate = 1
let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime']
let g:pymode_rope_autoimport_underlineds = 0
let g:pymode_rope_codeassist_maxfixes = 10
let g:pymode_rope_confirm_saving = 1
let g:pymode_rope_enable_autoimport = 0
let g:pymode_rope_global_prefix = '<localleader>R'
let g:pymode_rope_goto_def_newwin = 0
let g:pymode_rope_local_prefix = '<localleader>r'

" Force creation/usage of .ropeproject files for sanity
let g:pymode_rope_guess_project = 0

" Disable rope code completion
let g:pymode_rope_extended_complete = 0
let g:pymode_rope_vim_completion = 0

map <leader>g :call RopeGotoDefinition()<cr>

" Syntax Highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_builtin_objs = 1
let g:pymode_syntax_highlight_exceptions = 1
let g:pymode_syntax_indent_errors = 1
let g:pymode_syntax_print_as_function = 1
let g:pymode_syntax_slow_sync = 0
let g:pymode_syntax_string_format = 1
let g:pymode_syntax_string_formatting = 1

" }}}
" Pyflakes {{{

" Don't use quickfix list, it interferes with Ack
let g:pyflakes_use_quickfix = 0

" }}}
" Scratch {{{

nnoremap <silent> <leader><tab> :Sscratch<cr>

" }}}
" SuperTab {{{

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLongestHighlight = 1

" }}}
" Syntastic {{{

let g:syntastic_enable_signs=1
let g:syntastic_disabled_filetypes=['javascript', 'python']

" }}}
" Threesome {{{

" See https://bitbucket.org/sjl/dotfiles/src/b5e60ade957d/vim/.vimrc#cl-1087
" for more!
let g:threesome_initial_mode = "grid"
let g:threesome_wrap = "nowrap"

" }}}

" }}}
" Pulse Line ------------------------------------------------------------- {{{

function! s:Pulse() " {{{
    let current_window = winnr()
    windo set nocursorline
    execute current_window . 'wincmd w'
    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    let steps = 9
    let width = 1
    let start = width
    let end = steps * width
    let color = 233

    for i in range(start, end, width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor
    for i in range(end, start, -1 * width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor

    execute 'hi ' . old_hi
endfunction " }}}
command! -nargs=0 Pulse call s:Pulse()

" }}}

