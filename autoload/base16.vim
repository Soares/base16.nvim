" This is the function that implements the Base16Highlight command.
function! base16#highlight(bang, group, ...)
  if !exists('g:base16_hex_colors')
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
    if l:arg =~? '^fg='
      let l:fg = 1
      let [l:gui, l:cterm] = s:Color(l:arg[3:])
      execute 'highlight' a:group 'guifg='.l:gui
      execute 'highlight' a:group 'ctermfg='.l:cterm
    elseif l:arg =~? '^bg='
      let l:bg = 1
      let [l:gui, l:cterm] = s:Color(l:arg[3:])
      execute 'highlight' a:group 'guibg='.l:gui
      execute 'highlight' a:group 'ctermbg='.l:cterm
    elseif l:arg =~? '^sp='
      let l:sp = 1
      let [l:gui, l:cterm] = s:Color(l:arg[3:])
      execute 'highlight' a:group 'guisp='.l:gui
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
  if a:color =~? '^\(bg\|fg\|background\|foreground\)$'
    return [a:color, 'NONE']
  endif
  try
    return [g:base16_hex_colors[a:color], g:base16_cterm_colors[a:color]]
  catch /E716:/
    echohl ErrorMsg
    echomsg 'unrecognized color:' a:color
    echohl None
    return [g:base16_hex_colors['antibase'], g:base16_cterm_colors['antibase']]
  endtry
endfunction
