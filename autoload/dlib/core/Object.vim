" Date create: 2014-10-29 09:22:59
" Last change: 2014-10-29 10:03:21
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

let s:Object = {}

""
" Конструктор класса. В конкретных классах может быть переопределен с
" добавлением аргументов для инициализации объекта. В случае переопределения
" необходимо самостоятельно выполнить рекурсивное копирование объекта.
" @return Полная копия класса с сохраненными ссылками на его методы.
""
function! s:Object.new() dict " {{{1
  return deepcopy(self)
endfunction " 1}}}

""
" Метод позволяет создать класс потомок от данного класса.
" @return Полная копия класса с сохраненными ссылками на его методы.
""
function! s:Object.expand() dict " {{{1
  return deepcopy(self)
endfunction " 1}}}

let dlib#core#Object# = s:Object
