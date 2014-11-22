" Date Create: 2014-11-12 10:05:55
" Last Change: 2014-11-12 15:24:14
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:UnitTest = dlib#core#UnitTest#
let s:String = dlib#core#String#

let s:TestString = s:UnitTest.expand()

function! s:TestString.beforeTest() " {{{1
  let self.object = s:String.new('Hello world')
endfunction " 1}}}

function! s:TestString.afterTest() " {{{1
  unlet self.object
endfunction " 1}}}

"" {{{1
" Должен создавать объект на основании заданной в параметре строки.
" @covers dlib#core#String#.new
"" 1}}}
function! s:TestString.testNew_wrapString() " {{{1
  call self.assertString('Hello world', self.object.value)
endfunction " 1}}}

"" {{{1
" Должен создавать объект на текущей строки.
" @covers dlib#core#String#.new
"" 1}}}
function! s:TestString.testNew_wrapCurrentString() " {{{1
  call cursor(3, 0)
  call self.assertString('" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)', s:String.new().value)
endfunction " 1}}}

"" {{{1
" Должен сдвигать внутренний указатель строки вправо.
" @covers dlib#core#String#.next
"" 1}}}
function! s:TestString.testNext_movePointRight() " {{{1
  call self.assertInteger(0, self.object.point)
  call self.object.next()
  call self.assertInteger(1, self.object.point)
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект.
" @covers dlib#core#String#.next
"" 1}}}
function! s:TestString.testNext_returnSelf() " {{{1
  call self.assertDict(self.object, self.object.next())
endfunction " 1}}}

"" {{{1
" Должен возвращать false, если указатель находится в конце строки.
" @covers dlib#core#String#.next
"" 1}}}
function! s:TestString.testNext_returnFalseIfEnd() " {{{1
  call self.object.end()
  call self.assertDict(0, self.object.next())
endfunction " 1}}}

"" {{{1
" Должен сдвигать внутренний указатель строки влево.
" @covers dlib#core#String#.prev
"" 1}}}
function! s:TestString.testPrev_movePointLeft() " {{{1
  call self.object.end()
  call self.assertInteger(10, self.object.point)
  call self.object.prev()
  call self.assertInteger(9, self.object.point)
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект.
" @covers dlib#core#String#.prev
"" 1}}}
function! s:TestString.testPrev_returnSelf() " {{{1
  call self.object.end()
  call self.assertDict(self.object, self.object.prev())
endfunction " 1}}}

"" {{{1
" Должен возвращать false, если указатель находится в начале строки.
" @covers dlib#core#String#.prev
"" 1}}}
function! s:TestString.testPrev_returnFalseIfStart() " {{{1
  call self.assertDict(0, self.object.prev())
endfunction " 1}}}

"" {{{1
" Должен сдвигать внутренний указатель строки в ее начало.
" @covers dlib#core#String#.start
"" 1}}}
function! s:TestString.testStart_movePointStart() " {{{1
  call self.object.next()
  call self.assertInteger(1, self.object.point)
  call self.object.start()
  call self.assertInteger(0, self.object.point)
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект.
" @covers dlib#core#String#.start
"" 1}}}
function! s:TestString.testStart_returnSelf() " {{{1
  call self.assertDict(self.object, self.object.start())
endfunction " 1}}}

"" {{{1
" Должен сдвигать внутренний указатель строки в ее конец.
" @covers dlib#core#String#.end
"" 1}}}
function! s:TestString.testEnd_movePointStart() " {{{1
  call self.assertInteger(0, self.object.point)
  call self.object.end()
  call self.assertInteger(10, self.object.point)
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект.
" @covers dlib#core#String#.end
"" 1}}}
function! s:TestString.testEnd_returnSelf() " {{{1
  call self.assertDict(self.object, self.object.end())
endfunction " 1}}}

"" {{{1
" Должен возвращать текущий символ.
" @covers dlib#core#String#.current
"" 1}}}
function! s:TestString.testCurrent_getCurrentChar() " {{{1
  call self.assertString('H', self.object.current()) 
