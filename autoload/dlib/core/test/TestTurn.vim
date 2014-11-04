" Date create: 2014-11-04 12:44:50
" Last change: 2014-11-04 12:47:53
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

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
" @covers dlib#core#Turn#.push
"" 1}}}
function! s:TestTurn.testPush() " {{{1
  call self.object.push(1)
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.shift())
endfunction " 1}}}

"" {{{1
" @covers dlib#core#Turn#.shift
"" 1}}}
function! s:TestTurn.testShift() " {{{1
  call self.object.push(1)
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(1, self.object.shift())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(2, self.object.shift())
  call self.assertDict(self.object, self.object.shift())
endfunction " 1}}}

"" {{{1
" @covers dlib#core#Turn#.current
"" 1}}}
function! s:TestTurn.testCurrent() " {{{1
  call self.object.push(1)
  call self.assertInteger(1, self.object.current())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.current())
endfunction " 1}}}

"" {{{1
" @covers dlib#core#Turn#.length
"" 1}}}
function! s:TestTurn.testLength() " {{{1
  call self.assertInteger(0, self.object.length())
  call self.object.push(1)
  call self.assertInteger(1, self.object.length())
  call self.object.push(2)
  call self.assertInteger(2, self.object.length())
endfunction " 1}}}

let dlib#core#test#TestTurn# = s:TestTurn

call s:TestTurn.run()
