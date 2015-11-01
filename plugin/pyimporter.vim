" ----------------------------------------------------------------------
" Python path import plugin
" Version: 0.0.0
" Author: pyohei
" Licence: MTI Licence
" ----------------------------------------------------------------------

if exists('g:loaded_pyimporter')
  finish
endif
let g:loaded_pyimporter= 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -range=0 -complete=customlist,importer#import PyImport
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

function! AddPyImportBase()
    echo "Add PyImportBase"
endfunction

function! TestPyImportEcho()
    echo "test"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
