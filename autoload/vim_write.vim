" Date Create: 2015-02-23 22:48:37
" Last Change: 2015-02-24 16:57:11
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Publisher = vim_lib#sys#Publisher#.new()
let s:Content = vim_lib#sys#Content#.new()

"" {{{
" Метод выполняет замены ключевых слов в буфере перед сохранением.
"" }}}
function! vim_write#_writePre() " {{{
  if &l:mod == 1
    " Замены ключевых слов. {{{
    if g:vim_write#.preplace == 1
      let l:pos = s:Content.pos()
      let l:replacements = []
      if has_key(g:vim_write#replacement, 'all')
        let l:replacements += g:vim_write#replacement.all
      endif
      if has_key(g:vim_write#replacement, &l:filetype)
        let l:replacements += g:vim_write#replacement[&l:filetype]
      endif
      for l:replace in l:replacements
        exe l:replace
      endfor
      call s:Content.pos(l:pos)
    endif
    " }}}
    call s:Publisher.fire('VimWritePwrite')
  endif
endfunction " }}}

"" {{{
" Метод выполняет автоматическое сохранение буфера в случае, если он был изменен и не являлся временным.
"" }}}
function! vim_write#_autowrite() " {{{
  if g:vim_write#.aw == 1 && &l:mod == 1 && &l:buftype != 'nofile' && bufname('%') != ''
    if type(g:vim_write#.awTypes) == 1 || (type(g:vim_write#.awTypes) == 3 && index(g:vim_write#.awTypes, &l:filetype) != -1)
      call vim_write#_writePre()
      w
    endif
  endif
endfunction " }}}

"" {{{
" Метод активирует механизм автосохранение.
"" }}}
function! vim_write#awstart() " {{{
  let g:vim_write#.autowrite = 1
endfunction " }}}

"" {{{
" Метод отключает механизм автосохранения.
"" }}}
function! vim_write#awstop() " {{{
  let g:vim_write#.autowrite = 0
endfunction " }}}
