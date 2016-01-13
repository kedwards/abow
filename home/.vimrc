" KnC vIM configuration
"{{{ onLoad
let installPlugins = 0
if !filereadable($HOME . "/.vim/autoload/plug.vim")
    echo "~≥ Installing vim-plug \n"
    silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let installPlugins = 1
endif
"}}}
" vim-plug {{{
call plug#begin('~/.vim/plugged')
    "Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' }
    Plug 'bling/vim-airline'
    Plug 'chrisbra/NrrwRgn'
    Plug 'ervandew/supertab'
    Plug 'jeetsukumaran/vim-buffergator'
    "Plug 'joonty/vim-phpqa', { 'for': 'php' }
    "Plug 'joonty/vdebug', { 'for': 'php' }
    "Plug 'joonty/vim-phpunitqf', { 'for': 'php' }
    Plug 'ctrlpvim/ctrlp.vim'
	Plug 'mattn/emmet-vim'
    Plug 'othree/html5.vim', { 'for': 'html' }
    Plug 'scrooloose/nerdtree'
    Plug 'scrooloose/syntastic'
	Plug 'sjl/gundo.vim'
    "Plug 'spf13/PIV', { 'for': 'php' }
    Plug 'terryma/vim-multiple-cursors'
    Plug 'tomasr/molokai'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-unimpaired'
    "Plug 'wdalmut/vim-phpunit', { 'for': 'php' }
    "Plug 'StanAngeloff/php.vim', { 'for': 'php' }
    "Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
call plug#end()
" Plugin Configurations {{{
    " vim-airline {{{
        let g:airline#extensions#tabline#enabled = 1
    " }}}
    " emmet-vim {{{
	    let g:user_emmet_install_global = 0
	    autocmd FileType html,css,php EmmetInstall
    " }}}
    " gundo.vim {{{
	    " toggle gundo
	    nnoremap <F4> :GundoToggle<CR>
    " }}}
    " nerdtree {{{
	    " toggle nerdtree display
	    nnoremap <F3> :NERDTreeToggle<CR>

	    " Start NERDTree if no file is issued on start
	    autocmd vimenter * if !argc() | NERDTree | endif

	    " Close vim if only window is NERDTree
	    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    " }}}
    " syntastic {{{
        "let g:syntastic_check_on_open=1
        "let g:syntastic_enable_signs=1
        "let g:syntastic_enable_balloons = 1
        "let g:syntastic_auto_loc_list=1
        "let g:syntastic_mode_map = { 'mode': 'active',
        "            \                   'active_filetypes' : [],
        "            \                   'passive_filetypes' : ['php'] }
    "}}}
    " vdebug {{{
	    " disable default mappings, and add some useful mappings
	    " have a lot of conflicts with other plugins
	    "let g:vim_debug_disable_mappings = 1
        let g:vdebug_options = {"on_close":"detach"}
        let g:vdebug_features = {'max_depth':3}
	    "map <F5> :Dbg over<CR>
	    "map <F6> :Dbg into<CR>
	    "map <F7> :Dbg out<CR>
	    "map <F8> :Dbg here<CR>
	    "map <F9> :Dbg break<CR>
	    "map <F10> :Dbg watch<CR>
	    "map <F11> :Dbg down<CR>
	    "map <F12> :Dbg up<CR>
    " }}}
    " vim-php-namespace {{{
	    " adds the corresponding use statement for the class under the cursor
	    "inoremap <leader>u <C-O>:call PhpInsertUse()<CR>
	    "noremap <leader>u :call PhpInsertUse()<CR>

	    " expands the class name under the cursor to its fully qualified name.
	    :inoremap <Leader>e <C-O>:call PhpExpandClass()<CR>
	    :noremap <Leader>e :call PhpExpandClass()<CR>
    " }}}
" }}}
" }}}
"{{{ Plugin Install
if installPlugins == 1
    echo "~> Installing plugs\n"
    :PlugInstall
