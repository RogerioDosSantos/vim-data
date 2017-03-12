" Type :so % to refresh .vimrc after making changes
"

" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

" Leader - ( Spacebar )
let mapleader = " "

"Change the cursor from <block> to I on insert mode.
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup      "Do not save a file with the extension ~
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
"set ruler         " show the cursor position all the time
set showcmd       " display incomplete command
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set autoread      " Reload files changed outside vim
" Trigger autoread when changing buffers or coming back to vim in terminal.
au FocusGained,BufEnter * :silent! !

"Set default font in mac vim and gvim
"set guifont=Source\ Code\ Pro\ for\ Powerline:h12
set cursorline    " highlight the current line
set visualbell    " stop that ANNOYING beeping
set wildmenu
set wildmode=list:longest,full

"Allow usage of mouse in iTerm
"set ttyfast
"set mouse=a
" set ttymouse=xterm2

" Make searching better
set gdefault      " Never have to type /g at the end of search / replace again
set ignorecase    " case insensitive searching (unless specified)
set smartcase
set hlsearch
nnoremap <silent><leader>, :noh<cr> " Stop highlight after searching
set incsearch
set showmatch

" File Explorer
nnoremap <silent><leader>e :Lexplore<cr> " Open the explorer on the left pane
let g:netrw_liststyle=3 "Put the style similar to NERDTree 
let g:netrw_banner=0    "Remove the header

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
"set list listchars=tab:»·,trail:·,nbsp:·

" Make it obvious where 120 characters is
set textwidth=120
" set formatoptions=cq
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Shortcut for splits
nnoremap <silent><leader>vv :vsplit<cr> " Vertical Split
nnoremap <silent><leader>hh :split<cr> " Horizontal Split

" Shortcut for Tabs
nnoremap <leader>tf :tabe " Open file in a new tab
nnoremap <silent><leader>tn :tabn<cr> " Open next tab
nnoremap <silent><leader>tp :tabp<cr> " Open previous tab

" Shortcut for lopen (Open a list to show the location list for current window)
nnoremap <silent><leader>ll :lopen<cr> 

" Run Shell command and display the result into a temp window
command! -complete=shellcmd -nargs=+ GetShell call s:RunShellCommand(<q-args>)

function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')

    if part[0] =~ '\v[%#<]'
      let expanded_part = fnameescape(expand(part))
      let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
    endif

  endfor

  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

nnoremap <leader>c :GetShell 

" Auto resize Vim splits to active split
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

"HTML Editing
set matchpairs+=<:>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

"Toggle relative numbering, and set to absolute on loss of focus or insert mode
set rnu
function! ToggleNumbersOn()
    set nu!
    set rnu
endfunction
function! ToggleRelativeOn()
    set rnu!
    set nu
endfunction
autocmd FocusLost * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()

"Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>
"Below is to fix issues with the ABOVE mappings in quickfix window
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-w> <C-w>w
" <c-h> is interpreted as <bs> in neovim
" This is a bandaid fix until the team decides how
" they want to handle fixing it...(https://github.com/neovim/neovim/issues/2048)
nnoremap <silent> <bs> :TmuxNavigateLeft<cr>

" Navigate properly when lines are wrapped
nnoremap j gj
nnoremap k gk

" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

" Spell check 
nnoremap <leader>se :setlocal spell spelllang=en_us<cr>:set spellfile=$HOME/.vim/spell-en.utf-8.add<cr>
nnoremap <leader>sp :setlocal spell spelllang=pt_br<cr>:set spellfile=$HOME/.vim/spell-pt.utf-8.add<cr>
nnoremap <leader>so :set nospell<cr>
nnoremap <leader>sa :spellrepall<cr>

" Always use vertical diffs
set diffopt+=vertical

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
"  syntax on
"endif

" Load up all of our plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

""" SYSTEM CLIPBOARD COPY & PASTE SUPPORT
set pastetoggle=<F2> "F2 before pasting to preserve indentation

"Copy paste to/from clipboard
"vnoremap <C-c> "*y
"map <silent><Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>"
"map <silent><Leader><S-p> :set paste<CR>O<esc>"*]p:set nopaste<cr>"

""" MORE AWESOME HOTKEYS
"
"
" Run the q macro
"nnoremap <leader>q @q

" bind K to grep word under cursor
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
"command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
"nnoremap \ :Ag<SPACE>

"Map Ctrl + S to save in any mode
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
" Also map leader + s
map <leader>s <C-S>

" Quickly close windows
nnoremap <leader>x :x<cr>
nnoremap <leader>X :q!<cr>

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" resize panes
"nnoremap <silent> <Right> :vertical resize +5<cr>
"nnoremap <silent> <Left> :vertical resize -5<cr>
"nnoremap <silent> <Up> :resize +5<cr>
"nnoremap <silent> <Down> :resize -5<cr>

inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Switch between .h, .cpp
nnoremap <leader>fh :w<cr>:e %:r.h<cr>
nnoremap <leader>fc :w<cr>:e %:r.cpp<cr>

" Search Visually selected text
vnoremap // y/<c-r>"<cr>

" AUTOCOMMANDS - Do stuff

" Save whenever switching windows or leaving vim. This is useful when running
" the tests inside vim without having to save all files first.
au FocusLost,WinLeave * :silent! wa

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

"update dir to current file
autocmd BufEnter * silent! cd %:p:h

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " autocmd BufRead *.jsx set ft=jsx.html
  " autocmd BufNewFile *.jsx set ft=jsx.html

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass,less setlocal iskeyword+=-
augroup END


" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" Remove the .netrwhist file
au VimLeave * if filereadable("[path here]/.netrwhist")|call delete("[path here]/.netrwhist")|endif

" Folding Configurations
nnoremap <silent>zss :set foldmethod=syntax<cr> " Set the folding method to Syntax
nnoremap <silent>zsm :set foldmethod=manual<cr> " Set the folding method to Manual
nnoremap <silent>zsi :set foldmethod=indent<cr> " Set the folding method to Indent

" Buffer Navigation
" List buffers
nnoremap <leader>bbb :buffers 
nnoremap <silent><leader>bbn :bnext<cr> " Go to the next buffer
nnoremap <silent><leader>bbp :bprevious<cr> " Go to the previous buffer
nnoremap <silent><leader>bbd :bdelete<cr> " Delete current Buffer

" Macros
" ifdef
let @d = '0:r !pwd$a/%_bbb�klr_db�klr_�kldbd�krdbb�klr_bd0f.r_viwUi �kl#indefwyiwo#defince�kb�kb�kbne "�kb"�ku0�kraf�kdo#endif //"ba�kl �kuo�kd�kd' 
