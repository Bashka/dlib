" Date Create: 2014-10-29 09:22:59
" Last Change: 2014-11-16 14:29:32
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

"" {{{1
" Данный класс является родителем всех классов библиотеки и определяет их базовую структуру и логику. 
"" 1}}}
let s:Object = {}

"" {{{1
" Конструктор класса. В конкретных классах может быть переопределен с добавлением аргументов для инициализации объекта. В случае переопределения необходимо самостоятельно выполнить рекурсивное копирование объекта.
" @return dlib#core#Object# Полная копия класса с сохраненными ссылками на его методы.
"" 1}}}
function! s:Object.new() " {{{1
  return deepcopy(self)
endfunction " 1}}}

"" {{{1
" Метод позволяет создать класс-потомок данного класса.
" @return dlib#core#Object# Полная копия класса с сохраненными ссылками на его методы.
"" 1}}}
function! s:Object.expand() " {{{1
  return deepcopy(self)
endfunction " 1}}}

"" {{{1
" Метод устанавливает значение свойству объекта.
" @param string|hash property Имя целевого свойства или словарь, элементы которого присваиваются соответствующим свойствам объекта.
" @param mixed value [optional] Значение, устанавливаемое целевому свойству, если в качестве первого параметра передана строка.
" @return dlib#core#Object# Исходный объект.
"" 1}}}
function! s:Object.set(property, ...) " {{{1
  if exists('a:1')
    let self[a:property] = a:1
  elseif type(a:property) == 4
    for [l:property, l:value] in items(a:property)
      let self[l:property] = l:value
    endfor
  endif
  return self
endfunction " 1}}}

let dlib#core#Object# = s:Object
