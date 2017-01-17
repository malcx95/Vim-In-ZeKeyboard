
" Check whether the plugin is already loaded
if exists("g:loaded_zekeyboard")
    finish
endif

let g:loaded_zekeyboard = 1


let c = 0


let c += 1
sleep 1000m

silent! execute '! echo hello' . c . " > hello.txt"
    

