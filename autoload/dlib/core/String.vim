" Date Create: 2014-10-29 10:15:54
" Last Change: 2014-11-12 15:18:33
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

"" {{{1
" Класс представляет обертку строкового типа данных. Все методы, определенные в данном классе, не влияют на исходную строку, а создают новую, результирующую строку.
"" 1}}}
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
" @param string value [optional] Значение строки. Если параметр не задан, используется текущая строка редактора, при этом внутренний указатель будет установлен в текущую позицию курсора.
" @return Объектное представление строки.
"" 1}}}
function! s:String.new(...) " {{{1
  let l:obj = deepcopy(self)
  if exists('a:1')
    let l:obj.value = a:1
  else
    let l:obj.value = getline('.')
    let l:obj.point = col('.') - 1
  endif
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
  if exists('a:1')
    let l:index = strridx(self.value, a:needle, a:1)
  else
    let l:index = strridx(self.value, a:needle)
  endif
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
" @param string delimiter [optional] Символ-разделитель. Если параметр не задан, строка делится посимвольно.
" @return array Массив подстрок исходной строки.
"" 1}}}
function! s:String.split(...) dict " {{{1
  if !exists('a:1')
    let l:delimiter = '\zs'
  else
    let l:delimiter = a:1
  endif
  return split(self.value, l:delimiter)
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

"" {{{1
" Метод выполняет поиск с заменой в исходной строке и возвращает результирующую строку.
" @param string search Шаблон поиска.
" @param string replace Параметры замены.
" @return dlib#core#String# Результирующая строка.
"" 1}}}
function! s:String.replace(search, replace) dict " {{{1
  return s:String.new(substitute(self.value, a:search, a:replace, 'g'))
endfunction " 1}}}

"" {{{1
" Метод преобразует исходную строку в аналогичную, но для которой все буквы приведены в нижний регистр.
" @return dlib#core#String# Результирующая строка, в которой все буквы приведены в нижний регистр.
"" 1}}}
function! s:String.low() dict " {{{1
  return s:String.new(tolower(self.value))
endfunction " 1}}}

"" {{{1
" Метод преобразует исходную строку в аналогичную, но для которой все буквы приведены в верхний регистр.
" @return dlib#core#String# Результирующая строка, в которой все буквы приведены в верхний регистр.
"" 1}}}
function! s:String.up() dict " {{{1
  return s:String.new(toupper(self.value))
endfunction " 1}}}

let dlib#core#String# = s:String
