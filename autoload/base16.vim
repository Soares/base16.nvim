" This is the function that implements the Base16Highlight command.
function! base16#highlight(bang, group, ...)
  if !exists('g:base16_color_dict')
    echohl ErrorMsg
    echomsg 'You must apply a base16 colorscheme before using Base16Highlight'
    echohl None
    return
  endif
  let l:fg = 0
  let l:bg = 0
  let l:sp = 0
  let l:attrs = []
  for l:arg in a:000
    if l:arg =~# 'fg='
      let l:fg = 1
      let l:color = s:Color(l:arg[3:])
      execute 'highlight' a:group 'guifg='.l:color
    elseif l:arg =~# 'bg='
      let l:bg = 1
      let l:color = s:Color(l:arg[3:])
      execute 'highlight' a:group 'guibg='.l:color
    elseif l:arg =~# 'sp='
      let l:sp = 1
      let l:color = s:Color(l:arg[3:])
      execute 'highlight' a:group 'guisp='.l:color
    else
      call add(l:attrs, l:arg)
    endif
  endfor
  if l:fg == 0 && a:bang
    execute 'highlight' a:group 'guifg=NONE'
  endif
  if l:bg == 0 && a:bang
    execute 'highlight' a:group 'guibg=NONE'
  endif
  if l:sp == 0 && a:bang
    execute 'highlight' a:group 'guisp=NONE'
  endif
  if len(l:attrs) > 0
    execute 'highlight' a:group 'gui='.join(l:attrs, ',')
  elseif a:bang
    execute 'highlight' a:group 'gui=NONE'
  endif
endfunction


" Looks up a color in the color dictionary.
" Vim allows you to specify special colors 'bg' and 'fg' for the normal
" background and foreground. We nede to implement special-case code for
" handling those (rather than just using 'base' and 'antibase') because it
" might be the case that the normal background is nothing (if, e.g., the user
" wants vim to have a transparent background so that the terminal image
" / transparency will show through).
function! s:Color(color)
  if a:color == 'bg' || a:color == 'background' || a:color == 'fg' || a:color == 'foreground'
    return a:color
  endif
  try
    return g:base16_color_dict[a:color]
  catch /E716:/
    echohl ErrorMsg
    echomsg 'unrecognized color:' a:color
    echohl None
    return g:base16_color_dict['antibase']
  endtry
endfunction
