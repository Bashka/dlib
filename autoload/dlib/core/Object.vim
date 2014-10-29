" Date create: 2014-10-29 09:22:59
" Last change: 2014-10-29 09:48:33
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

let s:Object = {}

function! s:Object.new() dict " {{{2
  return deepcopy(self)
endfunction " 2}}}

let dlib#core#Object# = s:Object
