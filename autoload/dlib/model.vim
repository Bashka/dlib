" Date Create: 2014-11-06 19:32:33
" Last Change: 2014-11-10 11:30:21
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

"" {{{1
" @var string Состояния опций совместимости редактора, установленные пользователем Vim. Данная переменная используется для восстановления состояний этих опций после инициализации модуля.
"" 1}}}
let dlib#model#saveCPO = ''

"" {{{1
" Функция устанавливает значение опции модуля по умолчанию. Если опция установлена на момент вызова функции, функция завершит работу.
" @param string option Имя целевой опции.
" @param mixed defValue Значение целевой опции по умолчанию.
"" 1}}}
function! dlib#model#def(option, defValue) " {{{1
  if !exists('g:' . a:option)
    let {'g:' . a:option} = a:defValue
  endif
endfunction " 1}}}

"" {{{1
" Функция проверяет готовность окружения к инициализации модуля и выполняет частичную инициализацию. Данная функция может быть использована в файле инициализации модуля в виде следующего условия:
" if dlib#model#init('модуль')
"   finish
" endif
" В конце файла инициализации модуля необходимо использовать функцию dlib#model#end.
" Если необходимо запретить инициализацию модуля, достаточно добавить в файл конфигурации Vim команду инициализации переменной вида: имяМодуля#. Для модуля myModule эта команда будет выглядеть следующим образом:
" let myModule# = 1
" Если текущая версия редактора ниже указанной, модуль так же не будет инициализирован.
" @param string module Имя проверяемого модуля.
" @param integer depending [optional] Словарь зависимостей для данного модуля. Словарь может включать следующие элементы: 
" {version: номер версии редактора Vim, 
" depending: [имена модулей и их версии, записанные через двоеточие, необходимые данному модулю]}
" @return integer Возвращается 0 в случае, если модуль должен быть инициализирован, в противном случае возвращается 1.
"" 1}}}
function! dlib#model#init(module, ...) " {{{1
  if exists('g:' . a:module . '#')
    return 1
  endif
  if exists('a:1')
    if has_key(a:1, 'vimVersion') && v:version < a:1['vimVersion']
      echohl Error | echo 'Module ' . a:module . ': You need Vim v' . a:1['vimVersion'] . ' or higher.' | echohl None
      return 1
    endif
    if has_key(a:1, 'depending')
      for l:module in a:1['depending']
        let [l:reqModule, l:reqVersion] = split(l:module, ':')
        try 
          exe 'let l:currVersion = g:' . l:reqModule . '#version'
          if l:currVersion < l:reqVersion
            echohl Error | echo 'Module ' . a:module . ': You need module ' . l:reqModule . ' v' . l:reqVersion . ' or higher. Current version ' . l:currVersion . '.' | echohl None
            return 1
          endif
        catch 'E121'
          echohl Error | echo 'Module ' . a:module . ': You need module ' . l:reqModule . ' v' . l:reqVersion . ' or higher.' | echohl None
          return 1
        endtry
      endfor
    endif
  endif
  let {a:module . '#'} = 1
  let g:dlib#model#saveCPO = &l:cpo
  set cpo&vim
  return 0
endfunction " 1}}}

"" {{{1
" Функция используется после инициализации модуля и отвечает за восстановление состояния редактора.
"" 1}}}
function! dlib#model#end() " {{{1
  let &l:cpo = g:dlib#model#saveCPO
  let g:dlib#model#saveCPO = ''
endfunction " 1}}}
