
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
