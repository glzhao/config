""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------
" => Key Mapping
"-------------------------------------------------
" Strip all trailing whitespace in the current file
nnoremap <silent> <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" <F4> :YcmDiags<CR>
" <F5> :YcmForceCompileAndDiagnostics<CR>
" <F9> :SCCompileRun<cr>

" Easymotion
" <Leader><Leader>
" Mapping           | Details
" ------------------|----------------------------------------------
" <Leader>f{char}   | Find {char} to the right. See f.
" <Leader>F{char}   | Find {char} to the left. See F.
" <Leader>t{char}   | Till before the {char} to the right. See t.
" <Leader>T{char}   | Till after the {char} to the left. See T.
" <Leader>w         | Beginning of word forward. See w.
" <Leader>W         | Beginning of WORD forward. See W.
" <Leader>b         | Beginning of word backward. See b.
" <Leader>B         | Beginning of WORD backward. See B.
" <Leader>e         | End of word forward. See e.
" <Leader>E         | End of WORD forward. See E.
" <Leader>ge        | End of word backward. See ge.
" <Leader>gE        | End of WORD backward. See gE.
" <Leader>j         | Line downward. See j.
" <Leader>k         | Line upward. See k.
" <Leader>n         | Jump to latest "/" or "?" forward. See n.
" <Leader>N         | Jump to latest "/" or "?" backward. See N.

" <Leader>a :Ack!<Space>

" Ctrlp
" <Leader>c
" <Leader>cm :CtrlPMRUFiles<CR>
" <Leader>cn :CtrlPLine<CR>
" <Leader>cg :CtrlPBufTag<CR>
" <Leader>cl :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
" <Leader>cb :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
" <Leader>cw :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
" <Leader>cf :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>

" <leader>g  :GundoToggle<CR>

" nerdtree
" <Leader>nt :NERDTreeToggle<CR>
" <Leader>nf :NERDTreeFind<CR>

" <leader>ss :call SplitScroll()<CR>

" vimwiki
" <Leader>ww -- Open default wiki index file.
" <Leader>wt -- Open default wiki index file in a new tab.
" <Leader>ws -- Select and open wiki index file.
" <Leader>wd -- Delete wiki file you are in.
" <Leader>wr -- Rename wiki file you are in.
" <Enter> -- Folow/Create wiki link
" <Shift-Enter> -- Split and folow/create wiki link
" <Ctrl-Enter> -- Vertical split and folow/create wiki link
" <Backspace> -- Go back to parent(previous) wiki link
" <Tab> -- Find next wiki link
" <Shift-Tab> -- Find previous wiki link

" ultisnips
" <Ctrl-k>   :complete ultisnips & select next context
" <Ctrl-p>   :select previous context

" <silent>tl :TaskList<CR>
" <silent>tb :TagbarToggle<CR>

cabbr %% <C-R>=expand('%:p:h')<CR>

