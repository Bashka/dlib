" Date create: 2014-10-29 19:59:51
" Last change: 2014-10-30 09:07:55
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

let s:Buffer = dlib#core#Buffer#

let s:Window = dlib#core#Object#.expand()

"" {{{1
" @var integer Номер окна.
"" 1}}}
let s:Window.number = 0

"" {{{1
" Метод устанавливает активное окно по его номеру.
" @param integer number Номер целевого окна.
"" 1}}}
function! s:Window.select(number) " {{{1
  exe a:number . 'wincmd w'
endfunction " 1}}}

"" {{{1
" Конструктор класса.
" @param integer|string number [optional] Номер целевого окна или способ создания нового окна (g - разделение текущего окна по горизонтали, v - разделение текущего окна по вертикали). Если параметр не задан, объект представляет активное окно.
"" 1}}}
function! s:Window.new(...) " {{{1
  let l:obj = deepcopy(self)
  if exists('a:1')
    if type(a:1) == 0
      let l:obj.number = a:1
    elseif type(a:1) == 1
      let l:currentWinNumber = winnr()
      if a:1 == 'v'
        vnew
      elseif a:1 == 'g'
        new
      endif
      let l:obj.number = winnr()
      call self.select(l:currentWinNumber + 1)
    endif
  else
    let l:obj.number = winnr()
  endif
  return l:obj
endfunction " 1}}}

"" {{{1
" Метод делает окно активным.
" @return dlib#core#Window# Исходный объект.
"" 1}}}
function! s:Window.active() dict " {{{1
  call self.select(self.number)
  return self
endfunction " 1}}}

"" {{{1
" Метод определяет буфер, связанный с окном или устанавливает его для окна.
" @param dlib#core#Buffer#|integer buffer Устанавливаемый буфер или его номер.
" @return dlib#core#Buffer# Буфер, установленный в окне.
"" 1}}}
function! s:Window.buffer(...) dict " {{{1
  if exists('a:1')
    let l:currentWinNumber = winnr()
    call self.active()
    if type(a:1) == 0
      let l:buffer = s:Buffer.new(a:1)
    else
      let l:buffer = a:1
    endif
    call l:buffer.active()
    call self.select(l:currentWinNumber)
  else
    return s:Buffer.new(winbufnr(self.number))
  endif
endfunction " 1}}}

let dlib#core#Window# = s:Window
