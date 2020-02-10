"
" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
"


"##############################################################################
" Plugins :
"##########
call plug#begin('~/.config/nvim/plugged')

" Onedark color-scheme
Plug 'joshdick/onedark.vim'
let g:onedark_terminal_italics = 1
let g:onedark_termcolors = 256

" Handy surrounding tools
Plug 'tpope/vim-surround'

" Handy commenting tools
Plug 'scrooloose/nerdcommenter'

" Tags sidebar
Plug 'majutsushi/tagbar'
" Ctrl+T -> Toggles the tagbar
map <C-t> :TagbarToggle<CR>

" Display vertical line for indentation levels
Plug 'Yggdroot/indentLine'
let g:indentLine_faster = 1
let g:indentLine_char = '┃'
let g:indentLine_first_char = '┃'
let g:indentLine_showFirstIndentLevel = 1

" Show a git diff in the gutter
Plug 'airblade/vim-gitgutter'

" Simple status lines
Plug 'itchyny/lightline.vim'
let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name'
    \ },
    \ }

" Used to display the active branch in lightline
Plug 'itchyny/vim-gitbranch'

" System explorer
Plug 'scrooloose/nerdtree'
" Ctrl+N -> Map open/close NERDTree to Ctrl+N
map <C-n> :NERDTreeToggle<CR>
" Ctrl+Alt+N -> Focus NERDTree window (open it if it's closed)
map <C-A-n> :NERDTreeFocus<CR>
" Start NERDTree when no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Start NERDTree when a directory is opened
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) &&
    \ !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Open files with split
let NERDTreeMapOpenSplit = 'h'
let NERDTreeMapOpenVSplit = 'v'

" Add nice font icons
Plug 'ryanoasis/vim-devicons'

call plug#end()
"##############################################################################

"##############################################################################
" Color-scheme :
"###############

set background=dark
colorscheme onedark
set termguicolors
" Fixes methods' arguments color in the Tagbar
hi TagbarSignature guifg=#80AAFF

" Disables color-scheme background color
hi Normal guibg=NONE

" Have italic comments
hi Comment cterm=italic gui=italic

" Set a syntax for some extenstions
au BufReadPost *.opml setlocal syntax=xml | setlocal filetype=xml
au BufReadPost *.rasi setlocal syntax=css | setlocal filetype=css
au BufReadPost *.vue setlocal syntax=html

"##############################################################################

"##############################################################################
" Indentation :
"##############

set tabstop=4               " Number of visual spaces per Tab
set softtabstop=4           " Number of spaces in tab when editing
set shiftwidth=4            " Number of spaces to use for autoindent
set expandtab               " Tabs are spaces
set copyindent              " Copy the indentation from the previous line
set autoindent              " Automatically indent new lines

"##############################################################################

"##############################################################################
" Search :
"#########

set incsearch               " Search as characters are typed
set hlsearch                " Highlight matches
set ignorecase              " Ignore case when searching
set smartcase               " Ignore case when only lower case is typed

"##############################################################################

"##############################################################################
" Keybindings :
"##############

" Ctrl+[Left | Right] -> tabs navigation
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Ctrl+Up -> insert ':tabnew ' in the command line
nnoremap <C-Up> :tabnew <right>

" Ctrl+Down -> close the current tab (can't close the last one)
nnoremap <C-Down> :tabclose<CR>

" F2 -> Replaces TABs with spaces
nnoremap <F2> :retab <CR> :w! <CR>

" F3 -> Toggle the coloring of the 80th column
nnoremap <F3> :call ToggleCC()<CR>

" ù -> Disables the highlighting of matched regex ('ù' key is next to '*')
nnoremap ù :noh<CR>

" Ctrl+[C | P] -> Copy / Paste with system's clipboard
vnoremap <C-c> "+y<CR>
map <C-p> "+p

"##############################################################################

"##############################################################################
" Commands :
"###########

" Delete all the buffers not opened in a window or a tab
" See: https://stackoverflow.com/a/7321131
function! DeleteInactiveBufs()
    " From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        " bufno exists AND isn't modified AND isn't in the list of buffers open
        " in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! ClearBuffers :call DeleteInactiveBufs()

" Toggles the coloring of the 80th column
function! ToggleCC()
    if &cc == ''
        set cc=80
    else
        set cc=
    endif
endfunction

"##############################################################################

"##############################################################################
" Auto-commands :
"################

" Delete trailing whitespaces on save
autocmd BufRead,BufNewFile * %s/\s\+$//e

"##############################################################################

"##############################################################################
" Other settings :
"#################

set number                  " Line numbers
set rnu                     " Display line number relative to the current one
set cursorline              " Highlight the current line
set showmatch               " Highlight matching brackets
set scrolloff=3             " Minimum lines to keep above/below cursor
set wrap                    " Wrap long lines
filetype plugin on          " Necessary for the NERDcommenter plugin
set splitbelow splitright   " Invert vim's weird default spliting directions
set autochdir               " Automatically cd into the active vim buffer

"##############################################################################

"##############################################################################
" Language specific settings :
"#############################

" Python
" Limit lines to 79 characters and toggle the coloring of the 80th column
au FileType python
    \ setlocal textwidth=79 |
    \ setlocal fileformat=unix |
    \ :call ToggleCC()

" Javascript, HTML, CSS and XML
" Change the indent width to 2 spaces
au FileType javascript,html,css,xml
    \ setlocal tabstop=2 |
    \ setlocal softtabstop=2 |
    \ setlocal shiftwidth=2

"##############################################################################

