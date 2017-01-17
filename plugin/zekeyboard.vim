
" Check whether the plugin is already loaded
if exists("g:loaded_zekeyboard")
    finish
endif

if !has('python')
    finish
endif

let g:loaded_zekeyboard = 1
    
function! VisualEntered()
    set updatetime=0
python << endpython
import os
os.system("echo v > hello.txt")

endpython

endfunction

function! InsertEntered(mode)
    
    silent! execute "! echo " . a:mode . " > hello.txt"

endfunction

function! Reset()
    set updatetime=4000
    silent! execute "! echo " . mode() . " > hello.txt"

endfunction

vnoremap <silent> <expr> <SID>VisualEntered VisualEntered()
nnoremap <silent> <script> v v<SID>VisualEntered
nnoremap <silent> <script> V V<SID>VisualEntered
nnoremap <silent> <script> <C-v> <C-v><SID>VisualEntered


augroup GROUP
    autocmd!
    autocmd InsertEnter * call InsertEntered(v:insertmode)
    autocmd InsertLeave * call Reset()
    autocmd CursorHold * call Reset()
augroup end

