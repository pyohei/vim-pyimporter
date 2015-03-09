"let g:python_path = 'test'
let g:current_file_dir = ''

function! GetPyFile()
    let l:sh_pythonpath = $PYTHONPATH
    let l:sh_pythonpaths = split(l:sh_pythonpath, ':')

    " 解析部分
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
    let l:imp_list = split(l:imp_string, ' ')
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
    endif
    if !has_key(l:dict, 'import')
        echo 'no file'
        return
    endif

    " ファイ取得部分
    let l:python_path = expand('%:h')
    if len(l:forms) > 0
        for l:e in l:froms
            let l:org_path = l:python_path
            let l:python_path = l:python_path . '/' . l:e
            if !isdirectory(l:python_path)
                let l:py_file = l:python_path . '.py'
                if filereadable(l:py_file)
                    exe 'e ' . findfile(l:py_file)
                    return
                endif
            endif
        endfor
    endif
    let l:py_file = l:python_path . '/' . l:dict['import'] . '.py'
    if filereadable(l:py_file)
        exe 'e ' . findfile(l:py_file)
        return
    endif

    " 基本的にはファイル解析同じ処理をしている。
    let l:python_path = g:python_path
    for l:e in l:forms
        let l:org_path = l:python_path
        let l:python_path = l:python_path . '/' . l:e
        if !isdirectory(l:python_path)
            let l:py_file = l:python_path . '.py'
            if filereadable(l:py_file)
                exe 'e ' . findfile(l:py_file)
            else
                echo 'no file'
            endif
            return
        endif
    endfor
    let l:py_file = l:python_path . '/' . l:dict['import'] . '.py'
    echo l:py_file
    if filereadable(l:py_file)
        exe 'e ' . findfile(l:py_file)
    else
        echo 'no file'
    endif
endfunction

function! TestPy()
    let test = GetTargetFile(
        \"",
        \[""], "")
    echo test
endfunction

function! GoTargetFile(path, froms, imp)
    let l:python_path = a:path
    for l:e in a:froms
        let l:org_path = l:python_path
        let l:python_path = l:python_path . '/' . l:e
        if !isdirectory(l:python_path)
            let l:py_file = l:python_path . '.py'
            if filereadable(l:py_file)
                exe 'e ' . findfile(l:py_file)
                return 1
            else
                echo 'no file'
                return 0
            endif
            return
        endif
    endfor
    let l:py_file = l:python_path . '/' . a:imp . '.py'
    echo l:py_file
    if filereadable(l:py_file)
        exe 'e ' . findfile(l:py_file)
    else
        echo 'no file'
    endif
endfunction

function! ParseCurrentLine()
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
    let l:imp_list = split(l:imp_string, ' ')
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
    endif
    if !has_key(l:dict, 'import')
        echo 'Error! lost import'
        return
    endif
    return l:dict
endfunction

function! TestParse()
    let res = ParseCurrentLine()
    echo res
endfunction
