set nocompatible                " Enable modern Vim features.
set number                      " Enable line numbers.
let mapleader = " "             " Set leader to <space>, default it <\>
set ignorecase smartcase        " Ignore case when lower case search
" set clipboard=unnamedplus       " Shared clipboard between OS and Vim
set colorcolumn=80              " Add a bar at 80
set hlsearch                    " Enable highlighted search
set hidden
set directory^=$HOME/.vim/swap//
set tabstop=2       " The width of a TAB is set to 2.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 2.
set shiftwidth=2    " Indents will have a width of 2
set softtabstop=2   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
let g:incsearch#auto_nohlsearch = 1

" -----------------------------------------------------------------------------
" Plugins

set rtp+=/usr/local/opt/fzf

call plug#begin('~/.vim/plugged')
" Plug 'qpkorr/vim-bufkill'
Plug 'SirVer/ultisnips'
Plug 'agude/vim-eldar'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" Plug 'vim-syntastic/syntastic'
Plug 'easymotion/vim-easymotion'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'

" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plug 'google/vim-glaive'
call plug#end()
call glaive#Install()

" -----------------------------------------------------------------------------
" PLUGIN RELATED SETTINGS

if executable('clangd')
    augroup vim_lsp_cpp
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
                    \ })
	autocmd FileType c,cpp,objc,objcpp,cc setlocal omnifunc=lsp#complete
    augroup end
endif

" set completeopt+=menuone

nnoremap gd   :LspDefinition<CR>
nnoremap gt   :LspTypeDefinition<CR>
nnoremap st   :LspPeekTypeDefinition<CR>
nnoremap sd   :LspPeekDefinition<CR>
nnoremap gr   :LspReferences<CR>
nnoremap gR   :LspRename<CR>

" Send async completion requests.
" WARNING: Might interfere with other completion plugins.
let g:lsp_async_completion = 1

" Enable UI for diagnostics
let g:lsp_signs_enabled = 1           " enable diagnostics signs in the gutter
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

" Automatically show completion options
let g:asyncomplete_auto_popup = 1

" Force refresh completion
imap <c-space> <Plug>(asyncomplete_force_refresh)

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  " autocmd FileType dart AutoFormatBuffer dartfmt
  " autocmd FileType go AutoFormatBuffer gofmt
  " autocmd FileType gn AutoFormatBuffer gn
  " autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  " autocmd FileType java AutoFormatBuffer google-java-format
  " autocmd FileType python AutoFormatBuffer yapf
  " " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  " autocmd FileType rust AutoFormatBuffer rustfmt
  " autocmd FileType vue AutoFormatBuffer prettier
  " autocmd FileType swift AutoFormatBuffer swift-format
augroup END

" Preview window
set completeopt+=preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Use tab-complete for code completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" EasyMotion related settings
map <leader><leader>. <Plug>(easymotion-repeat)
map <leader><leader>f <Plug>(easymotion-overwin-f)
map <leader><leader>j <Plug>(easymotion-overwin-line)
map <leader><leader>k <Plug>(easymotion-overwin-line)
map <leader><leader>w <Plug>(easymotion-overwin-w)

let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetDirectories = ['~/UltiSnips', 'UltiSnips']

nnoremap <leader>ne :LspNextError<CR>
nnoremap <leader>pe :LspPreviousError<CR>
nnoremap <leader>nw :LspNextWarning<CR>
nnoremap <leader>pw :LspPreviousWarning<CR>
nnoremap <leader>nd :LspNextDiagnostic<CR>


" -----------------------------------------------------------------------------
" Theme preference

set background=dark
colorscheme eldar

" -----------------------------------------------------------------------------
" Highlight trailing whitespaces

set nolist
highlight default link TrailingWhitespace Error
augroup filetypedetect
  autocmd WinEnter,BufNewFile,BufRead * match TrailingWhitespace /\s\+$/
augroup END
autocmd InsertEnter * match none
autocmd InsertLeave * match TrailingWhitespace /\s\+$/

" -----------------------------------------------------------------------------
" Highlight the current line.
set cursorline

" Highlight only in the active buffer.
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Add only underline to cursorline and no other color.
au Colorscheme * :hi CursorLine cterm=underline term=underline ctermbg=NONE guibg=NONE

" -----------------------------------------------------------------------------
" KEYBOARD SHORTCUTS

nnoremap Y y$

nmap  <C-p>     :Files<CR>
nmap  <Leader>b :Buffers<CR>
nmap  <Leader>c :Commands<CR>
nmap  <Leader>l :Lines<CR>
nmap  <Leader>h :History<CR>
nmap  // :BLines!<CR>
nmap  ?? :Rg!<CR>

" -----------------------------------------------------------------------------
"  COMMANDS

command! Config execute ":e $MYVIMRC"
command! Reload execute "source $MYVIMRC"

" -----------------------------------------------------------------------------
" Turn plugins on.

filetype plugin indent on
syntax enable

" This is needed to get Ultisnips to work>
set rtp^=$HOME
" -----------------------------------------------------------------------------