endfunction " 1}}}

"" {{{1
" Должен возвращать длину строки в байтах.
" @covers dlib#core#String#.length
"" 1}}}
function! s:TestString.testLength_returnLength() " {{{1
  call self.assertInteger(11, self.object.length())
  unlet self.object
  let self.object = s:String.new('Привет мир')
  call self.assertInteger(19, self.object.length())
endfunction " 1}}}

"" {{{1
" Должен возвращать число символов в строке.
" @covers dlib#core#String#.chars
"" 1}}}
function! s:TestString.testChars_returnChars() " {{{1
  call self.assertInteger(11, self.object.chars())
  unlet self.object
  let self.object = s:String.new('Привет мир')
  call self.assertInteger(10, self.object.chars())
endfunction " 1}}}

"" {{{1
" Должен выполнять поиск подстроки в строке и возвращать ее позицию.
" @covers dlib#core#String#.find
"" 1}}}
function! s:TestString.testFind_findSubstring() " {{{1
  call self.assertInteger(6, self.object.find('world'))
endfunction " 1}}}

"" {{{1
" Должен сдвигать внутренний указатель на позицию найденной подстроки.
" @covers dlib#core#String#.find
"" 1}}}
function! s:TestString.testFind_movePoint() " {{{1
  call self.object.find('world')
  call self.assertInteger(6, self.object.point)
endfunction " 1}}}

"" {{{1
" Должен возвращать -1, если подстрока не найдена.
" @covers dlib#core#String#.find
"" 1}}}
function! s:TestString.testFind_returnNegativeIfFail() " {{{1
  call self.assertInteger(-1, self.object.find('test'))
endfunction " 1}}}

"" {{{1
" Второй параметр должен определять позицию начала поиска.
" @covers dlib#core#String#.find
"" 1}}}
function! s:TestString.testFind_setPosition() " {{{1
  call self.assertInteger(9, self.object.find('l', 5))
endfunction " 1}}}

"" {{{1
" Должен выполнять поиск подстроки в строке и возвращать ее позицию. Поиск производится с конца строки.
" @covers dlib#core#String#.find
"" 1}}}
function! s:TestString.testRfind_rfindSubstring() " {{{1
  call self.assertInteger(6, self.object.rfind('world'))
endfunction " 1}}}

"" {{{1
" Должен сдвигать внутренний указатель на позицию найденной подстроки.
" @covers dlib#core#String#.rfind
"" 1}}}
function! s:TestString.testRfind_movePoint() " {{{1
  call self.object.rfind('world')
  call self.assertInteger(6, self.object.point)
endfunction " 1}}}

"" {{{1
" Должен возвращать -1, если подстрока не найдена.
" @covers dlib#core#String#.rfind
"" 1}}}
function! s:TestString.testRfind_returnNegativeIfFail() " {{{1
  call self.assertInteger(-1, self.object.rfind('test'))
endfunction " 1}}}

"" {{{1
" Второй параметр должен определять позицию начала поиска с начала строки.
" @covers dlib#core#String#.rfind
"" 1}}}
function! s:TestString.testRfind_setPosition() " {{{1
  call self.assertInteger(3, self.object.rfind('l', 5))
endfunction " 1}}}

"" {{{1
" Если заданы оба параметра, должен возвращать указанную подстроку.
" @covers dlib#core#String#.sub
"" 1}}}
function! s:TestString.testSub_getSubstring() " {{{1
  call self.assertString('world', self.object.sub(5, 6).value)
endfunction " 1}}}

"" {{{1
" Если второй параметр не задан, должен возвращать подстроку указанной длины от позиции внутреннего указателя.
" @covers dlib#core#String#.sub
"" 1}}}
function! s:TestString.testSub_getSubstringWithPoint() " {{{1
  call self.object.find(' ')
  call self.object.next()
  call self.assertString('world', self.object.sub(5).value)
endfunction " 1}}}

