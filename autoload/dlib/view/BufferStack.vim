" Date create: 2014-10-29 21:52:31
" Last change: 2014-10-29 23:25:54
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

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
  call a:buffer.noremap('n', 'q', ':call dlib#core#Buffer#.new(bufnr("%")).bufferStack.quit()<CR>')
endfunction " 1}}}

function! s:BufferStack.active() dict " {{{1
  call self.stack.current().active()
endfunction " 1}}}

function! s:BufferStack.quit() dict " {{{1
  if self.stack.length() == 1
    call self.stack.current().unload()
  else
    call self.stack.pop()
    let self.number = self.stack.current().number
    call self.active()
  endif
endfunction " 1}}}

let dlib#view#BufferStack# = s:BufferStack
