" Date Create: 2014-10-29 21:52:31
" Last Change: 2014-11-10 11:27:28
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Buffer = dlib#core#Buffer#
let s:Stack = dlib#core#Stack#

let s:BufferStack = dlib#core#Object#.expand()

"" {{{1
" @var dlib#core#Stack# Стек буферов.
"" 1}}}
let s:BufferStack.stack = 0
"" {{{1
" @var integer Номер текущего буфера.
"" 1}}}
let s:BufferStack.number = 0

function! s:BufferStack.new() " {{{1
  let l:obj = deepcopy(self)
  let l:obj.stack = s:Stack.new()
  return l:obj
endfunction " 1}}}

function! s:BufferStack.push(buffer) dict " {{{1
  let self.number = a:buffer.number
  call self.stack.push(a:buffer)
  let a:buffer.bufferStack = self
  function! a:buffer.quit() " {{{2
    call self.bufferStack.quit()
  endfunction " 2}}}
  call a:buffer.listen('n', 'q', 'quit')
  return self
endfunction " 1}}}

function! s:BufferStack.active() dict " {{{1
  call self.stack.current().active()
endfunction " 1}}}

function! s:BufferStack.quit() dict " {{{1
  let l:currentBuffer = self.stack.pop()
  if self.stack.length() != 0
    let self.number = self.stack.current().number
    call self.active()
  endif
  call l:currentBuffer.delete()
endfunction " 1}}}

let dlib#view#BufferStack# = s:BufferStack
