if exists('g:loaded_alidistlint')
  finish
endif

let g:loaded_alidistlint = 1

lua require('alidistlint').setup() 