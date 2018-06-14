" ----------------------------------------------------------------------
" Python import plugin
" Version: 0.0.0
" Author: Shohei Mukai
" Licence: MTI Licence
" ----------------------------------------------------------------------

let s:save_cpo = &cpoptions
set cpoptions&vim

function! GoTargetFile(paths, froms, imp)
    "paths ... python path
    "froms ... from statement
    "imp ... import statement

    "Explorer python path directories.
    for l:p in a:paths
        let l:python_path = l:p
        for l:e in a:froms
            let l:org_path = l:python_path
            let l:python_path = l:python_path . '/' . l:e
            if !isdirectory(l:python_path)
                let l:py_file = l:python_path . '.py'
                if filereadable(l:py_file)
                    exe 'e ' . findfile(l:py_file)
                    return 1
                endif
            endif
        endfor
        let l:py_file = l:python_path . '/' . a:imp . '.py'
        if filereadable(l:py_file)
            exe 'e ' . findfile(l:py_file)
            return 1
        endif
    endfor
    echo 'No exist in import string'
    return 0
endfunction

function! ParseLine(imp_string)
    let l:imp_list = split(a:imp_string, ' ')
    let l:dict = {}
    let l:num = 0
    for l:e in l:imp_list
        if l:e == 'from'
            let l:dict['from'] = l:imp_list[l:num +1]
        endif
        if l:e == 'import'
            let l:dict['import'] = l:imp_list[l:num +1]
        endif
        let l:num += 1
    endfor
    if has_key(l:dict, 'from')
        let l:froms = split(l:dict['from'], '\.')
    else
        let l:froms = []
    endif
    if !has_key(l:dict, 'import')
        "echo 'Error! lost import'
        return -1
    endif
    let l:imports = {'froms': l:froms, 'import': l:dict['import']}
    return l:imports
endfunction

function! GetImpLines()
    let l:line_num = line('.')
    let l:cur_string = getline(l:line_num)
    let l:cur_string = substitute(l:cur_string, '\t', ' ', 'g')
    let l:line_len = strlen(l:cur_string)
    let l:last_string = l:cur_string[l:line_len-1]
    let l:forms = []
    if l:last_string == '\'
        let l:next_string = getline(l:line_num +1)
        let l:next_string = substitute(l:next_string, '\t', ' ', 'g')
        let l:imp_string = l:cur_string[:l:line_len-2] . l:next_string
    else
        let l:imp_string = l:cur_string
    endif
    return l:imp_string
endfunction

function! CollectPyPath()
    " Create PYTHONPATH from the below
    let l:python_path = system("python -c 'import sys;print(\"\t\".join(sys.path))'")
    let l:python_paths = split(l:python_path, '\t')
    
    " Add current file directory.
    call add(l:python_paths, expand('%:p:h'))
    " Add base directory.
    call add(l:python_paths, getcwd())

    let l:user_python_path = split($PYTHONPATH, ':')
    if l:user_python_path != []
        let l:python_paths += l:user_python_path
    endif

    "Debug
    "echo l:python_paths

    return l:python_paths
endfunction

function! importer#import()
    " Load target import statement
    let l:line = GetImpLines()
    let l:res = ParseLine(line)
    try
        if l:res == -1
            echo "You don't select import line"
            return
        endif
    catch
    endtry

    " Load python path
    let pys = CollectPyPath()

    " Move to target file
    let resul = GoTargetFile(pys, res['froms'], res['import'])
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