"" {{{1
" Если оба параметра не заданы, должен возвращать оставшуюся часть строки от текущего положения внутреннего указателя.
" @covers dlib#core#String#.sub
"" 1}}}
function! s:TestString.testSub_getAllSubstringWithPoint() " {{{1
  call self.object.find(' ')
  call self.object.next()
  call self.assertString('world', self.object.sub().value)
endfunction " 1}}}

"" {{{1
" Должен возвращать объект класса dlib#core#String#.
" @covers dlib#core#String#.sub
"" 1}}}
function! s:TestString.testSub_returnObj() " {{{1
  call self.assertInteger(4, type(self.object.sub()))
endfunction " 1}}}

"" {{{1
" Должен возвращать массив подстрок, полученных путем разделения строки по заданному разделителю.
" @covers dlib#core#String#.split
"" 1}}}
function! s:TestString.testSplit_returnArray() " {{{1
  call self.assertArray(['Hello', 'world'], self.object.split(' '))
endfunction " 1}}}

"" {{{1
" Если параметр не задан, должен возвращать массив символов строки.
" @covers dlib#core#String#.split
"" 1}}}
function! s:TestString.testSplit_returnArray() " {{{1
  call self.assertArray(['H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'], self.object.split())
endfunction " 1}}}

"" {{{1
" Должен объединять объект со строкой.
" @covers dlib#core#String#.concat
"" 1}}}
function! s:TestString.testConcat_concatString() " {{{1
  call self.assertString('Hello world!', self.object.concat('!').value)
endfunction " 1}}}

"" {{{1
" Должен объединять объект с объектом класса dlib#core#test#TestString#.
" @covers dlib#core#String#.concat
"" 1}}}
function! s:TestString.testConcat_concatObject() " {{{1
  call self.assertString('Hello world!', self.object.concat(s:String.new('!')).value)
endfunction " 1}}}

"" {{{1
" Должен создавать новый объект, а не изменять вызываемый.
" @covers dlib#core#String#.concat
"" 1}}}
function! s:TestString.testConcat_returnNewObject() " {{{1
  call self.assertTrue(self.object != self.object.concat('!'))
endfunction " 1}}}

"" {{{1
" Должен выполнять замену.
" @covers dlib#core#String#.replace
"" 1}}}
function! s:TestString.testReplace_replace() " {{{1
  call self.assertString('He__o wor_d', self.object.replace('l', '_').value)
endfunction " 1}}}

"" {{{1
" Должен создавать новый объект, а не изменять вызываемый.
" @covers dlib#core#String#.replace
"" 1}}}
function! s:TestString.testReplace_returnNewObject() " {{{1
  call self.assertTrue(self.object != self.object.replace('l', '_'))
endfunction " 1}}}

"" {{{1
" Должен создавать строку, в которой все буквы приведены к нижнему регистру.
" @covers dlib#core#String#.low
"" 1}}}
function! s:TestString.testLow_lowChars() " {{{1
  call self.assertString('hello world', self.object.low().value)
endfunction " 1}}}

"" {{{1
" Должен создавать новый объект.
" @covers dlib#core#String#.low
"" 1}}}
function! s:TestString.testLow_returnNewObject() " {{{1
  let l:result = self.object.low()
  call l:result.next()
  call self.assertTrue(self.object != l:result)
endfunction " 1}}}

"" {{{1
" Должен создавать строку, в которой все буквы приведены к верхнему регистру.
" @covers dlib#core#String#.up
"" 1}}}
function! s:TestString.testUp_upChars() " {{{1
  call self.assertString('HELLO WORLD', self.object.up().value)
endfunction " 1}}}

"" {{{1
" Должен создавать новый объект.
" @covers dlib#core#String#.up
"" 1}}}
function! s:TestString.testUp_returnNewObject() " {{{1
  let l:result = self.object.up()
  call l:result.next()
  call self.assertTrue(self.object != l:result)
endfunction " 1}}}

let dlib#core#test#TestString# = s:TestString

call s:TestString.run()
