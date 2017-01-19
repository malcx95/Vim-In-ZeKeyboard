
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

let g:keyboard_found = 1
let g:plugin_enabled = 1
let g:messaged = 1

function! Enable()
    let g:plugin_enabled = 1
    let g:messaged = 0
endfunction

function! SwitchPort()
    if g:keyboard_file == "/dev/ttyACM0"
        let g:keyboard_file = "/dev/ttyACM1"
    else
        let g:keyboard_file = "/dev/tty/ACM0"
    endif
endfunction

function! SendToKeyboard(text)
python << endpython

import vim
import os
keyboard = vim.eval("g:keyboard_file")
text = vim.eval("a:text")

try:
    if int(vim.eval("g:keyboard_found")) and int(vim.eval("g:plugin_enabled")):
        with open(keyboard, 'w') as k:
            k.write(text)
except IOError, OSError:
    vim.command("let g:keyboard_found = 0")
    vim.command("let g:messaged = 0")

endpython

endfunction

function! VisualEntered()
    set updatetime=0

    call SendToKeyboard("v")

    return ''
endfunction

function! InsertEntered(mode)
    
    call SendToKeyboard(a:mode)

endfunction

function! Reset()
    set updatetime=4000

    call SendToKeyboard(mode())

    if !g:keyboard_found && g:plugin_enabled && !g:messaged
        echom 'ZeKeyboard not found. Use ChangeKeyboardPort to change port or EnableZeKeyboard to restart'
        let g:messaged = 1
    endif

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

command! EnableZeKeyboard call Enable()
command! DisableZeKeyboard let g:plugin_enabled = 0
command! ChangeKeyboardPort call SwitchPort()

let &cpo = s:saved_cpo
unlet! s:saved_cpo

