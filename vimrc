""""Vundle (win32: https://github.com/gmarik/Vundle.vim/wiki/Vundle-for-Windows)
set nocompatible
filetype off

set rtp+=~/vimfiles/bundle/Vundle.vim
let path='~/vimfiles/bundle'
call vundle#begin(path)
Plugin 'Vundle.vim'
Plugin 'The-NERD-tree'
Plugin 'The-NERD-Commenter'
Plugin 'Solarized'
Plugin 'fugitive.vim'
Plugin 'unimpaired.vim'
Plugin 'ctrlp.vim'
Plugin 'Syntastic'
Plugin 'bling/vim-airline'
Plugin 'bling/vim-bufferline'
Plugin 'mkitt/tabline'
Plugin 'oplatek/Conque-Shell'
Plugin 'EasyMotion'
Plugin 'zoomwin'
Plugin 'Tagbar'
Plugin 'bufkill.vim'

Plugin 'derekwyatt/vim-scala'
Plugin 'davidhalter/jedi-vim'
Plugin 'Python-mode-klen'
Plugin 'vim-json-bundle'
call vundle#end()

""""File types (win32: https://code.google.com/p/xmllint/)
filetype plugin indent on
au FileType xml exe ":silent %!xmllint --format -"
au FileType json exe ":silent %!python -m json.tool"
au FileType dosbatch exe ":nmap <leader>r :!\"%\"<CR>"

"""""Appearance
set laststatus=2
set relativenumber
syntax enable
set ts=4
set sw=4
set expandtab
set cursorline

set background=light
if has('gui')
    colorscheme solarized
endif

set guifont=Consolas:h11
set guioptions-=T
set guioptions-=r
set guioptions-=L
set guioptions-=e
set guioptions-=m

""""Others
set backspace=indent,eol,start
set ignorecase
set smartcase
let mapleader = ","
set completeopt=longest,menuone
set incsearch
set showcmd
set wildmode="list:longest"
set wildmenu

"set shell=powershell
"set shellcmdflag=-command

"""""Key maps
map <c-j> <c-w>j<c-w>_
map <c-k> <c-w>k<c-w>_
map <c-l> <c-w>l
map <c-h> <c-w>h

map <leader>N :NERDTreeToggle<CR>
if has('win32')
    map <leader>s :ConqueTerm cmd.exe<CR>
elseif has('unix')
    map <leader>s :ConqueTerm bash<CR>
endif
map <leader>T :tabnew<CR>
map <leader>C :tabclose<CR>
map <leader>D :BD<CR>
map <leader>W :BW<CR>
map <leader>t :TagbarToggle<CR>
map <leader>p :tabp<CR>
map <leader>a :ARKWin<CR>

map <a-m> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>

"
""""Syntastics
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

""""Airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#bufferline#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1

""""Bufferline
let g:bufferline_echo = 0

""""Unite
let g:unite_enable_start_insert = 1


""""Python mode
let g:pymode = 1
let g:pymode_run_bind = '<leader>R'
let g:pymode_rope_completion = 0
let g:pymode_lint = 1

""""Jedi
let g:jedi#goto_command = '<leader>jd'
let g:jedi#goto_assignments_command = '<leader>jg'
let g:jedi#rename_command = '<leader>jr'
let g:jedi#usages_command = '<leader>jn'

"""ARK specific
let g:pymode_paths = ['C:/Users/ejnoele/git/eea_ark/apps/sli/src/python', 'C:/Users/ejnoele/work/ark_lib']
