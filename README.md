# Simple Python jumper(Vim plugin)

This is vim plugin which you can jump `import` module file.  

![demo](demo/demo.gif)

## Install

You can run this script to writing `pyohei/vim-python-jumping` on your plugin manager tool.  

## Usage

Excecute `;PyImport` on your import statement and jum to module script.  
If you want to add this comannd as keymap, add the below command in your `.vimrc`.  

```vim
nnoremap <C-L> :PyImport()<CR>
```

## Logic

This script based `PYTHONPATH`.   
If you can not jump specific module, please review your `PYTHONPATH`.  
But there are some cases that do not read correctly.
(I found the case written in `__init__.py`)    

## Licence

* [MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)
