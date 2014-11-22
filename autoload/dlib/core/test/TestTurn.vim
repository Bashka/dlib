" Date Create: 2014-11-04 12:44:50
" Last Change: 2014-11-12 10:02:13
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:UnitTest = dlib#core#UnitTest#
let s:Turn = dlib#core#Turn#

let s:TestTurn = s:UnitTest.expand()

function! s:TestTurn.beforeTest() " {{{1
  let self.object = s:Turn.new()
endfunction " 1}}}

function! s:TestTurn.afterTest() " {{{1
  unlet self.object
endfunction " 1}}}

"" {{{1
" Должен вставлять значение в вершину очереди.
" @covers dlib#core#Turn#.push
"" 1}}}
function! s:TestTurn.testPush_addValue() " {{{1
  call self.object.push(1)
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.shift())
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект.
" @covers dlib#core#Turn#.push
"" 1}}}
function! s:TestTurn.testPush_returnSelf() " {{{1
  call self.assertDict(self.object, self.object.push(1))
endfunction " 1}}}

"" {{{1
" Должен возвращать значение с основания очереди исключая его из очереди.
" @covers dlib#core#Turn#.shift
"" 1}}}
function! s:TestTurn.testShift_getValue() " {{{1
  call self.object.push(1)
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(1, self.object.shift())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(2, self.object.shift())
  call self.assertDict(self.object, self.object.shift())
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект или заданное параметром значение, если очередь пуста.
" @covers dlib#core#Turn#.shift
"" 1}}}
function! s:TestTurn.testShift_returnSelfOrArg() " {{{1
  call self.assertDict(self.object, self.object.shift())
  call self.assertInteger(0, self.object.shift(0))
endfunction " 1}}}

"" {{{1
" Должен возвращать значение с основания очереди не исключая его из очереди.
" @covers dlib#core#Turn#.current
"" 1}}}
function! s:TestTurn.testCurrent_getCurrent() " {{{1
  call self.object.push(1)
  call self.object.push(2)
  call self.assertInteger(1, self.object.current())
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(1, self.object.current())
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект или заданное параметром значение, если очередь пуста.
" @covers dlib#core#Turn#.current
"" 1}}}
function! s:TestTurn.testCurrent_returnSelfOrArg() " {{{1
  call self.assertDict(self.object, self.object.current())
  call self.assertInteger(0, self.object.current(0))
endfunction " 1}}}

"" {{{1
" Должен возвращать длину очереди.
" @covers dlib#core#Turn#.length
"" 1}}}
function! s:TestTurn.testLength_returnLength() " {{{1
  call self.assertInteger(0, self.object.length())
  call self.object.push(1)
  call self.assertInteger(1, self.object.length())
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
endfunction " 1}}}

let dlib#core#test#TestTurn# = s:TestTurn

call s:TestTurn.run()
