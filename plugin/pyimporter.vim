"let g:python_path = 'test'
let g:current_file_dir = ''

function! GoTargetFile(paths, froms, imp)
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
                "else
                "    echo 'No exist in from list.'
                "    return 0
                endif
                return
            endif
        endfor
        let l:py_file = l:python_path . '/' . a:imp . '.py'
        echo l:py_file
        if filereadable(l:py_file)
            exe 'e ' . findfile(l:py_file)
            return 1
        endif
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
        echo 'Error! lost import'
        return
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
    let l:python_paths = []
    if exists('g:python_paths')
        let l:python_paths += g:python_paths
    endif
    call add(l:python_paths, expand('%:h'))
    return l:python_paths
endfunction


function! TestParse()
    let line = GetImpLines()
    let res = ParseLine(line)
    let pys = CollectPyPath()
    let resul = GoTargetFile(pys, res['froms'], res['import'])
    echo resul
    "echo res
endfunction


