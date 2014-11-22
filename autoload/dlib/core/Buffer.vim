" Date Create: 2014-10-29 14:40:22
" Last Change: 2014-11-10 11:27:04
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:ObjectPool = dlib#core#ObjectPool#

"" {{{1
" Класс представляет буфер редактора и позволяет как управлять им, так и создавать новые буферы.
"" 1}}}
let s:Buffer = dlib#core#Object#.expand()

"" {{{1
" @var integer Номер буфера.
"" 1}}}
let s:Buffer.number = 0
"" {{{1
" @var string Имя буфера.
"" 1}}}
let s:Buffer.name = ''
"" {{{1
" @var hash Словарь опций, установленных для данного буфера.
"" 1}}}
let s:Buffer.options = {}
"" {{{1
" @var hash Словарь привязок команд для данного буфера.
"" 1}}}
let s:Buffer.map = {}
"" {{{1
" @var hash Словарь привязок слушателей для данного буфера.
"" 1}}}
let s:Buffer.listeners = {}

"" {{{1
" Конструктор класса.
" @param integer|stringr buffer [optional] Номер целевого буфера или имя нового буфера. Если параметр не задан, предполагается текущий буфер.
"" 1}}}
function! s:Buffer.new(...) " {{{1
  let l:obj = deepcopy(self)
  if !exists('a:1')
    let l:bufNum = bufnr('%')
    let l:obj.name = bufname(l:bufNum)
  elseif type(a:1) == 0
    if !bufexists(a:1) " {{{2
      throw 'Buffer ' . a:1 . ' not found.'
    endif " }}}
    let l:bufNum = a:1
    let l:obj.name = bufname(l:bufNum)
  elseif type(a:1) == 1
    let l:bufNum = bufnr('#' . a:1 . '#', 1)
    let l:obj.name = a:1
    call l:obj.option('buftype', 'nofile')
  endif
  let l:oldObj = s:ObjectPool.get('dlib#core#Buffer#:' . l:bufNum)
  if type(l:oldObj) != 0
    return l:oldObj
  endif
  let l:obj.number = l:bufNum
  call s:ObjectPool.set('dlib#core#Buffer#:' . l:obj.number, l:obj)
  return l:obj
endfunction " 1}}}

"" {{{1
" Метод удаляет буфер.
"" 1}}}
function! s:Buffer.delete() dict " {{{1
  call s:ObjectPool.delete('dlib#core#Buffer#:' . self.number)
  exe 'bw! ' . self.number
endfunction " 1}}}

"" {{{1
" Метод возвращает или устанавливает значение опции буфера. Опции будут сохраняться даже при выгрузке буфера из памяти.
" Метод способен вернуть значение только той опции буфера, которая была установлена этим же методом ранее.
" Если метод используется для установки значения опции, то изменения вступят в силу только после вызова метода active.
" @param string name Имя целевой опции.
" @param string|integer value [optional] Значение, устанавливаемое для целевой опции. Если данный параметр не передан, метод возвращает значение целевой опции.
" @return string|dlib#core#Buffer# Значение целевой опции или исходный объект, если второй параметр не передан.
"" 1}}}
function! s:Buffer.option(name, ...) dict " {{{1
  if !exists('a:1')
    return self.options[a:name]
  else
    let self.options[a:name] = a:1
    return self
  endif
endfunction " 1}}}

