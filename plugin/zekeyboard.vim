
" Check whether the plugin is already loaded
if exists("g:loaded_zekeyboard")
    finish
endif

if !has('python')
    finish
endif

let s:saved_cpo = &cpo
set cpo&vim

let g:loaded_zekeyboard = 1

let g:keyboard_file = "/dev/ttyACM0"

function! VisualEntered()
    set updatetime=0
python << endpython

import vim
os.system("echo v > " + vim.eval("g:keyboard_file"))

endpython

    return ''
endfunction

function! InsertEntered(mode)
    
python << endpython
import vim
os.system("echo " + vim.eval("a:mode") + " > " + vim.eval("g:keyboard_file"))

endpython

endfunction

function! Reset()
    set updatetime=4000

python << endpython

import vim
os.system("echo " + vim.eval("mode()") + " > " + vim.eval("g:keyboard_file"))

endpython

endfunction

vnoremap <silent> <expr> <SID>VisualEntered VisualEntered()
nnoremap <silent> <script> v v<SID>VisualEntered<left><right>
nnoremap <silent> <script> V V<SID>VisualEntered<left><right>
nnoremap <silent> <script> <C-v> <C-v><SID>VisualEntered<left><right>

augroup GROUP
    autocmd!
    autocmd InsertEnter * call InsertEntered(v:insertmode)
    autocmd InsertLeave * call Reset()
    autocmd CursorHold * call Reset()
augroup end

let &cpo = s:saved_cpo
unlet! s:saved_cpo

