" Date create: 2014-10-29 14:40:22
" Last change: 2014-10-29 17:48:39
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

let s:Buffer = dlib#core#Object#.expand()

let s:Buffer.number = -1

"" {{{1
" Конструктор класса.
" @param number|string buffer [optional] Номер целевого буфера или его строковое имя. Если буфера с таким именем нет, создается новый буфер для указанного файла. Если параметр не указан, создается пустой буфер.
" @return Объектное представление буфера.
"" 1}}}
function! s:Buffer.new(...) dict " {{{1
  let l:obj = deepcopy(self)
  if exists('a:1')
    if type(a:1) == 0
      let l:obj.number = a:1
    elseif type(a:1) == 1
      if bufexists(a:1)
        let l:obj.number = bufnr(a:1)
      else
        let l:currentBuffNum = bufnr('%')
        exe 'e ' . a:1
        let l:obj.number = bufnr('%')
        exe 'buffer ' . l:currentBuffNum 
      endif
    endif
  else
    let l:currentBuffNum = bufnr('%')
    enew
    let l:obj.number = bufnr('%')
    setlocal buftype=nofile
    exe 'buffer ' . l:currentBuffNum
  endif
  return l:obj
endfunction " 1}}}

"" {{{1
" Метод выгружает целевой буфер из памяти. Метод не может быть выполнен, если целевым является последний буфер.
"" 1}}}
function! s:Buffer.unload() dict " {{{1
  exe 'bun! ' . self.number
endfunction " 1}}}

"" {{{1
" Метод получает или устанавливает опцию буфера.
" @param string option Имя целевой опции.
" @param number|string value [optional] Устанавливаемое значение.
" @return Если второй параметр не задан, метод возвращает значение целевой опции буфера.
"" 1}}}
function! s:Buffer.option(option, ...) " {{{1
  let l:currentBuffNum = bufnr('%')
  exe 'buffer ' . self.number
  if exists('a:1')
    exe 'let &l:' . a:option . ' = "' . a:1 . '"'
    exe 'buffer ' . l:currentBuffNum
  else
    exe 'let l:option = &l:' . a:option
    exe 'buffer ' . l:currentBuffNum
    return l:option
  endif
endfunction " 1}}}

let dlib#core#Buffer# = s:Buffer