"Fast Ex command
nnoremap ; :
" save as sudo
ca w!! w !sudo tee "%"
" Keep the cursor in place while joining lines
nnoremap J mzJ`z
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => vundle
"--------------------------------------------------
set nocompatible
filetype off
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone git://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif

let g:vundle_default_git_proto='git'
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'gmarik/vundle'

Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'mileszs/ack.vim'
Plugin 'Lokaltog/vim-easymotion'

Plugin 'sjl/gundo.vim'

Plugin 'majutsushi/tagbar'
Plugin 'TaskList.vim'

Plugin 'IndexedSearch'
Plugin 'Raimondi/delimitMate'

Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Bundle 'tomasr/molokai'
Bundle 'phd'

Plugin 'SingleCompile'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'c.vim'
Plugin 'plasticboy/vim-markdown'

"TODO
Plugin 'sorah/presen.vim'
"Plugin 'vimwiki/vimwiki'

"Plugin 'tpope/vim-fugitive'
"Plugin 'swaroopch/vim-markdown-preview'
"Plugin 'python.vim--Vasiliev'
" pep8

call vundle#end()
" Installing plugins the first time
if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif

" Local bundles if avaiable
if filereadable(expand("~/.vimrc.bundles.local"))
    source ~/.vimrc.bundles.local
endif

filetype plugin indent on
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => Local Setting
"--------------------------------------------------
" Use local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Use local gvimrc if available and gui is running
if has('gui_running')
    if filereadable(expand("~/.gvimrc.local"))
	source ~/.gvimrc.local
    endif
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------------------------------------
" => General
"------------------------------------------------
set nocompatible		" Don't be compatible with vi
set modeline			" Allow vim options to be embedded in files;
set confirm			" Y-N-C prompt if closing with unsaved changes.
set clipboard+=unnamed		" Yanks go on clipboard instead
set backspace=indent,eol,start	" Make backspaces delete sensibly

let mapleader=','		" Change the mapleader
let maplocalleader='\'		" Change the maplocalleader
set timeoutlen=500              " Time to wait for a command

" No sound on errors
set noerrorbells novisualbell t_vb=

" Virtual editing means that the cursor can be positioned where there is
" no actual character. could let cursor move past the last char in <C-v> mode
set virtualedit=block

set shortmess=at		" avoid all the |hit-enter| prompts caused by file messages

set viewoptions+=slash,unix	" Better Unix/Windows compatibility
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------
" => Vim User Interface
"-------------------------------------------------
set ruler			" show cursor line and column in the status line
set relativenumber		" Show relative line numbers
set number			" Show line numbers
set linebreak			" don't wrap textin the middle of a word
set showmatch			" Show matching brackets/parenthesis

set fillchars=diff:⣿,vert:│	" Change fillchars
set formatoptions+=rnlmM	" Optimize format options

set showcmd			" Show cmd
set showmode			" Display mode INSERT/REPLACE/...

syntax on			" Enable syntax

set laststatus=2		" Show the statusline

set title			" show title in console title bar
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Set up gvim tab labels
set guitablabel=%m%N:%t\[%{tabpagewinnr(v:lnum)}\]
set guitabtooltip=%F		" Set gvim tab tooltips with every buffer name

set scrolljump=5		" Lines to scroll when cursor leaves screen
set scrolloff=3			" Keep 3 context lines above and below the cursor

" Set column and line cursor
autocmd WinLeave * set nocursorline nocursorcolumn
autocmd WinEnter * set cursorline cursorcolumn

autocmd BufWinLeave *.* silent! mkview " Make Vim save view (state) (folds, cursor, etc)
autocmd BufWinEnter *.* silent! loadview " Make Vim load view (state) (folds, cursor, etc)

" Only show trailing whitespace when not in insert mode with :l[ist]
augroup trailing
	autocmd!
	autocmd InsertEnter * :set listchars-=trail:⌴
	autocmd InsertLeave * :set listchars+=trail:⌴
augroup END

if has('gui_running')
	" set behavior for mouse and selection like windows
	behave mswin
	map <S-Insert> <MiddleMouse>
	map! <S-Insert> <MiddleMouse>
	set guioptions=egirLtf

	if has('gui_gtk')
		set guifont=Monospace\ 11
	elseif has('gui_win32')
		set guifont=Consolas:h11:cANSI
	endif
else
	set t_Co=256 " Use 256 colors
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => Functions
"--------------------------------------------------
function! MySys()
    if has("win32") || has('win64')
	return "windows"
    else
	return "linux"
    endif
endfunction

fu! SplitScroll()
    :wincmd v
    :wincmd w
    execute "normal! \<C-d>"
    :set scrollbind
    :wincmd w
    :set scrollbind
endfu
nmap <leader>ss :call SplitScroll()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------
" => Platform and encoding Configuration
"-------------------------------------------------
" TODO:take care of the encodings
set fileencodings=ucs-bom,utf-8,GBK,latin1
set fileformats=unix,mac,dos	" Auto detect the file formats

" multi-encoding setting
if has("multi_byte")
	" set bomb
	" set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1
	" CJK environment detection and corresponding setting
	if v:lang =~ "^zh_CN"
		" Use cp936 to support GBK, euc-cn == gb2312
		set encoding=chinese
		set termencoding=chinese
		set fileencoding=chinese
	elseif v:lang =~ "^zh_TW"
		" cp950, big5 or euc-tw
		" Are they equal to each other?
		set encoding=taiwan
		set termencoding=taiwan
		set fileencoding=taiwan
	endif
	" Detect UTF-8 locale, and replace CJK setting if needed
	if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
		set encoding=utf-8 " Set utf-8 encoding
		set termencoding=utf-8
		set fileencodings=ucs-bom,utf-8,GBK,latin1
	endif
endif

" For windows
if MySys() == 'windows'
	" On Windows, also use '.vim' instead of 'vimfiles'
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
	source $VIMRUNTIME/mswin.vim
	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim
	set langmenu=zh_CN.UTF-8

	behave mswin

	set diffexpr=MyDiff()
	function! MyDiff()
		let opt = '-a --binary '
		if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		let arg1 = v:fname_in
		if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		let arg2 = v:fname_new
		if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		let arg3 = v:fname_out
		if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		let eq = ''
		if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
				let cmd = '""' . $VIMRUNTIME . '\diff"'
				let eq = '"'
			else
				let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		else
			let cmd = $VIMRUNTIME . '\diff'
		endif
		silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------
" => Indent and Tab Related
"-------------------------------------------------
set autoindent		" Preserve current indent on new lines
set smartindent		" use smart indent if there is no indent file

" keep 'tabstop' at 8, set 'softtabstop' and 'shiftwidth' to 4 (or whatever you prefer)
" and use 'noexpandtab'. Then Vim will use a mix of tabs and spaces, but typing <Tab>
" and <BS> will behave like a tab appears every 4 (or whatever you set before) characters.
set noexpandtab tabstop=8 softtabstop=8
" Round indent to multiple of 'shiftwidth, used for cindent, >>, <<, etc
set shiftround shiftwidth=8
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------
" => Auto complete in VIM
"-------------------------------------------------
set wildmenu			" Show list instead of just completing
set wildmode=list:longest,full	" Use powerful wildmenu
" Ignore these files when completing
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*	" for Linux/MacOSX
set wildignore+=.git\*,.hg\*,.svn\*		" for Windows
set wildignore+=*.o,*.obj,.git,*.pyc

set completeopt+=longest	" Optimize auto complete

" Automatically close autocompletition window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------
" => Search Related
"-------------------------------------------------
set ignorecase			" Case insensitive search
set smartcase			" Case sensitive when uc present

set hlsearch			" Highlight search terms
set incsearch			" Find as you type search
set magic			" changes special characters in search patterns (default)

" Keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => Plugin configurations
"--------------------------------------------------
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => Valloric/YouCompleteMe
"--------------------------------------------------
":YcmDiags show if any errors or warnings were detected in your file.
nmap <F4> :YcmDiags<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

" symbol for errors and warnings
let g:ycm_error_symbol='>>'
let g:ycm_warning_symbol='>*'

" YCM will show the completion menu even when typing inside comments
let g:ycm_complete_in_comments = 1

" YCM will ask once per .ycm_extra_conf.py it is safe to be loaded if == 1
let g:ycm_confirm_extra_conf = 0

"let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']

let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'mail' : 1
      \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => SirVer/ultisnips
"--------------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" Complete the ultisnips
let g:UltiSnipsExpandTrigger="<c-k>"
" Jump to the next context
let g:UltiSnipsJumpForwardTrigger="<c-k>"
" Jump to the previous context
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

" If you want :UltiSnipsEdit to split your window.
 let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => GunDo
"--------------------------------------------------

map <leader>g :GundoToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => TaskList
"--------------------------------------------------
"
map <silent>tl :TaskList<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => vim-colors-solarized / molokai
"--------------------------------------------------
"let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
set background=dark

let g:molokai_original = 1
set t_Co=256
if has('gui_running')
    colorscheme solarized
    "colorscheme molokai
    "colorscheme phd
else
    "colorscheme solarized
    colorscheme molokai
    "colorscheme phd
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => scrooloose/nerdtree
"--------------------------------------------------
" turn off the plug at the start
" let loaded_nerd_tree=0

nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>
"let NERDTreeChDirMode=2
"let NERDTreeShowBookmarks=1
"let NERDTreeShowHidden=1
"let NERDTreeShowLineNumbers=1
"let NERDTreeDirArrows=1
"let NERDTreeIgnore=['\.vim$', '\~$','\.o$']
"let NERDTreeMapActivateNode="<CR>"

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => kien/ctrlp.vim
"--------------------------------------------------
let g:ctrlp_map = '<Leader>c'
nmap <Leader>cm :CtrlPMRUFiles<CR>
nmap <Leader>cn :CtrlPLine<CR>
nmap <Leader>cg :CtrlPBufTag<CR>
nmap <Leader>cl :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nmap <Leader>cb :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nmap <Leader>cw :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nmap <Leader>cf :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>

" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
,   call feedkeys(a:search_text)
endfunction

let g:ctrlp_working_path_mode=0
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_cache_dir=$HOME.'/.vim/.cache/ctrlp'
let g:ctrlp_extensions=['tag', 'buffertag', 'quickfix', 'dir', 'rtscript']
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => Easymotion.vim
"--------------------------------------------------
let g:EasyMotion_leader_key = '<Leader><Leader>'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => mileszs/ack.vim'
"--------------------------------------------------
if has('unix')
	if executable('ack-grep') || executable('ack')
		let g:ackprg='ack-grep -H --nocolor --nogroup --column'
	endif
endif

if executable('ack-grep') || executable('ack')
    nnoremap <Leader>a :Ack!<Space>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => vimwiki
"--------------------------------------------------
"TODO
"<Leader>ww -- Open default wiki index file.
"<Leader>wt -- Open default wiki index file in a new tab.
"<Leader>ws -- Select and open wiki index file.
"<Leader>wd -- Delete wiki file you are in.
"<Leader>wr -- Rename wiki file you are in.
"<Enter> -- Folow/Create wiki link
"<Shift-Enter> -- Split and folow/create wiki link
"<Ctrl-Enter> -- Vertical split and folow/create wiki link
"<Backspace> -- Go back to parent(previous) wiki link
"<Tab> -- Find next wiki link
"<Shift-Tab> -- Find previous wiki link
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => tagbar
"--------------------------------------------------
map <silent>tb :TagbarToggle<CR>
let g:tagbar_width = 30
let g:tagbar_expand = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => delimitMate
"--------------------------------------------------
let delimitMate_expand_cr=1
"let delimitMate_expand_space=1
let delimitMate_balance_matchpairs=1

" CR/S-CR: close popup and save indent
" inoremap <expr><CR> delimitMate#WithinEmptyPair() ? "\<C-R>=delimitMate#ExpandReturn()\<CR>" : pumvisible() ? neocomplcache#close_popup() : "\<CR>"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => IndexedSearch
"--------------------------------------------------
let g:indexed_search_shortmess=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => vim-airline
"--------------------------------------------------
" enable iminsert detection
let g:airline_detect_iminsert=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => Singlecompile
"--------------------------------------------------
nmap <F9> :SCCompileRun<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => c.vim
"--------------------------------------------------
" TODO Investigate it futher
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => vim-markdown
"--------------------------------------------------
" set the initial foldlevel. Defaults is 0 (i.e. all folds are closed)
let g:vim_markdown_initial_foldlevel=1

" "]]: go to next header.
" "[[: go to previous header. Contrast with ]c.
" "][: go to next sibling header if any.
" "[]: go to previous sibling header if any.
" "]c: go to Current header.
" "]u: go to parent header (Up).
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--------------------------------------------------
" => cscope
"--------------------------------------------------
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate
    if MySys() == "linux"
      set csprg=/usr/bin/cscope
    else
      set csprg=cscope
    endif

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=1
    set nocscopeverbose
    " add any cscope database in current directory
    if filereadable("cscope.out")
	cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
	cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose
    """"""""""""" My cscope/vim key mappings
    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "
    nmap <Leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <Leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <Leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
    """"""""""""" key map timeouts
    "set ttimeoutlen=100
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------------------------------------------
" => Filetype Specific
"-------------------------------------------------
" C
augroup ft_c
    autocmd!
    autocmd Filetype c setlocal cindent noexpandtab softtabstop=8 tabstop=8 shiftround shiftwidth=8
    autocmd Filetype c setlocal textwidth=80 colorcolumn=81
    autocmd Filetype c hi ColorColumn ctermbg=lightRed guibg=lightRed
augroup END

augroup ft_cpp
    autocmd!
    autocmd Filetype cpp setlocal cindent noexpandtab softtabstop=8 tabstop=8 shiftround shiftwidth=8
    autocmd Filetype cpp setlocal textwidth=80 colorcolumn=81
    autocmd Filetype cpp hi ColorColumn ctermbg=lightRed guibg=lightRed
augroup END

" Markdown
augroup ft_markdown
    autocmd!
    " Use <localLeader>1/2/3/4/5/6 to add headings
    autocmd Filetype markdown nnoremap <buffer> <localLeader>1 I# <ESC>
    autocmd Filetype markdown nnoremap <buffer> <localLeader>2 I## <ESC>
    autocmd Filetype markdown nnoremap <buffer> <localLeader>3 I### <ESC>
    autocmd Filetype markdown nnoremap <buffer> <localLeader>4 I#### <ESC>
    autocmd Filetype markdown nnoremap <buffer> <localLeader>5 I##### <ESC>
    autocmd Filetype markdown nnoremap <buffer> <localLeader>6 I###### <ESC>
    " Use <LocalLeader>b to add blockquotes in normal and visual mode
    autocmd Filetype markdown nnoremap <buffer> <localLeader>b I> <ESC>
    autocmd Filetype markdown vnoremap <buffer> <localLeader>b :s/^/> /<CR>
    " Use <localLeader>ul and <localLeader>ol to add list symbols in visual mode
    autocmd Filetype markdown vnoremap <buffer> <localLeader>ul :s/^/* /<CR>
    autocmd Filetype markdown vnoremap <buffer> <LocalLeader>ol :s/^/\=(line(".")-line("'<")+1).'. '/<CR>
    " Use <localLeader>e1/2/3 to add emphasis symbols
    autocmd Filetype markdown nnoremap <buffer> <localLeader>e1 I*<ESC>A*<ESC>
    autocmd Filetype markdown nnoremap <buffer> <localLeader>e2 I**<ESC>A**<ESC>
    autocmd Filetype markdown nnoremap <buffer> <localLeader>e3 I***<ESC>A***<ESC>
augroup END

" Python
augroup ft_python
    autocmd!
    au FileType python setlocal smartindent expandtab shiftwidth=4 tabstop=8 softtabstop=4 colorcolumn=80
    au Filetype python setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with

    au BufRead *.py setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

    " code folder
    "autocmd FileType python setlocal foldmethod=indent
    "set foldlevel=99 "默认展开所有代码
augroup END
