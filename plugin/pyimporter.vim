"
"
"

if exists('g:loaded_pyimporter')
  finish
endif
let g:loaded_pyimporter= 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -ranges=0 -complete=customlist,importer#import PyImport
            \ call importer#import()

function! PyImport()
    call importer#import()
endfunction

function! ReferProjects()
    echo g:py_projects
endfunction

function! ReferCurProject()
    let l:project = importer#referCurProject()
    echo l:project
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
