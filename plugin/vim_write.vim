" Date Create: 2015-02-23 22:45:56
" Last Change: 2015-03-18 20:50:51
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Plugin = vim_lib#sys#Plugin#
let s:System = vim_lib#sys#System#.new()

let s:p = s:Plugin.new('vim_write', '1')

" Опции. {{{
"" {{{
" @var bool Следует ли выполнять замену ключевых значений в файле перед сохранением.
"" }}}
let s:p.preplace = 1
"" {{{
" @var bool Включен ли механизм автосохранения изменений.
"" }}}
let s:p.aw = 0
"" {{{
" @var string|array Массив, содержащий имена типов файлов, для которых задействован механизм автосохранения изменений. Если опция установлена в значение 'all', механизм задействован для всех типов файлов.
"" }}}
let s:p.awTypes = 'all'
if !exists('g:vim_write#replacement')
  "" {{{
  " @var hash Словарь замен, используемый перед записью буфера для замены ключевых слов. Словарь имеет следующую структуру: {типФайла: [regexp, ...]}. Тип 'all' используется для всех файлов.
  "" }}}
  let g:vim_write#replacement = {}
endif
" }}}
function! s:p.run() " {{{
  call s:System.au('BufWritePre,FileWritePre', function('vim_write#_writePre'))
  call s:System.au('CursorHold', function('vim_write#_autowrite'))
endfunction " }}}
" Меню. {{{
call s:p.menu('Aw_start', 'awstart', '1')
call s:p.menu('Aw_stop', 'awstop', '2')
" }}}
" Команды. {{{
call s:p.comm('VimWriteAwStart', 'awstart()')
call s:p.comm('VimWriteAwStop', 'awstop()')
" }}}

call s:p.reg()
