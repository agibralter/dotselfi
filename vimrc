" {{{ Plugins
source ~/.vim/include/plug.vim
source ~/.vim/include/plug-options.vim
" }}}

" Prevent output in terminal
let &shellpipe="&>"

set mouse=a

set diffopt+=vertical

set showtabline=2 " Always show tab bar
set nocompatible " We're running Vim, not Vi!
syntax enable
filetype on
filetype plugin indent on
compiler ruby

let mapleader = ","
map <space> <leader>
map <space><space> <leader><leader>

let $JS_CMD='node'

" Move lines up and down
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Basic options

set encoding=utf-8
set list " show hidden chars
set listchars=tab:▸\ ,eol:¬ " change invisible characters
set smartindent
set ruler
set showmatch
set showmode
set showcmd
set autoindent
set backspace=indent,eol,start " sane backspace behavior
set hidden
" In vim 7.4+ these work at the same time...
set relativenumber
set number
set scrolloff=3
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*~,*.pyc
set visualbell
set cursorline
set ttyfast
set laststatus=2
set undofile
set undoreload=10000

" Backups (use // so that vim uses full paths for backup names)
set backupdir=~/.vimtmp/backup// " backups
set directory=~/.vimtmp/swap//   " swap files
set undodir=~/.vimtmp/undo//     " undo files

" Make Y not dumb
nnoremap Y y$

" Tab navigation VI-style
nnoremap <leader>th :tabfirst<CR>
nnoremap <leader>tj :tabnext<CR>
nnoremap <leader>tk :tabprev<CR>
nnoremap <leader>tl :tablast<CR>
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>td :tabclose<CR>
nnoremap <leader>tt :tabedit<space>
nnoremap <leader>tm :tabm<space>

" Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
map <leader>/ :noh<CR>
nmap <tab> %
vmap <tab> %

" Soft/hard wrapping
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=79

" Quick .vimrc edit
nmap <leader>ev :tabedit $MYVIMRC<CR>

" Quick close buffer but not window
nmap <leader>b :BD<CR>

" Use the damn hjkl keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" And make them work, too.
nnoremap j gj
nnoremap k gk

" ; is easier to type than :
nnoremap ; :

" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>w <C-w>v<C-w>l
nnoremap <leader>af <C-^>

" Formatting, TextMate-style
map <leader>q gqip

" Easier linewise reselection
map <leader>v V`]

" Paste and auto indent
nnoremap <leader>ip pv`]=

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Clean all trailing whitespace
nmap <leader>W :call Preserve("%s/\\s\\+$//e")<CR>
" Clean all trailing whitespace on lines with non-whitespace
nmap _$ :call Preserve("%s/\\(\\S\\)\\s\\+$/\\1/e")<CR>
" Auto-indent file.
nmap _= :call Preserve("normal gg=G")<CR>

function! CleanBuffers()
  execute ":bufdo bd"
  execute ":tabnew"
  execute ":tabfirst"
  execute ":tabclose"
endfunction

nmap <leader>bb :call CleanBuffers()<CR>

if has("autocmd")
  augroup defaults
  " Remove ALL autocommands for the current group.
  au!
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  au BufNewFile,BufRead *.yaml,*.yml set filetype=yaml
  au BufNewFile,BufRead *.scss set filetype=scss
  au BufNewFile,BufRead *.mustache set filetype=mustache syntax=mustache
  au BufNewFile,BufRead *.js set syntax=jquery
  au BufNewFile,BufRead Gemfile,Guardfile set filetype=ruby syntax=ruby
  au BufNewFile,BufRead *.ru set filetype=ruby syntax=ruby
  au Filetype mustache inoremap <buffer> { {{}}<Left><Left>
  au bufwritepost .vimrc source $MYVIMRC " Source the vimrc file after saving it.
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
  au BufNewFile,BufRead *.md,*.markdown nnoremap <leader>1 yypVr=
  au BufNewFile,BufRead *.md,*.markdown nnoremap <leader>2 yypVr-
  au BufNewFile,BufRead *.md,*.markdown nnoremap <leader>3 I### <ESC>
  au BufRead,BufNewFile nginx.conf set ft=nginx
  au BufRead,BufNewFile /etc/nginx/conf/* set ft=nginx
  au BufRead,BufNewFile /etc/nginx/sites-available/* set ft=nginx
  au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx

  au ColorScheme * highlight clear SignColumn

  autocmd User fugitive
    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
    \   nnoremap <buffer> .. :edit %:h<CR> |
    \ endif
  autocmd BufReadPost fugitive://* set bufhidden=delete

  augroup END
end

if has('gui_running')
  set guifont=Inconsolata-g\ for\ Powerline:h14
  set background=light

  " CLI-like prompts
  set guioptions=ace

  set go-=T
  set go-=l
  set go-=L
  set go-=r
  set go-=R

  highlight SpellBad term=underline gui=undercurl guisp=Orange

  " set title titlestring=%<%F%=%l/%L-%P titlelen=70

  " Fix help key
  set fuoptions=maxvert,maxhorz
  inoremap <F1> <ESC>:set invfullscreen<CR>a
  nnoremap <F1> :set invfullscreen<CR>
  vnoremap <F1> :set invfullscreen<CR>
else
  set background=dark
endif

" Location list
nmap <leader>> :lnext<CR>
nmap <leader>< :lprevious<CR>

" Scrollbind
nmap <leader>sb :set scrollbind<CR>
nmap <leader>nb :set noscrollbind<CR>

" vim:tw=0:ts=4:sw=4:noet:nolist:foldmethod=marker
