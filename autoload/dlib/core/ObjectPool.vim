" Date create: 2014-10-29 22:52:51
" Last change: 2014-10-29 23:21:45
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3

let s:ObjectPool = {}

"" {{{1
" @var hash Хранилище объектов.
"" 1}}}
let s:ObjectPool.pool = {}

"" {{{1
" Метод пытается получить объект из хранилища по его ключу.
" @param string key Ключь целевого объекта. Рекомендуется в качестве ключа использовать следующую строковую последовательность: <ИмяКласса>:<Ключ>.
" @return hash|integer Целевой объект или ноль, если объект отсутствует в хранилище.
"" 1}}}
function! s:ObjectPool.get(key) " {{{1
  if has_key(self.pool, a:key)
    return self.pool[a:key]
  else
    return 0
  endif
endfunction " 1}}}

"" {{{1
" Метод добавляет объект в хранилище.
" @param string key Ключь добавляемого объекта. Рекомендуется в качестве ключа использовать следующую строковую последовательность: <ИмяКласса>:<Ключ>.
" @param hash obj Добавляемый объект.
" @return dlib#core#ObjectPool# Исходный объект.
"" 1}}}
function! s:ObjectPool.set(key, obj) " {{{1
  let self.pool[a:key] = a:obj
  return self
endfunction " 1}}}

let dlib#core#ObjectPool# = s:ObjectPool
