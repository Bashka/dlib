" Date create: 2014-10-29 10:15:54
" Last change: 2014-10-29 23:14:32
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

let s:String = dlib#core#Object#.expand()

"" {{{1
" @var string Строковое значение объекта.
"" 1}}}
let s:String.value = ''
"" {{{1
" @var integer Внутренний указатель текущего символа строки.
"" 1}}}
let s:String.point = 0

"" {{{1
" Конструктор класса.
" @param string value Значение строки.
" @return Объектное представление строки.
"" 1}}}
function! s:String.new(value) " {{{1
  let l:obj = deepcopy(self)
  let l:obj.value = a:value
  return l:obj
endfunction " 1}}}

"" {{{1
" Метод сдвигает внутренний указатель строки на следующий символ.
" @return integer|dlib#core#String# Исходный объект или 0, если достигнут конец строки.
"" 1}}}
function! s:String.next() " {{{1
  if self.point < self.chars() - 1
    let self.point += 1
    return self
  else
    return 0
  endif
endfunction " 1}}}

"" {{{1
" Метод сдвигает внутренний указатель строки на предыдущий символ.
" @return integer|dlib#core#String# Исходный объект или 0, если достигнуто начало строки.
"" 1}}}
function! s:String.prev() " {{{1
  if self.point > 0
    let self.point -= 1
    return self
  else
    return 0
  endif
endfunction " 1}}}

"" {{{1
" Метод сдвигает внутренний указатель строки в начало.
" @return dlib#core#String# Исходный объект.
"" 1}}}
function! s:String.start() " {{{1
  let self.point = 0
  return self
endfunction " 1}}}

"" {{{1
" Метод сдвигает внутренний указатель строки в конец.
" @return dlib#core#String# Исходный объект.
"" 1}}}
function! s:String.end() " {{{1
  let self.point = self.chars() - 1
  return self
endfunction " 1}}}

"" {{{1
" Получение символа строки, на который установлен внутренний указатель.
" @return string Текущий символ.
"" 1}}}
function! s:String.current() dict " {{{1
  return self.value[self.point]
endfunction " 1}}}

"" {{{1
" Метод определяет длину строки в байтах.
" @return integer Длина строки в байтах.
"" 1}}}
function! s:String.length() dict " {{{1
  return strlen(self.value)
endfunction " 1}}}

"" {{{1
" Метод определяет число символов в строке.
" @return integer Число символов в строке.
"" 1}}}
function! s:String.chars() dict " {{{1
  return strchars(self.value)
endfunction " 1}}}

"" {{{1
" Метод выполняет поиск первого вхождения подстроки в строке. 
" Если подстрока найдена, метод сдвигает внутренний указатель 
" на позицию этой подстроки.
" @param string needle Искомая подстрока.
" @param integer start [optional] Позиция начала поиска.
" @return integer Позиция искомой подстроки или -1, если подстрока не найдена.
"" 1}}}
function! s:String.find(needle, ...) dict " {{{1
  let l:index = stridx(self.value, a:needle, (exists('a:1'))? a:1 : 0)
  if l:index != -1
    let self.point = l:index
  endif
  return l:index
endfunction " 1}}}

"" {{{1
" Метод выполняет поиск справа налево первого вхождения подстроки.
" Если подстрока найдена, метод сдвигает внутренний указатель 
" на позицию этой подстроки.
" @param string needle Искомая подстрока.
" @param integer start [optional] Позиция начала поиска.
" @return integer Позиция искомой подстроки или -1, если подстрока не найдена.
"" 1}}}
function! s:String.rfind(needle, ...) dict " {{{1
  let l:index = strridx(self.value, a:needle, (exists('a:1'))? a:1 : 0)
  if l:index != -1
    let self.point = l:index
  endif
  return l:index
endfunction " 1}}}

"" {{{1
" Метод получает подстроку из заданного диапазона символов исходной строки.
" @param integer length [optional] Длина целевой подстроки. Если значение не задано или равно нулю, предполагается вся подстрока до конца.
" @param integer start [optional] Позиция начала подстроки. Если значение не задано, используется позиция внутреннего указателя.
" @return dlib#core#String# Целевая подстрока.
"" 1}}}
function! s:String.sub(...) dict " {{{1
  let l:start = (exists('a:2'))? a:2 : self.point
  let l:length = (exists('a:1') && a:1 != 0)? a:1 : self.length() - l:start
  let self.point = l:start + l:length
  return s:String.new(strpart(self.value, l:start, l:length))
endfunction " 1}}}

"" {{{1
" Метод делит строку на подстроки по заданному разделителю.
" @param string delimiter Символ-разделитель.
" @return array Массив подстрок исходной строки.
"" 1}}}
function! s:String.split(delimiter) dict " {{{1
  return split(self.value, a:delimiter)
endfunction " 1}}}

"" {{{1
" Метод объединяет строки возвращая результирующую строку.
" @param string|dlib#core#String# str Добавляемая строка.
" @return dlib#core#String# Результирующая строка.
"" 1}}}
function! s:String.concat(str) dict " {{{1
  if type(a:str) == 1
    return s:String.new(self.value . a:str)
  elseif type(a:str) == 4
    return s:String.new(self.value . a:str.value)
  endif
endfunction " 1}}}

let dlib#core#String# = s:String
