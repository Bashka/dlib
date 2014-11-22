" Date Create: 2014-11-04 12:01:21
" Last Change: 2014-11-12 09:57:51
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:UnitTest = dlib#core#UnitTest#
let s:Stack = dlib#core#Stack#

let s:TestStack = s:UnitTest.expand()

function! s:TestStack.beforeTest() " {{{1
  let self.object = s:Stack.new()
endfunction " 1}}}

function! s:TestStack.afterTest() " {{{1
  unlet self.object
endfunction " 1}}}

"" {{{1
" Должен вставлять значение в вершину стека.
" @covers dlib#core#Stack#.push
"" 1}}}
function! s:TestStack.testPush_addValue() " {{{1
  call self.object.push(1)
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(2, self.object.current())
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект.
" @covers dlib#core#Stack#.push
"" 1}}}
function! s:TestStack.testPush_returnSelf() " {{{1
  call self.assertDict(self.object, self.object.push(1))
endfunction " 1}}}

"" {{{1
" Должен возвращать значение с вершины стека исключая его из стека.
" @covers dlib#core#Stack#.pop
"" 1}}}
function! s:TestStack.testPop_getValue() " {{{1
  call self.object.push(1)
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(2, self.object.pop())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.pop())
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект или заданное параметром значение, если стек пуст.
" @covers dlib#core#Stack#.pop
"" 1}}}
function! s:TestStack.testPop_returnSelfOrArg() " {{{1
  call self.assertDict(self.object, self.object.pop())
  call self.assertInteger(0, self.object.pop(0))
endfunction " 1}}}

"" {{{1
" Должен возвращать значение с вершины стека не исключая его из стека.
" @covers dlib#core#Stack#.current
"" 1}}}
function! s:TestStack.testCurrent_getCurrent() " {{{1
  call self.object.push(1)
  call self.assertInteger(1, self.object.current())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.current())
endfunction " 1}}}

"" {{{1
" Должен возвращать исходный объект или заданное параметром значение, если стек пуст.
" @covers dlib#core#Stack#.current
"" 1}}}
function! s:TestStack.testCurrent_returnSelfOrArg() " {{{1
  call self.assertDict(self.object, self.object.current())
  call self.assertInteger(0, self.object.current(0))
endfunction " 1}}}

"" {{{1
" Должен возвращать длину стека.
" @covers dlib#core#Stack#.length
"" 1}}}
function! s:TestStack.testLength_returnLength() " {{{1
  call self.assertInteger(0, self.object.length())
  call self.object.push(1)
  call self.assertInteger(1, self.object.length())
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
endfunction " 1}}}

let dlib#core#test#TestStack# = s:TestStack

call s:TestStack.run()
