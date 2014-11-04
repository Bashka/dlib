" Date create: 2014-11-04 12:01:21
" Last change: 2014-11-04 12:44:05
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

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
" @covers dlib#core#Stack#.push
"" 1}}}
function! s:TestStack.testPush() " {{{1
  call self.object.push(1)
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.pop())
endfunction " 1}}}

"" {{{1
" @covers dlib#core#Stack#.pop
"" 1}}}
function! s:TestStack.testPop() " {{{1
  call self.object.push(1)
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(2, self.object.pop())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.pop())
  call self.assertDict(self.object, self.object.pop())
endfunction " 1}}}

"" {{{1
" @covers dlib#core#Stack#.current
"" 1}}}
function! s:TestStack.testCurrent() " {{{1
  call self.object.push(1)
  call self.assertInteger(1, self.object.current())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.current())
endfunction " 1}}}

"" {{{1
" @covers dlib#core#Stack#.length
"" 1}}}
function! s:TestStack.testLength() " {{{1
  call self.assertInteger(0, self.object.length())
  call self.object.push(1)
  call self.assertInteger(1, self.object.length())
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
endfunction " 1}}}

let dlib#core#test#TestStack# = s:TestStack

call s:TestStack.run()
