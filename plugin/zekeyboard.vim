
" Check whether the plugin is already loaded
if exists("g:loaded_zekeyboard")
    finish
endif

let g:loaded_zekeyboard = 1
    
function! VisualEntered()
    set updatetime=0
    silent! execute "! echo v > hello.txt"

endfunction

function! InsertEntered(mode)
    
    silent! execute "! echo " . a:mode . " > hello.txt"

endfunction

function! Reset()
    set updatetime=4000
    silent! execute "! echo " . mode() . " > hello.txt"

endfunction

"vnoremap <silent> <expr> <SID>VisualEntered VisualEntered()
nnoremap <silent> <script> v v<SID>VisualEntered
nnoremap <silent> <script> V V<SID>VisualEntered
"nnoremap <silent> <script> a a<SID>ModeChanged
"nnoremap <silent> <script> A A<SID>ModeChanged
"nnoremap <silent> <script> i i<SID>ModeChanged
"nnoremap <silent> <script> I I<SID>ModeChanged
"nnoremap <silent> <script> o o<SID>ModeChanged
"nnoremap <silent> <script> O O<SID>ModeChanged
"nnoremap <silent> <script> s s<SID>ModeChanged
"nnoremap <silent> <script> S S<SID>ModeChanged
nnoremap <silent> <script> <C-v> <C-v><SID>VisualEntered


augroup GROUP
    autocmd!
    autocmd InsertEnter * call InsertEntered(v:insertmode)
    autocmd InsertLeave * call Reset()
    autocmd CursorHold * call Reset()
augroup end

