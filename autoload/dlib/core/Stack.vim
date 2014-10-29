" Date create: 2014-10-29 13:49:43
" Last change: 2014-10-29 22:00:12
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

let s:Stack = dlib#core#Object#.expand()

"" {{{1
" @var array Содержимое стека.
"" 1}}}
let s:Stack.values = []
"" {{{1
" @var integer Внутренний указатель текущего элемента стека.
"" 1}}}
let s:Stack.point = -1

"" {{{1
" Метод вставляет значение в стек.
" @param mixed val Вставляемое значение.
" @return dlib#core#Stack# Исходный объект.
"" 1}}}
function! s:Stack.push(val) dict " {{{1
  call add(self.values, a:val)
  let self.point += 1
  return self
endfunction " 1}}}

"" {{{1
" Метод выталкивает элемент из стека.
" @param mixed return [optional] Значение, которое должно быть возвращено в случае, если стек пуст. Если данное значение не задано, возвращается исходный объект.
" @return mixed Целевой элемент.
"" 1}}}
function! s:Stack.pop(...) dict " {{{1
  if self.point != -1
    let self.point -= 1
    return remove(self.values, self.point + 1)
  else
    return ((exists('a:1'))? a:1 : self)
  endif
endfunction " 1}}}

"" {{{1
" Метод возвращает элемент из вершины стека не выталкивая его.
" @param mixed return [optional] Значение, которое должно быть возвращено в случае, если стек пуст. Если данное значение не задано, возвращается исходный объект.
" @return mixed Целевой элемент.
"" 1}}}
function! s:Stack.current(...) dict " {{{1
  if self.point != -1
    return get(self.values, self.point)
  else
    return ((exists('a:1'))? a:1 : self)
  endif
endfunction " 1}}}

"" {{{1
" Метод определяет количество элемент, содержащихся в стеке.
" @return integer Число элемент, содержащихся в стеке.
"" 1}}}
function! s:Stack.length() dict " {{{1
  return self.point + 1
endfunction " 1}}}

let dlib#core#Stack# = s:Stack
