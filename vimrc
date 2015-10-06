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
call pathogen#infect()

let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers=['mri', 'rubocop']
let g:syntastic_javascript_checkers = ['eslint']

" Security
set modelines=0

let mapleader = ","

let $JS_CMD='node'

" copy path to clipboard
nmap cp :let @+ = expand("%:p")<CR>
set clipboard=unnamed

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1

" gitgutter options
let g:gitgutter_highlight_lines = 0
let g:gitgutter_sign_column_always = 0
" Don't gitgutter in realtime... too slow over ssh.
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 1
map <F6> :GitGutterLineHighlightsToggle<CR>

" Set options for vim-session
let g:session_directory = '~/.vimtmp/sessions'
let g:session_autoload = 'no'
let g:session_autosave = 'no'

" ctrlp.vim
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" Do not manage project root
let g:ctrlp_working_path_mode = 0
" only jump to the buffer if it is opened in the current tab
let g:ctrlp_jump_to_buffer = 1
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|tmp$\|log$'

" Not $HOME...
let g:yankring_history_dir = '$HOME/.vim'

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Like windo but restore the current window.
function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction
com! -nargs=+ -complete=command Windo call WinDo(<q-args>)

" Like bufdo but restore the current buffer.
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
com! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

" Like tabdo but restore the current tab.
function! TabDo(command)
  let currTab=tabpagenr()
  execute 'tabdo ' . a:command
  execute 'tabn ' . currTab
endfunction
com! -nargs=+ -complete=command Tabdo call TabDo(<q-args>)

" Use a default of softabs that are 2 spaces wide.
set ts=4 sts=2 sw=2 expandtab
let g:ajgtabsetting = 0
" Allow toggling to 4 spaces.
function! TabToggle()
  if g:ajgtabsetting == 0
    call BufDo("set ts=4 sts=4 sw=4 expandtab")
    let g:ajgtabsetting = 1
  else
    call BufDo("set ts=4 sts=2 sw=2 expandtab")
    let g:ajgtabsetting = 0
  endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z

" Basic options
set encoding=utf-8
set list                              " Show hidden chars
set listchars=tab:▸\ ,eol:¬           " Use the same symbols as TextMate for tabstops and EOLs
set smartindent
set ruler
set showmatch
set showmode
set showcmd
set autoindent
set backspace=indent,eol,start        " sane backspace behavior
set hidden
" In vim 7.4+ these work at the same time...
set relativenumber
set number
set scrolloff=3
set wildmenu
set wildmode=list:longest
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
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>
nnoremap tt :tabedit<Space>
nnoremap tm :tabm<Space>

" Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
map <leader><space> :noh<CR>
runtime macros/matchit.vim
nmap <tab> %
vmap <tab> %

" Soft/hard wrapping
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=79

" NERD Tree
map <leader><F2> :NERDTree<CR>
map <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\~$', '.*\.pyc$', 'pip-log\.txt$']
nnoremap <leader>rr :NERDTreeFind<CR>
let NERDTreeWinSize=30

" Set ack path
let g:ackprg="~/.bin/ack -H --nocolor --nogroup --column"
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Quick .vimrc edit
nmap <leader>ev :tabedit $MYVIMRC<CR>

" Quick close buffer but not window
nmap <leader>b :BD<CR>

" Use the damn hjkl keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" And make them fucking work, too.
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

nnoremap <D-j> j10j
nnoremap <D-k> k10k

" Folding
" let g:ruby_fold = 1 " Ruby folding
set foldlevelstart=99
nnoremap <Space> za
vnoremap <Space> za
noremap <leader>ft Vatzf


" Ack
map <leader>A :LAck<Space>

" ZoomWin
nnoremap <leader>z :ZoomWin<CR>

" Yankring
nnoremap <silent> <F3> :YRShow<CR>
nnoremap <silent> <leader>y :YRShow<CR>

" Formatting, TextMate-style
map <leader>q gqip

" Easier linewise reselection
map <leader>v V`]

" Paste and auto indent
nnoremap <leader>ip pv`]=

" Make selecting inside an HTML tag less dumb
nnoremap Vit vitVkoj
nnoremap Vat vatV

" UniCycle
nnoremap <leader>u :UniCycleOn<CR>
nnoremap <leader>U :UniCycleOff<CR>

