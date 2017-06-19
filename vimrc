set fo=tcq

highlight comment ctermfg=cyan

highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\	/
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" Show me a ruler
set ruler

" Highlight search results
set hlsearch

" ****************************************************************************
" Misc Stuff
" ****************************************************************************
filetype plugin indent on

au BufRead,BufNewFile *.pp set filetype=puppet


""""Vundle (win32: https://github.com/gmarik/Vundle.vim/wiki/Vundle-for-Windows)
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
let path='~/.vim/bundle'
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
Plugin 'mkitt/tabline.vim'
Plugin 'oplatek/Conque-Shell'
Plugin 'EasyMotion'
Plugin 'zoomwin'
Plugin 'Tagbar'
Plugin 'bufkill.vim'

Plugin 'derekwyatt/vim-scala'
Plugin 'davidhalter/jedi-vim'
Plugin 'Python-mode-klen'
call vundle#end()

""""File types (win32: https://code.google.com/p/xmllint/)
filetype plugin indent on
au FileType xml exe ":silent %!xmllint --format -"

"""""Appearance
set laststatus=2
set relativenumber
syntax enable
set ts=2
set sw=2
set softtabstop=2
set expandtab

"set background=dark
"colorscheme solarized

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
map <leader>t :TagbarToggle<CR>
map <leader>r :!python %<CR>

map <a-m> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>

command! -nargs=* Cgrep execute "grep -R --include=*.[ch] <args>"

"
"""NERDTree
hi Directory ctermfg=white

""""Syntastics
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

""""Airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_section_y = ''
let g:airline_inactive_collapse=1
let g:airline_skip_empty_sections = 1
let g:airline_section_error = ''
let g:airline_section_warning = ''

""""Unite
let g:unite_enable_start_insert = 1


""""Python mode
let g:pymode = 1
let g:pymode_run_bind = '<leader>R'
let g:pymode_rope_completion = 0
let g:pymode_lint = 0

""""Jedi
let g:jedi#goto_command = '<leader>jd'
let g:jedi#goto_assignments_command = '<leader>jg'
let g:jedi#rename_command = '<leader>jr'
let g:jedi#usages_command = '<leader>jn'

"""ARK specific
let g:pymode_paths = ['C:/Users/ejnoele/git/eea_ark/apps/sli/src/python', 'C:/Users/ejnoele/work/ark_lib']

"""Cscope
set csqf=s-,c-,d-,i-,t-,e-,g-
map <leader><leader>cc :cs find c <cword>
map <leader><leader>cs :cs find s <cword>
map <leader><leader>cd :cs find d <cword>
map <leader><leader>ci :cs find i <cword>
map <leader><leader>ct :cs find t <cword>
map <leader><leader>cg :cs find g <cword>

