" Date create: 2014-10-29 14:40:22
" Last change: 2014-11-03 23:06:28
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

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
" @var integer|function Функция, возвращающая строку, которая будет обновлять содержимое буфера при каждой его активации. Ноль, если обновление не требуется.
"" 1}}}
let s:Buffer.render = 0
"" {{{1
" @var hash Словарь опций, установленных для данного буфера.
"" 1}}}
let s:Buffer.options = {}
"" {{{1
" @var hash Словарь привязок для данного буфера.
"" 1}}}
let s:Buffer.map = {}

"" {{{1
" Конструктор класса. Если объект для целевого буфера уже существует, то повторный вызов этого метода для получения объекта того же буфера приведет к возврату существующего объекта.
" @param number|string buffer [optional] Номер целевого буфера. Если указано имя файла, для него создается новый буфер. Если параметр не указан, создается пустой буфер.
" @return Объектное представление буфера.
"" 1}}}
function! s:Buffer.new(...) " {{{1
  if exists('a:1')
    let l:oldObj = s:ObjectPool.get('Buffer:' . a:1)
    if type(l:oldObj) != 0
      return l:oldObj
    endif
    let l:obj = deepcopy(self)
    if type(a:1) == 0
      let l:obj.number = a:1
    elseif type(a:1) == 1
      let l:currentBuffNum = bufnr('%')
      exe 'e ' . a:1
      let l:obj.number = bufnr('%')
      exe 'buffer ' . l:currentBuffNum 
    endif
  else
    let l:obj = deepcopy(self)
    let l:currentBuffNum = bufnr('%')
    enew
    let l:obj.number = bufnr('%')
    exe 'buffer ' . l:currentBuffNum
  endif
  call s:ObjectPool.set('Buffer:' . l:obj.number, l:obj)
  return l:obj
endfunction " 1}}}

"" {{{1
" Метод выгружает целевой буфер из памяти. Метод не может быть выполнен, если целевым является последний буфер.
"" 1}}}
function! s:Buffer.unload() dict " {{{1
  exe 'bun! ' . self.number
endfunction " 1}}}

"" {{{1
" Метод удаляет целевой буфер.
"" 1}}}
function! s:Buffer.delete() dict " {{{1
  exe 'bw! ' . self.number
endfunction " 1}}}

"" {{{1
" Метод делает буфер активным для текущего окна.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.active() dict " {{{1
  exe 'buffer ' . self.number
  if type(self.render) == 2
    call self.content(self.render())
  endif
  for l:mode in keys(self.map)
    for [l:sequence, l:command] in items(self.map[l:mode])
      call self.noremap(l:mode, l:sequence, l:command)
    endfor
  endfor
  for [l:option, l:value] in items(self.options)
    call self.option(l:option, l:value)
  endfor
  return self
endfunction " 1}}}

"" {{{1
" Метод получает или устанавливает опцию буферу. Опции будут сохраняться даже при выгрузке буфера из памяти.
" @param string|hash option Имя целевой опции или словарь, содержащий имена и значения опций. Важно помнить, что в случае использования словаря опции будут применяться в алфавитном порядке следования их наименований.
" @param number|string value [optional] Устанавливаемое значение.
" @return string|integer|dlib#core#Buffer# Если второй параметр не задан или первым параметром является словарь, метод возвращает значение целевой опции буфера, в противном случае возвращается исходный объект.
"" 1}}}
function! s:Buffer.option(option, ...) dict " {{{1
  let l:currentBuffNum = bufnr('%')
  exe 'buffer ' . self.number
  if exists('a:1')
    let self.options[a:option] = a:1
    exe 'let &l:' . a:option . ' = "' . a:1 . '"'
    exe 'buffer ' . l:currentBuffNum
    return self
  else
    if type(a:option) == 4
      for [l:option, l:value] in items(a:option)
        call self.option(l:option, l:value)
      endfor
      return self
    else
      exe 'let l:option = &l:' . a:option
      exe 'buffer ' . l:currentBuffNum
      return l:option
    endif
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
  let l:currentBuffNum = bufnr('%')
  exe 'buffer ' . self.number
  if !has_key(self.map, a:mode)
    let self.map[a:mode] = {}
  endif
  let self.map[a:mode][a:sequence] = a:command
  exe a:mode . 'noremap <buffer> ' . a:sequence . ' ' . a:command
  exe 'buffer ' . l:currentBuffNum
  return self
endfunction " 1}}}

"" {{{1
" Метод создает привязку функции-обработчика для буфера. Привязки будут сохраняться даже при выгрузке буфера из памяти.
" @param string mode Режим, для которого создается привязка. Возможно одно из следующих значений: n, v, o, i, l, c.
" @param string sequence Комбинация, для которой создается привязка.
" @param string listener Имя метода данного буфера, который будет вызываться при использовании заданной комбинации.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.listen(mode, sequence, listener) " {{{1
  let l:currentBuffNum = bufnr('%')
  exe 'buffer ' . self.number
  if !has_key(self.map, a:mode)
    let self.map[a:mode] = {}
  endif
  let self.map[a:mode][a:sequence] = ' :call dlib#core#Buffer#.new(bufnr("%")).' . a:listener . '()<CR>'
  exe a:mode . 'noremap <buffer> ' . a:sequence . self.map[a:mode][a:sequence]
  exe 'buffer ' . l:currentBuffNum
  return self
endfunction " 1}}}

"" {{{1
" Метод удаляет ранее созданную привязку из буфера.
" @param string mode Режим, для которого удаляется привязка. Возможно одно из следующих значений: n, v, o, i, l, c.
" @param string sequence Комбинация, для которой удаляется привязка.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.unmap(mode, sequence) dict " {{{1
  let l:currentBuffNum = bufnr('%')
  exe 'buffer ' . self.number
  if has_key(self.map, a:mode)
    if has_key(self.map[a:mode], a:sequence) 
      call remove(self.map[a:mode][a:sequence])
    endif
  endif
  exe a:mode . 'unmap <buffer> ' . a:sequence
  exe 'buffer ' . l:currentBuffNum
  return self
endfunction " 1}}}

"" {{{1
" Метод устанавливает содержимое буфера.
" @param string content Новое содержимое буфера.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.content(content) dict " {{{1
  let l:currentBuffNum = bufnr('%')
  exe 'buffer ' . self.number
  normal ggVGd
  silent put=a:content
  keepjumps 0d
  exe 'buffer ' . l:currentBuffNum
  return self
endfunction " 1}}}

"" {{{1
" Метод выполняет заданную последовательность для буфера.
" @param string sequence Выполняемая последовательность.
" @return dlib#core#Buffer# Исходный объект.
"" 1}}}
function! s:Buffer.make(sequence) dict " {{{1
  let l:currentBuffNum = bufnr('%')
  exe 'buffer ' . self.number
  exe 'normal ' . a:sequence
  exe 'buffer ' . l:currentBuffNum
  return self
endfunction " 1}}}

let dlib#core#Buffer# = s:Buffer