endif
"}}}
" General {{{
    " make vIM not vi comptible
    " '[no]comptible' '[no]cp'
    set nocompatible

    " read config from files
    set modeline

    " number of lines to check for set commands
    " 'modelines' 'mls'
    set modelines=1

    " faster redraw
    " '[no]ttyfast' '[no]tf'
    set ttyfast

    " Enable filetype specific plugins
    " 'add-plugin' 'plugin'
    filetype plugin on

    " indent based on file type syntax
    filetype indent on

    " Enable syntax highlighting
    syntax on

    " Use <F11> to toggle between 'paste' and 'nopaste'
    set pastetoggle=<F11>

    " Sets how many lines of history
    set history=100

    " Change Working Directory to that of the current file
    cmap cwd lcd %%
    cmap cd. lcd %%
" }}}
" Color, Fonts, & Encoding {{{
    " backround style
    " 'background' 'bg'
    set background=dark

    "colorscheme
    colorscheme molokai

    " unix as default filetype
    set ffs=unix,dos,mac

    " utf-8
    " 'encoding' 'enc' 'e543'
    set encoding=utf-8
" }}}
" Leader {{{
    " escape from insert and visual mode
    inoremap jk <ESC>

    " set map leader globally
    let mapleader = ","
    let g:mapleader = ","
    noremap \ ,

    " ,c - copy
    nnoremap <leader>c "+y

    " ,v - paste
    nnoremap <leader>v "+gP

    " ,v - edit .vimrc in a vertical split
    nnoremap <leader>ee :vsplit $MYVIMRC<CR>

    " ,e[w|s|v|t] -
    cnoremap %% <C-R>=fnameescape(expand('%:p:h')).'/'<CR>
    nnoremap <leader>ew :e %%
    nnoremap <leader>es :sp %%
    nnoremap <leader>ev :vsp %%
    nnoremap <leader>et :tabe %%

    " ,f
    " Highlight current line and current column
    nnoremap <leader>f :set cursorline! cursorcolumn!<CR>

    " ,ln - toggle line number format
    nnoremap <leader>ln :setlocal relativenumber!<CR>

    " ,ss - toggle spellcheck
    nnoremap <leader>ss :set spell!<CR>

    " ,<TAB> - toggle whitespace visibility
    nnoremap <leader><TAB> :set list!<CR>

    " ,q - close the current buffer
    nnoremap <leader>q :bw<CR>

    " ,Q -close the current window
    nnoremap <leader>Q <C-w>c

    " ,w - fast saving
    nnoremap <leader>w :w!<CR>

    " ,<SPACE> - enable and disable search highlighting
    nnoremap <leader><SPACE> :set hlsearch!<CR>

    " ,W - clear trailing whitespace
    nnoremap <leader>W :%s/\s\+$//<CR><C-o>
