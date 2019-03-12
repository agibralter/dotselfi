" {{{
" Make sure to pip install sqlparse
noremap <F3> :Autoformat<CR>
let g:formatdef_sql = '"sqlformat -r -k upper -i lower -"'
let g:formatters_sql = ['sql']
" }}}

" {{{ vim-jsx
let g:jsx_ext_required = 0
" }}}

" {{{ syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_wq = 0
" These are too slow right now...
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_ruby_checkers=['mri', 'rubocop']
" let g:syntastic_ruby_rubocop_exec = 'rubocop.sh'
" }}}

" {{{ markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript']
" }}}

" {{{ airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1
" }}}

" {{{ gitgutter options
let g:gitgutter_highlight_lines = 0
let g:gitgutter_sign_column_always = 0
let g:gitgutter_realtime = 0 " Don't gitgutter in realtime... too slow
let g:gitgutter_eager = 1
let g:gitgutter_max_signs = 1000
map <F6> :GitGutterLineHighlightsToggle<CR>
" }}}

" {{{ fugitive/git
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gp :Ggrep<space>
nnoremap <leader>gm :Gmove<space>
nnoremap <leader>gb :Git branch<space>
nnoremap <leader>go :Git checkout<space>
nnoremap <leader>gu :Dispatch! git upm<CR>

" same bindings for merging diffs as in normal mode
xnoremap dp :diffput<cr>
xnoremap do :diffget<cr>
" }}}

" {{{ ctrlp.vim
let g:ctrlp_map = '<leader>t'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" Do not manage project root
let g:ctrlp_working_path_mode = 0
" only jump to the buffer if it is opened in the current tab
let g:ctrlp_jump_to_buffer = 1
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|tmp$\|log$'
" }}}

" {{{ fzf.vim
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
" }}}

" {{{ NERDTree
map <leader><F2> :NERDTree<CR>
map <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\~$', '.*\.pyc$', 'pip-log\.txt$']
nnoremap <leader>rr :NERDTreeFind<CR>
let NERDTreeWinSize=30
" }}}

" {{{ Ack
map <leader>A :LAck<space>
" Set ack path
let g:ackprg="~/.bin/ack -H --nocolor --nogroup --column"
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif
" }}}

" {{{ tagbar
nmap <F8> :TagbarToggle<CR>
nmap <F9> :TagbarOpen fjc<CR>
" }}}

" {{{ matchit.vim
runtime macros/matchit.vim
" }}}

" {{{ solarized
" If not using iTerm 2 with Solarized, enable the 'degraded 256 colorscheme'
" let g:solarized_termcolors = 256
" let g:solarized_visibility = "high"
" let g:solarized_contrast = "high"
colorscheme solarized
call togglebg#map("<F5>")
" }}}

" {{{ Tabularize
" Align equals signs
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>

" Align by colons left-aligned; e.g.: hello: world (with negative look-behind
" so ruby symbols' colons don't get aligned)
nmap <leader>al: :Tabularize /\s\@<!:\zs/l1l0<CR>
vmap <leader>al: :Tabularize /\s\@<!:\zs/l1l0<CR>

" Align by colons center-aligned; e.g.: hello : world
nmap <leader>ac: :Tabularize /:<CR>
vmap <leader>ac: :Tabularize /:<CR>

" Align ruby hashrockets.
nmap <leader>a> :Tabularize /=><CR>
vmap <leader>a> :Tabularize /=><CR>

" Align comma tables.
nmap <leader>a, :Tabularize /,\zs/l1l0<CR>
vmap <leader>a, :Tabularize /,\zs/l1l0<CR>
" }}}

" {{{ Gundo
nnoremap U :GundoToggle<CR>
let g:gundo_debug = 1
let g:gundo_preview_bottom = 1
" }}}

" {{{ NERDCommenter adjustments
let g:NERDSpaceDelims = 1
" }}}

" vim:tw=0:ts=4:sw=4:noet:nolist:foldmethod=marker