" vim-rspec
map <Leader>sc :call RunCurrentSpecFile()<CR>
map <Leader>sn :call RunNearestSpec()<CR>
map <Leader>sl :call RunLastSpec()<CR>

" Stop it, hash key
inoremap # X<BS>#

" tagbar
nmap <F8> :TagbarToggle<CR>
nmap <F9> :TagbarOpen fjc<CR>

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
  au Filetype html,xml,xsl,mustache source ~/.vim/bundle/closetag/plugin/closetag.vim
  au Filetype mustache inoremap <buffer> { {{}}<Left><Left>
  au bufwritepost .vimrc source $MYVIMRC " Source the vimrc file after saving it.
  au BufNewFile,BufRead *.m*down set filetype=markdown
  au BufNewFile,BufRead *.m*down nnoremap <leader>1 yypVr=
  au BufNewFile,BufRead *.m*down nnoremap <leader>2 yypVr-
  au BufNewFile,BufRead *.m*down nnoremap <leader>3 I### <ESC>
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

runtime macros/matchit.vim

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

function! s:ToggleNuMode()
  if(&rnu == 1)
    set nu
  else
    set rnu
  endif
endfunc

nnoremap <leader><C-M> :call <SID>ToggleNuMode()<CR>

" solarized options
" If not using iTerm 2 with Solarized, enable the 'degraded 256 colorscheme'
" let g:solarized_termcolors = 256
" let g:solarized_visibility = "high"
" let g:solarized_contrast = "high"
colorscheme solarized
call togglebg#map("<F5>")

if has('gui_running')
  set guifont=Inconsolata-g\ for\ Powerline:h14
  set background=light

  set go-=T
  set go-=l
  set go-=L
  set go-=r
  set go-=R

  let g:sparkupExecuteMapping = '<D-e>'

  highlight SpellBad term=underline gui=undercurl guisp=Orange

  " set title titlestring=%<%F%=%l/%L-%P titlelen=70

  " Fuck you, help key.
  set fuoptions=maxvert,maxhorz
  inoremap <F1> <ESC>:set invfullscreen<CR>a
  nnoremap <F1> :set invfullscreen<CR>
  vnoremap <F1> :set invfullscreen<CR>
else
    set background=dark
endif

" Show syntax highlighting groups for word under cursor
nmap <C-S> :call SynStack()<CR>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


function! s:Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction
nnoremap <leader>cb :call <SID>Wipeout()<CR>

" Tabularize
" Align equals signs
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>

" Align by colons left-aligned; e.g.: hello: world (with negative look-behind
" so ruby symbols' colons don't get aligned)
nmap <Leader>al: :Tabularize /\s\@<!:\zs/l1l0<CR>
vmap <Leader>al: :Tabularize /\s\@<!:\zs/l1l0<CR>

" Align by colons center-aligned; e.g.: hello : world
nmap <Leader>ac: :Tabularize /:<CR>
vmap <Leader>ac: :Tabularize /:<CR>

" Align ruby hashrockets.
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>

" Align comma tables.
nmap <Leader>a, :Tabularize /,\zs/l1l0<CR>
vmap <Leader>a, :Tabularize /,\zs/l1l0<CR>

" Gundo
nnoremap U :GundoToggle<CR>
let g:gundo_debug = 1
let g:gundo_preview_bottom = 1

" NERDCommenter adjustments
let g:NERDSpaceDelims = 1

" Location list
nmap <Leader>> :lnext<CR>
nmap <Leader>< :lprevious<CR>

" Scrollbind
nmap <Leader>sb :set scrollbind<CR>
nmap <Leader>nb :set noscrollbind<CR>

" Next
nnoremap cinb f(ci(
nnoremap canb f(ca(
nnoremap cinB f{ci{
nnoremap canB f{ca{
nnoremap cin( f(ci(
nnoremap can( f(ca(
nnoremap cin{ f{ci{
nnoremap can{ f{ca{
nnoremap cin) f(ci(
nnoremap can) f(ca(
nnoremap cin} f{ci{
nnoremap can} f{ca{
nnoremap cin[ f[ci[
nnoremap can[ f[ca[
nnoremap cin] f[ci[
nnoremap can] f[ca[
nnoremap cin< f<ci<
nnoremap can< f<ca<
nnoremap cin> f<ci<
nnoremap can> f<ca<
nnoremap cin' f'ci'
nnoremap can' f'ca'
nnoremap cin" f"ci"
nnoremap can" f"ca"

nnoremap dinb f(di(
nnoremap danb f(da(
nnoremap dinB f{di{
nnoremap danB f{da{
nnoremap din( f(di(
nnoremap dan( f(da(
nnoremap din{ f{di{
nnoremap dan{ f{da{
nnoremap din) f(di(
nnoremap dan) f(da(
nnoremap din} f{di{
nnoremap dan} f{da{
nnoremap din[ f[di[
nnoremap dan[ f[da[
nnoremap din] f[di[
nnoremap dan] f[da[
nnoremap din< f<di<
nnoremap dan< f<da<
nnoremap din> f<di<
nnoremap dan> f<da<
nnoremap din' f'di'
nnoremap dan' f'da'
nnoremap din" f"di"
nnoremap dan" f"da"

nnoremap yinb f(yi(
nnoremap yanb f(ya(
nnoremap yinB f{yi{
nnoremap yanB f{ya{
nnoremap yin( f(yi(
nnoremap yan( f(ya(
nnoremap yin{ f{yi{
nnoremap yan{ f{ya{
nnoremap yin) f(yi(
nnoremap yan) f(ya(
nnoremap yin} f{yi{
nnoremap yan} f{ya{
nnoremap yin[ f[yi[
nnoremap yan[ f[ya[
nnoremap yin] f[yi[
nnoremap yan] f[ya[
nnoremap yin< f<yi<
nnoremap yan< f<ya<
nnoremap yin> f<yi<
nnoremap yan> f<ya<
nnoremap yin' f'yi'
nnoremap yan' f'ya'
nnoremap yin" f"yi"
nnoremap yan" f"ya"

nnoremap ciNb F(ci(
nnoremap caNb F(ca(
nnoremap ciNB F{ci{
nnoremap caNB F{ca{
nnoremap ciN( F(ci(
nnoremap caN( F(ca(
nnoremap ciN{ F{ci{
nnoremap caN{ F{ca{
nnoremap ciN) F(ci(
nnoremap caN) F(ca(
nnoremap ciN} F{ci{
nnoremap caN} F{ca{
nnoremap ciN[ F[ci[
nnoremap caN[ F[ca[
nnoremap ciN] F[ci[
nnoremap caN] F[ca[
nnoremap ciN< F<ci<
nnoremap caN< F<ca<
nnoremap ciN> F<ci<
nnoremap caN> F<ca<
nnoremap ciN' F'ci'
nnoremap caN' F'ca'
nnoremap ciN" F"ci"
nnoremap caN" F"ca"

nnoremap diNb F(di(
nnoremap daNb F(da(
nnoremap diNB F{di{
nnoremap daNB F{da{
nnoremap diN( F(di(
nnoremap daN( F(da(
nnoremap diN{ F{di{
nnoremap daN{ F{da{
nnoremap diN) F(di(
nnoremap daN) F(da(
nnoremap diN} F{di{
nnoremap daN} F{da{
nnoremap diN[ F[di[
nnoremap daN[ F[da[
nnoremap diN] F[di[
nnoremap daN] F[da[
nnoremap diN< F<di<
nnoremap daN< F<da<
nnoremap diN> F<di<
nnoremap daN> F<da<
nnoremap diN' F'di'
nnoremap daN' F'da'
nnoremap diN" F"di"
nnoremap daN" F"da"

nnoremap yiNb F(yi(
nnoremap yaNb F(ya(
nnoremap yiNB F{yi{
nnoremap yaNB F{ya{
nnoremap yiN( F(yi(
nnoremap yaN( F(ya(
nnoremap yiN{ F{yi{
nnoremap yaN{ F{ya{
nnoremap yiN) F(yi(
nnoremap yaN) F(ya(
nnoremap yiN} F{yi{
nnoremap yaN} F{ya{
nnoremap yiN[ F[yi[
nnoremap yaN[ F[ya[
nnoremap yiN] F[yi[
nnoremap yaN] F[ya[
nnoremap yiN< F<yi<
nnoremap yaN< F<ya<
nnoremap yiN> F<yi<
nnoremap yaN> F<ya<
nnoremap yiN' F'yi'
nnoremap yaN' F'ya'
nnoremap yiN" F"yi"
nnoremap yaN" F"ya"
