" Date Create: 2014-11-06 19:32:33
" Last Change: 2014-12-15 21:27:53
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

"" {{{1
" @var string Состояния опций совместимости редактора, установленные пользователем Vim. Данная переменная используется для восстановления состояний этих опций после инициализации модуля.
"" 1}}}
let dlib#model#saveCPO = ''
let dlib#model#currentModule = ''

"" {{{1
" Функция проверяет готовность окружения к инициализации модуля и выполняет частичную инициализацию. Данная функция может быть использована в файле инициализации модуля в виде следующего условия:
" if dlib#model#init('модуль')
"   finish
" endif
" В конце файла инициализации модуля необходимо использовать функцию dlib#model#end.
" Если необходимо запретить инициализацию модуля, достаточно добавить в файл конфигурации Vim команду инициализации переменной вида: имяМодуля#. Для модуля myModule эта команда будет выглядеть следующим образом:
" let имяМодуля# = 1
" @param string module Имя модуля.
" @return bool true - в случае успешной инициализации модуля и false - в случае, если модуль уже инициализирован.
"" 1}}}
function! dlib#model#init(module) " {{{1
  if exists('g:' . a:module . '#')
    return 0
  endif
  let g:dlib#model#currentModule = a:module
  let {a:module . '#'} = 1
  let g:dlib#model#saveCPO = &l:cpo
  set cpo&vim
  return 1
endfunction " 1}}}

"" {{{1
" Функция используется после инициализации модуля и отвечает за восстановление состояния редактора.
"" 1}}}
function! dlib#model#end() " {{{1
  let &l:cpo = g:dlib#model#saveCPO
  let g:dlib#model#saveCPO = ''
  let g:dlib#model#currentModule = ''
endfunction " 1}}}

"" {{{1
" Метод оценивает зависимости для текущего модуля.
" @param hash depending Список зависимостей, имеющий следующую структуру [имяМодуля: версия, ...].
" @return bool true - в случае, если все зависимости удовлетворены, иначе - false.
"" 1}}}
function! dlib#model#dep(depending) " {{{1
  for [l:reqModule, l:reqModuleVersion] in items(a:depending)
    try
      exe 'let l:currModuleVersion = g:' . l:reqModule . '#version'
    catch 'E121' " Обработка ситуации отсутствия требуемого модуля.
      echohl Error | echo 'Module ' . g:dlib#model#currentModule . ': You need module "' . l:reqModule . '" v' . l:reqModuleVersion . ' or higher.' | echohl None
      return 0
    endtry
    if l:currModuleVersion < l:reqModuleVersion
      echohl Error | echo 'Module ' . g:dlib#model#currentModule . ': You need module "' . l:reqModule . '" v' . l:reqModuleVersion . ' or higher. Current version ' . l:currModuleVersion . '.' | echohl None
      return 0
    endif
  endfor
  return 1
endfunction " 1}}}

"" {{{1
" Метод проверяет наличие требуемой версии редактора Vim.
" @param integer reqVersion Требуемая версия редаткора.
" @return bool true - в случае, если редактор требуемой версии, иначе - false.
"" 1}}}
function! dlib#model#vv(reqVersion) " {{{1
  if v:version < a:reqVersion
    echohl Error | echo 'Module ' . g:dlib#model#currentModule . ': You need Vim v' . a:reqVersion . ' or higher.' | echohl None
    return 0
  else
    return 1
  endif
endfunction " 1}}}

"" {{{1
" Метод проверяет наличие обязательного модуля окружения.
" @param array depending Список необходимых модулей окружения.
" @return bool true - в случае, если все обязательные модули окружения присутствуют, иначе - false.
"" 1}}}
function! dlib#model#has(depending) " {{{1
  for l:reqModule in a:depending
    if !has(l:reqModule)
      echohl Error | echo 'Module ' . g:dlib#model#currentModule . ': You need "' . a:reqModule . '".' | echohl None
      return 0
    endif
  endfor
  return 1
endfunction " 1}}}

"" {{{1
" Функция устанавливает значение опции модуля по умолчанию. Если опция установлена на момент вызова функции, функция завершит работу.
" @param string option Имя целевой опции. В качестве пространства имен опции будет использован сам модуль, так, опция "op" будет записана в переменную "модуль#op".
" @param mixed defValue Значение целевой опции по умолчанию.
"" 1}}}
function! dlib#model#def(option, defValue) " {{{1
  let l:option = g:dlib#model#currentModule . '#' . a:option
  if !exists('g:' . l:option)
    let {'g:' . l:option} = a:defValue
  endif
endfunction " 1}}}