" }}}
" UI & Layout {{{
    " display characters
    " 'listchars' 'lcs'
    if &encoding == "utf-8"
        exe "set listchars=eol:\u00ac,nbsp:\u2423,conceal:\u22ef,tab:\u25b8\u2014,precedes:\u2026,extends:\u2026"
    else
        set listchars=eol:$,tab:>-,extends:>,precedes:<,conceal:+
    endif

    " Remap vIM 0 to first non-blank character
    nnoremap 0 ^

    " Select whole buffer
    nnoremap vaa ggvGg_

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Disable sounds on errors
    set noerrorbells
    set novisualbell
    set t_vb=
    set tm=500

    " show line numbers
    " 'nu' 'number'
    set number

    " show command in last line of screen
    "  '[no]showcmd' '[no]sc'
    set showcmd

    " Insert, Replace or Visual mode put a message on the last line.
    " '[no]showmode' '[no]smd'
    set showmode

    " show ruler
    set ruler

    " highlight active line
    "  '[no]cursorline' '[no]cul'
    set nocursorline

    " Set WiLd menu for auto-completion
    " invoke command completion when willdchar is used (<tab>)
    " 'wildmenu' 'wmnu' 'nowildmenu' 'nowmnu'
    set wildmenu

    " Multiple match, list all matches and complete till longest common string\
    "  completion mode used for the character specified with 'wildchar'
    " 'wildmode' 'wim'
    set wildmode=list:longest,full

    " ignore image, temp, vcs, and compiled files
    set wildignore+=*.png,*.gif,*.jpg,*.ico,*~,*.git

    " briefly higlight and jump to matching parenthesis
    " '[no]showmatch' '[no]sm'
    set showmatch
    set matchpairs=(:),{:},[:]

    " characters that can be deleted in insert mode
    set backspace=indent,eol,start

    " Keep 3 lines below and above the cursor
    set scrolloff=3

    " keep 3 lines to the left and right of the screen, if 'nowrap' is set
    set sidescrolloff=3

    " allows all operations to work with system clipboard
    set clipboard=unnamed

    " set spellcheck language
    set spelllang=en_ca

    " Allow using the repeat operator with a visual selection (!)
    vnoremap . :normal .<CR>

    " Disable mouse control I use console vIM
    set mouse=

    " Uppercase typed word from insert mode
    inoremap <C-u> <esc>mzgUiw`za
" }}}
" Status Line {{{
   " influences when the last window will have a status line:
    " 0: never, 1: at least two windows, 2: always
    set laststatus=2
    "set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
    "               | | | | |  |    |     |   |     |    |
    "               | | | | |  |    |     |   |     |    +-- current column
    "               | | | | |  |    |     |   |     +-- current line
    "               | | | | |  |    |     |   +-- current % into file
    "               | | | | |  |    |     +-- current syntax in square brackets
    "               | | | | |  |    +-- current fileformat
    "               | | | | |  +-- number of lines
    "               | | | | +-- preview flag in square brackets
    "               | | | +-- help flag in square brackets
    "               | | +-- readonly flag in square brackets
    "               | +-- rodified flag in square brackets
    "               +-- full path to file in the buffer
" }}}
" Spaces & Tabs {{{
    " number of spaces a tab will replace
    " 'tabstop' 'ts'
    set tabstop=4

    " number of spaces for tab whle editing
    " 'softtabstop' 'sts'
    set softtabstop=4

    " expand tabs to spaces in IM
    " '[no]expandtab' '[no]et'
    set expandtab

    " count spaces for indentation (<<,>>)
    " 'shiftwidth' 'sw'
    set shiftwidth=4

    " toggle folds with spacebar
    nnoremap <SPACE> za

    " Create Blank Newlines and stay in Normal mode
    nnoremap <silent> zj o<Esc>
    nnoremap <silent> zk O<Esc>

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Prevents inserting two spaces after punctuation on a join
    set nojoinspaces
" }}}
" Searching {{{
    " turns off vIM’s crazy default regex characters
    nnoremap / /\v
    vnoremap / /\v

    " type S, then type what you're looking for, a /, and what to replace it with
    nmap S :%s//g<LEFT><LEFT>
    vmap S :s//g<LEFT><LEFT>

    " case of normal letters is ignored
    " 'ignorecase'
    set ignorecase

    " override 'ignorecase' option if the search contains upper case characters.
    " '[no]smartcase' '[no]scs'
    set smartcase

    " applies substitutions globally on lines
    " '[no]gdefault' '[no]gd'
    set gdefault

    " shows patter as typed so far
    " '[no]incsearch' '[no]is'
    set incsearch

    "highlight previous search matches
    " '[no]hlsearch' '[no]hls'
    set hlsearch

    " Searches the current directory as well as subdirectories with commands like :find, :grep, etc.
    set path=.,**

    " clear highlighted matches
    "nnoremap <leader><space> :noh<cr>

    " jump to matching bracket
    nnoremap <tab> %
    vnoremap <tab> %

    " make it so that going to the next one in a search will center on the line it's found in.
    map N Nzz
    map n nzz
" }}}
" Windows Navigation {{{
    "  vsplit window will put the new window right of the current one
    " '[no]splitright' '[no]spr'
    set splitright

    "  split window will put the new window above the current one
    "  '[no]splitbelow' '[no]sb'
    set splitbelow

    " ,hljk - move between windows
    nnoremap <leader>h <C-w>h
    nnoremap <leader>l <C-w>l
    nnoremap <leader>j <C-w>j
    nnoremap <leader>k <C-w>k

    " New split vertical
    noremap <leader>wv <C-w>v

    " New split horizontal
    noremap <leader>ws <C-w>s
    " Vertical window creation
    nmap <leader>wh :topleft vnew<cr>
    nmap <leader>wl :botright vnew<cr>
    nmap <leader>bh :leftabove vnew<cr>
    nmap <leader>bl :rightbelow vnew<cr>

    " Horizontal window creation
    nmap <leader>wk :topleft new<cr>
    nmap <leader>wj :botright new<cr>
    nmap <leader>bk :leftabove new<cr>
    nmap <leader>bj :rightbelow new<cr>

    " Create a tab
    nmap <leader>t :tabnew<cr>

    " Cycle through windows
    noremap <leader>ww <C-w><C-w>
" }}}
" Tab navigation {{{
    map tn :tabn<CR>
    map tp :tabp<CR>
    map tm :tabm
    map tt :tabnew
    map ts :tab split<CR>
    map <C-S-Right> :tabn<CR>
    imap <C-S-Right> <ESC>:tabn<CR>
    map <C-S-Left> :tabp<CR>
    imap <C-S-Left> <ESC>:tabp<CR>
" }}}
" Movements {{{
    " move display line not linewise
    nnoremap j gj
    nnoremap k gk

    " use <TAB> to move to matching bracket
    nnoremap <TAB> %
    vnoremap <TAB> %
" }}}
" Backup & Files {{{
    " viminfo file - remember settings between sessions
    "set viminfo=%,<250,'50,/50,:100,h,f1,n~/.vim/viminfo
    "            |  |    |   |   |   |  |     |
    "            |  |    |   |   |   |  |     |
    "            |  |    |   |   |   |  |     |
    "            |  |    |   |   |   |  |     |
    "            |  |    |   |   |   |  |     +-- name of the viminfo file
    "            |  |    |   |   |   |  +-- file marks ('0 to '9, 'A to 'Z) are stored
    "            |  |    |   |   |   +-- disable the effect of 'hlsearch' when loading the viminfo
    "            |  |    |   |   +-- maximum number of items in the command-line history
    "            |  |    |   +-- max number of items in the search pattern history
    "            |  |    +-- max number of marks to save for previously edited files
    "            |  +-- max lines saved for each register
    "            +-- save/restore buffer list


    " backup files, if folder exist..create file (reverse logic nested)
    " '[no]writebackup' '[no]wb'
    if isdirectory($HOME . '/.vim/backup') == 1
        silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
        set backupdir=~/.vim/backup/
        set backup
        set writebackup

        " Prevent backups from overwriting each other. The naming is weird,
        " So the file '/home/docwhat/.vimrc' becomes '.vimrc%home%docwhat~'
        if has("autocmd")
            autocmd BufWritePre * let &backupext = substitute(expand('%:p:h'), '/', '%', 'g') . '~'
        endif
    endif

    " swap files, if folder exist..create file (reverse logic nested)
    " '[no]swap' '[no]swapfile'
    set noswapfile
    if isdirectory($HOME . '/.vim/swap') == 1
        silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
        set directory=~/.vim/swap//
    endif

    " Undo configuration,
    if exists("+undofile")
        if isdirectory($HOME . '/.vim/undo') == 1
            silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
        endif
        set undodir=~/.vim/undo//
        set undofile
    endif
" }}}
" Auto Commands {{{
    if has('autocmd')
        " Auto source .vimrc on save
        autocmd bufwritepost .vimrc source $MYVIMRC

        " Auto update file if externally changed
        autocmd CursorHold * checktime

        " Treat .json as javascript
        autocmd BufNewFile,BufRead *.json set ft=javascript

        " When editing a file, always jump to the last known cursor position.
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    endif
" }}}
" vim:fdm=marker:ts=4:sw=4:et