"" {{{1
" Метод создает привязку команды для буфера. Привязки будут сохраняться даже при выгрузке буфера из памяти.
" @param string mode Режим, для которого создается привязка. Возможно одно из следующих значений: n, v, o, i, l, c.
" @param string sequence Комбинация, для которой создается привязка.
" @param string command Связываемая команда.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.noremap(mode, sequence, command) dict " {{{1
  if !has_key(self.map, a:mode)
    let self.map[a:mode] = {}
  endif
  let self.map[a:mode][a:sequence] = a:command
  return self
endfunction " 1}}}

"" {{{1
" Метод создает привязку функции-обработчика для буфера. Привязки будут сохраняться даже при выгрузке буфера из памяти.
" @param string mode Режим, для которого создается привязка. Возможно одно из следующих значений: n, v, o, i, l, c.
" @param string sequence Комбинация, для которой создается привязка.
" @param string listener Имя метода данного объекта, который будет вызываться при использовании заданной комбинации.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.listen(mode, sequence, listener) dict " {{{1
  if !has_key(self.listeners, a:mode)
    let self.listeners[a:mode] = {}
  endif
  let self.listeners[a:mode][a:sequence] = a:listener
  return self
endfunction " 1}}}

"" {{{1
" Метод создает привязку функции-обработчика для буфера в режиме normal. Привязки будут сохраняться даже при выгрузке буфера из памяти.
" @param string|hash sequence Комбинация, для которой создается привязка или
" словарь, ключами которого являются комбинации, а значениями имена методов-слушателей.
" @param string listener [optional] Если первый параметр является строкой, то имя метода данного объекта, который будет вызываться при использовании заданной комбинации.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.nlisten(sequence, ...) " {{{1
  if exists('a:1')
    call self.listen('n', a:sequence, a:1)
  elseif type(a:sequence) == 4
    for [l:sequence, l:listener] in items(a:sequence)
      call self.listen('n', l:sequence, l:listener)
    endfor
  endif
  return self
endfunction " 1}}}

"" {{{1
" Метод удаляет ранее созданную с помощью метода noremap привязку.
" @param string mode Режим, для которого удаляется привязка. Возможно одно из следующих значений: n, v, o, i, l, c.
" @param string sequence Комбинация, для которой удаляется привязка.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.unmap(mode, sequence) dict " {{{1
  if has_key(self.map, a:mode)
    if has_key(self.map[a:mode], a:sequence) 
      call remove(self.map[a:mode][a:sequence])
    endif
  endif
endfunction " 1}}}

"" {{{1
" Метод удаляет ранее созданную с помощью метода listen привязку.
" @param string mode Режим, для которого удаляется привязка. Возможно одно из следующих значений: n, v, o, i, l, c.
" @param string sequence Комбинация, для которой удаляется привязка.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.detach(mode, sequence) dict " {{{1
  if has_key(self.listeners, a:mode)
    if has_key(self.listeners[a:mode], a:sequence) 
      call remove(self.listeners[a:mode][a:sequence])
    endif
  endif
endfunction " 1}}}

"" {{{1
" Метод делает вызываемый буфер текущим применяя все опции и привязки.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.active() dict " {{{1
  exe 'buffer ' . self.number
  if has_key(self, 'render')
    normal ggVGd
    if type(self.render) == 2
      silent put = self.render()
    else
      exe 'silent put = ' . self.render
    endif
    keepjumps 0d
  endif
  for l:mode in keys(self.map)
    for [l:sequence, l:command] in items(self.map[l:mode])
      exe l:mode . 'noremap <buffer> ' . l:sequence . ' ' . l:command
    endfor
  endfor
  for l:mode in keys(self.listeners)
    for [l:sequence, l:listener] in items(self.listeners[l:mode])
      exe l:mode . 'noremap <buffer> ' . l:sequence . ' :call dlib#core#Buffer#.new(bufnr("%")).' . l:listener . '()<CR>'
    endfor
  endfor
  for [l:option, l:value] in items(self.options)
    exe 'let &l:' . l:option . ' = "' . l:value . '"'
  endfor
  return self
endfunction " 1}}}

"" {{{1
" Метод, возвращающий строку, которая будет обновлять содержимое буфера при каждой его активации. Данный метод может быть переопределен в экземплярах класса.
" @return string Строка, устанавливаемая в качестве содержимого буфера при его активации.
"" 1}}}
"function! s:Buffer.render() dict " {{{1
"  return ''
"endfunction " 1}}}

let dlib#core#Buffer# = s:Buffer
