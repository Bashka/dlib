" Date Create: 2014-10-29 14:09:24
" Last Change: 2014-11-10 11:27:19
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

"" {{{1
" Класс представляет последовательность типа "Очередь".
"" 1}}}
let s:Turn = dlib#core#Object#.expand()

"" {{{1
" @var array Содержимое очереди.
"" 1}}}
let s:Turn.values = []

"" {{{1
" Метод вставляет значение в очередь.
" @param mixed val Вставляемое значение.
" @return dlib#core#Stack# Исходный объект.
"" 1}}}
function! s:Turn.push(val) dict " {{{1
  call add(self.values, a:val)
  return self
endfunction " 1}}}

"" {{{1
" Метод выталкивает элемент из очереди.
" @param mixed return [optional] Значение, которое должно быть возвращено в случае, если очередь пуста. Если данное значение не задано, возвращается исходный объект.
" @return mixed Целевой элемент.
"" 1}}}
function! s:Turn.shift(...) dict " {{{1
  if self.length() != 0
    return remove(self.values, 0)
  else
    return ((exists('a:1'))? a:1 : self)
  endif
endfunction " 1}}}

"" {{{1
" Метод возвращает элемент из начала очереди не выталкивая его.
" @param mixed return [optional] Значение, которое должно быть возвращено в случае, если очередь пуста. Если данное значение не задано, возвращается исходный объект.
" @return mixed Целевой элемент.
"" 1}}}
function! s:Turn.current(...) " {{{1
  if self.length() != 0
    return get(self.values, 0)
  else
    return ((exists('a:1'))? a:1 : self)
  endif
endfunction " 1}}}

"" {{{1
" Метод определяет количество элемент, содержащихся в очереди.
" @return integer Число элемент, содержащихся в очереди.
"" 1}}}
function! s:Turn.length() dict " {{{1
  return len(self.values)
endfunction " 1}}}

let dlib#core#Turn# = s:Turn
