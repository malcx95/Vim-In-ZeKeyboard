
" Check whether the plugin is already loaded
if exists("g:loaded_zekeyboard")
    finish
endif

if !has('python')
    finish
endif

let g:loaded_zekeyboard = 1

let g:keyboard_file = "hello.txt"

function! VisualEntered()
    set updatetime=0
python << endpython
import os
import vim
os.system("echo v > " + vim.eval("g:keyboard_file"))

endpython

    return ''
endfunction

function! InsertEntered(mode)
    
    silent! execute "! echo " . a:mode . " > " . g:keyboard_file

endfunction

function! Reset()
    set updatetime=4000
    silent! execute "! echo " . mode() . " > " . g:keyboard_file

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

