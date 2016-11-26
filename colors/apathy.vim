" Base16 Apathy (https://github.com/chriskempson/base16)
" Scheme: Jannik Siebert (https://github.com/janniks)
" Neovim template: Nate Soares (http://so8r.es)

" The main ideas of this template are as follows:
" 1. Expose the available colors via g:base16_hex_colors and
"    g:base16_cterm_colors.
" 2. Use the default vim color allocation. In other words, compared to the
"    default vim theme, using this theme should change which red, blue, and
"    green you see, but it should not change which things appear red vs blue
"    vs green.
" 3. Expose a g:base16_color_overrides parameter so that you *can* change
"    which things appear red vs blue vs green, in such a way that if you
"    change themes mid-flight then your customizations get re-applied.
" 4. Expose a Base16Highlight command that you can use in case the above
"    parameters are not enough for you.
" 5. Expose a g:base16_transparent_background option in case you want vim to
"    let the terminal set the background (e.g., if your terminal has
"    a transparent background or a background image).

" Boilerplate: clear existing highlighting, reset the syntax, etc.
if exists('syntax_on')
  syntax reset
endif

" Tell them our name.
let g:colors_name = 'apathy'


" The Color Dictionary -------------------------------------------------------
" You may use this global dictionary to access your 16 colors.
" If you don't want it, you can always |:unlet| it after |:colorscheme|.
" In addition to these 16 colors, you'll also have relative colors which link
" to the light/dark greys differently depending on &background. See below.
"
" dark3 is the darkest grey; light3 is the lightest grey.
let g:base16_hex_colors = {
      \ 'black':  '#031A16',
      \ 'dark3':  '#0B342D',
      \ 'dark2':  '#184E45',
      \ 'dark1':  '#2B685E',
      \ 'light1': '#5F9C92',
      \ 'light2': '#81B5AC',
      \ 'light3': '#A7CEC8',
      \ 'white':  '#D2E7E4',
      \ 'red':    '#3E9688',
      \ 'orange': '#3E7996',
      \ 'yellow': '#3E4C96',
      \ 'green':  '#883E96',
      \ 'aqua':   '#963E4C',
      \ 'blue':   '#96883E',
      \ 'purple': '#4C963E',
      \ 'brown':  '#3E965B'}

let g:base16_cterm_colors = {
      \ 'black':  0,
      \ 'dark3':  18,
      \ 'dark2':  19,
      \ 'dark1':  8,
      \ 'light1': 20,
      \ 'light2': 7,
      \ 'light3': 21,
      \ 'white':  15,
      \ 'red':    1,
      \ 'orange': 16,
      \ 'yellow': 3,
      \ 'green':  2,
      \ 'aqua':   6,
      \ 'blue':   4,
      \ 'purple': 5,
      \ 'brown':  17}



" The extra colors that you have at your disposal are:
" base similar3 similar2, similar1, contrast1, contrast2, contrast3 antibase.
" If background is dark, then this spectrum runs black ... white.
" If background is light, it runs white ... black.
" Higher numbers are more extreme. So similar3 is most similar to base, and
" contrast3 is most similar to antibase.
for s:dict in [g:base16_hex_colors, g:base16_cterm_colors]
  if &background == 'dark'
    let s:dict['base'] = s:dict['black']
    let s:dict['similar3'] = s:dict['dark3']
    let s:dict['similar2'] = s:dict['dark2']
    let s:dict['similar1'] = s:dict['dark1']
    let s:dict['contrast1'] = s:dict['light1']
    let s:dict['contrast2'] = s:dict['light2']
    let s:dict['contrast3'] = s:dict['light3']
    let s:dict['antibase'] = s:dict['white']
  else
    let s:dict['base'] = s:dict['white']
    let s:dict['similar3'] = s:dict['light3']
    let s:dict['similar2'] = s:dict['light2']
    let s:dict['similar1'] = s:dict['light1']
    let s:dict['contrast1'] = s:dict['dark1']
    let s:dict['contrast2'] = s:dict['dark2']
    let s:dict['contrast3'] = s:dict['dark3']
    let s:dict['antibase'] = s:dict['black']
  endif
endfor
unlet s:dict


" The Base16Highlight Command ------------------------------------------------
" We have to define this in the color file (instead of in a plugin/ file)
" because the colorscheme may well be run before plugins have loaded. We do
" outsource most of the work to an autoload function, though.
"
" TODO: Implement completion.  It would be nice to complete highlight groups,
" and attributes, and base16 colors.
command! -bang -nargs=+ Base16Highlight call base16#highlight(<q-bang>=='!', <f-args>)


" The Color Specifications ---------------------------------------------------
" Our colors are more-or-less the style that you get if you do |:hi clear|.
" In other words, by default, the base16 theme will change whwich
" yellow/red/etc you're seeing, but not which things are yellow vs red.
"
" There are a few exceptions to this rule.
" 1. When it comes to UI components (like the status line and the cursor
"    line), this theme does a bit of work to make everything look nice. In
"    this regard, the theme here is built off of the original solarized theme,
"    which I think did a pretty good job at this. (This is a finickey task.)
" 2. We often implement background colors using the reverse display-mode. This
"    makes life better when using cursorline: if ErrorMsg has fg=white bg=red,
"    then when you put a cursorline on it and it sets bg=similar2, error
"    messages now appear with white text and grey background. If instead
"    ErroMsg has bg=white fg=red reverse then the bg remains red the cursor is
"    over the message.
" 3. We use greys for thinsg like Comment and NonText, when the default
"    styling uses blues.
let s:specs = {}

" If the user has set g:base16_transparent_background then the normal group
" has no background color.
if get(g:, 'base16_transparent_background', 0)
  let s:specs['Normal'] = 'fg=antibase'
else
  let s:specs['Normal'] = 'fg=antibase bg=base'
endif

" The core vim defaults are as follows:
"   Comment        fg=#80a0ff
"   Constant       fg=#ffa0a0
"   Special        fg=Orange
"   Identifier     fg=#40ffff
"   Statement      bold fg=#ffff60
"   PreProc        fg=#ff80ff
"   Type           bold fg=#60ff60
"   Underlined     underline fg=#80a0ff
"   Ignore         fg=bg
"   Error          fg=White bg=Red
"   Todo           fg=Blue bg=Yellow
" See |group-name| for details on what means what.
" We will follow this pattern with a few minor changes:
" 1. We'll use the reverse trick on ErrorMsg and TODO
" 2. TODO will be black-on-yellow, because blue-on-yellow is garish.
" To override these, see the discussion on g:base16_color_overrides below.
let s:specs['Comment']     = 'fg=blue italic'
let s:specs['Constant']    = 'fg=red'
let s:specs['Identifier']  = 'fg=aqua'
let s:specs['Statement']   = 'fg=yellow'
let s:specs['PreProc']     = 'fg=purple'
let s:specs['Type']        = 'fg=green'
let s:specs['Special']     = 'fg=orange'
let s:specs['Underlined']  = 'fg=blue underline'
let s:specs['Ignore']      = 'fg=bg'
let s:specs['Error']       = 'fg=red bg=white bold reverse'
let s:specs['Todo']        = 'fg=yellow bg=black bold reverse'

" For the remaining defaults, and a description of what the groups do, see
" |highlight-groups|. The defaults are included here. We make a number of
" small changes, mainly centered on using greys where the defaults use blues.
" However, we also make some major changes to the Diff* colors, which were not
" green/red/blue for add/remove/change, which is crazy.
"
" First up: highlighting for special types of characters.
"   SpecialKey     fg=Cyan
"   NonText        bold fg=Blue
"   Conceal        fg=LightGrey bg=DarkGrey
"   MatchParen     bg=DarkCyan
let s:specs['SpecialKey']   = 'fg=similar1 bold'
let s:specs['NonText']      = 'fg=similar2'
let s:specs['Conceal']      = 'fg=contrast1 bg=similar3'
let s:specs['MatchParen']   = 'fg=aqua reverse'

" Next up: highlighting for the various kinds of messages, questions, and
" prompts that nvim throws at you.
"   ModeMsg        bold
"   MoreMsg        bold fg=SeaGreen
"   WarningMsg     fg=Red
"   ErrorMsg       fg=White bg=Red
"   Question       bold fg=Green
"   Title          bold fg=Magenta
let s:specs['ModeMsg']     = 'bold'
let s:specs['MoreMsg']     = 'fg=green bold'
let s:specs['WarningMsg']  = 'fg=red bold'
let s:specs['ErrorMsg']    = 'fg=red bg=white reverse'
let s:specs['Question']    = 'fg=aqua bold'
let s:specs['Title']       = 'fg=purple bold'

" Next up: highlighting for search, completion, and other nvim navigation
" functionality.
"   IncSearch      reverse
"   Search         fg=Black bg=Yellow
"   WildMenu       fg=Black bg=Yellow
"   Directory      fg=Cyan
" We've changed IncSearch to black-on-orange, which plays nicely with search
" being black-on-yellow. (This prevents a confusing scenario where you search,
" e.g., for something that is ErrorMsg highlighted, and it doesn't show up as
" the usual search color.)
let s:specs['IncSearch']  = 'fg=orange bg=black reverse'
let s:specs['Search']     = 'fg=yellow bg=black reverse'
let s:specs['WildMenu']   = 'fg=yellow bg=black reverse'
let s:specs['Directory']  = 'fg=aqua'

" Next up: diff highlighting. We make some big changes here, because come on,
" look at these silly defaults.
"   DiffAdd        bg=DarkBlue
"   DiffChange     bg=DarkMagenta
"   DiffDelete     bold fg=Blue bg=DarkCyan
"   DiffText       bold bg=Red
let s:specs['DiffAdd']     = 'fg=green bg=similar3 bold'
let s:specs['DiffChange']  = 'fg=yellow bg=similar3 sp=yellow bold'
let s:specs['DiffDelete']  = 'fg=red bg=similar3 bold'
let s:specs['DiffText']    = 'fg=blue bg=similar3 sp=blue bold'

" Next up: Spelling. We keep the defaults.
"   SpellBad       undercurl sp=Red
"   SpellCap       undercurl sp=Blue
"   SpellRare      undercurl sp=Magenta
"   SpellLocal     undercurl sp=Cyan
let s:specs['SpellBad'] = 'undercurl sp=red'
let s:specs['SpellCap'] = 'undercurl sp=blue'
let s:specs['SpellRare'] = 'undercurl sp=purple'
let s:specs['SpellLocal'] = 'undercurl sp=aqua'

" Now the popup menu. We keep the defaults.
"   Pmenu          bg=Magenta
"   PmenuSel       bg=DarkGrey
"   PmenuSbar      bg=Grey
"   PmenuThumb     bg=White
let s:specs['Pmenu']      = 'fg=light3 bg=purple'
let s:specs['PmenuSel']   = 'fg=light3 bg=dark1'
let s:specs['PmenuSbar']  = 'bg=dark3'
let s:specs['PmenuThumb'] = 'bg=white'

" Now for all the interface components.
" This is a pretty finickey set of UI elements to get right. We want:
" 1. Cursorline to be distinguished from statusline
" 2. Active statusline to be distinguished from inactive statusline
" 3. Boundaries between windows to be cleary dermarcated
" 4. Visual mode to be distinguished from all of the above
" 5. We want the thing to look pretty nice.
" It's difficult to meet all these constraints at once.
" Right now, this template uses more-or-less the settings from the original
" vim solarized theme. I recommend not messing with it too much.
"
" Here are the vim defaults:
"   LineNr         fg=Yellow
"   CursorLineNr   bold fg=Yellow
"   CursorLine     bg=Grey40
"   CursorColumn   bg=Grey40
"   StatusLine     bold,reverse
"   StatusLineNC   reverse
"   VertSplit      reverse
"   Visual         bg=DarkGrey
let s:specs['LineNr']        = 'fg=similar1 bg=similar3'
let s:specs['CursorLineNr']  = 'fg=yellow bg=similar3 bold'
let s:specs['CursorLine']    = 'bg=similar3 sp=contrast2'
let s:specs['CursorColumn']  = 'bg=similar3'
let s:specs['Visual']        = 'bg=similar2'
let s:specs['StatusLine']    = 'fg=contrast2 bg=similar3 reverse bold'
let s:specs['StatusLineNC']  = 'fg=similar1 bg=similar3 reverse bold'
let s:specs['VertSplit']     = 'fg=similar1 bg=similar1'
"   TabLine        underline bg=DarkGrey
"   TabLineSel     bold
"   TabLineFill    reverse
let s:specs['TabLine']       = 'fg=contrast1 bg=similar3 sp=contrast1 underline'
let s:specs['TabLineSel']    = 'fg=similar2 bg=contrast3 sp=contrast1 underline reverse bold'
let s:specs['TabLineFill']   = 'fg=contrast1 bg=similar3 sp=contrast1 underline'
"   ColorColumn    bg=DarkRed
"   SignColumn     fg=Cyan bg=Grey
let s:specs['ColorColumn']   = 'bg=orange'
let s:specs['SignColumn']    = 'fg=contrast1 bg=similar3'
"   Folded         fg=Cyan bg=DarkGrey
"   FoldColumn     fg=Cyan bg=Grey
let s:specs['Folded']        = 'fg=contrast1 bg=similar3 underline bold'
let s:specs['FoldColumn']    = 'fg=contrast1 bg=similar3'
"   Cursor     reverse
"   TermCursor reverse
let s:specs['Cursor']        = 'reverse'
let s:specs['TermCursor']    = 'reverse'
highlight link TermCursor Cursor
highlight link lCursor Cursor


" Application ----------------------------------------------------------------
if exists('g:base16_color_overrides')
  call extend(s:specs, g:base16_color_overrides, 'force')
endif

" Normal must go first.
execute 'Base16Highlight! Normal' s:specs['Normal']
call remove(s:specs, 'Normal')
if has_key(get(g:, 'base16_color_modifiers', {}), 'Normal')
  execute 'Base16Highlight Normal' g:base16_color_modifiers['Normal']
  call remove(g:base16_color_modifiers, 'Normal')
endif

for [s:group, s:spec] in items(s:specs)
  execute 'Base16Highlight!' s:group s:spec
endfor

if exists('g:base16_color_modifiers')
  for [s:group, s:spec] in items(g:base16_color_modifiers)
    execute 'Base16Highlight' s:group s:spec
  endfor
endif

unlet s:group s:spec s:specs


" Neovim :terminal Configuration ---------------------------------------------
" The colors used by terminals started insight neovim.
" We do not set: light blue, light green, light cyan, light purple.
" Light red is set to orange.
if has('termguicolors') && &termguicolors
  let g:terminal_color_0  = g:base16_hex_colors['black']   " black
  let g:terminal_color_1  = g:base16_hex_colors['red']     " red
  let g:terminal_color_2  = g:base16_hex_colors['green']   " green
  let g:terminal_color_3  = g:base16_hex_colors['yellow']  " yellow
  let g:terminal_color_4  = g:base16_hex_colors['blue']    " blue
  let g:terminal_color_5  = g:base16_hex_colors['purple']  " magenta
  let g:terminal_color_6  = g:base16_hex_colors['aqua']    " cyan
  let g:terminal_color_7  = g:base16_hex_colors['light2']  " light grey
  let g:terminal_color_8  = g:base16_hex_colors['dark2']   " dark grey
  let g:terminal_color_9  = g:base16_hex_colors['orange']  " light red
  let g:terminal_color_10 = g:base16_hex_colors['green']   " light green
  let g:terminal_color_11 = g:base16_hex_colors['brown']   " light yellow
  let g:terminal_color_12 = g:base16_hex_colors['blue']    " light blue
  let g:terminal_color_13 = g:base16_hex_colors['purple']  " light magenta
  let g:terminal_color_14 = g:base16_hex_colors['aqua']    " light cyan
  let g:terminal_color_15 = g:base16_hex_colors['white']   " white
endif


" Airline config. ------------------------------------------------------------
if get(g:, 'base16_airline', 0)
  let s:palette = substitute('summerfruit', '-', '_', 'g').'_'.&background

  let g:airline#themes#{s:palette}#palette = {}
  let s:N1   = [ g:base16_hex_colors['dark3'], g:base16_hex_colors['green'], g:base16_cterm_colors['dark3'], g:base16_cterm_colors['green'] ]
  let s:N2   = [ g:base16_hex_colors['contrast3'], g:base16_hex_colors['similar2'], g:base16_cterm_colors['contrast3'], g:base16_cterm_colors['similar2'] ]
  let s:N3   = [ g:base16_hex_colors['aqua'], g:base16_hex_colors['similar3'], g:base16_cterm_colors['aqua'], g:base16_cterm_colors['similar3'] ]
  let g:airline#themes#{s:palette}#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#{s:palette}#palette.normal.airline_warning = [ g:base16_hex_colors['black'], g:base16_hex_colors['orange'], g:base16_cterm_colors['black'], g:base16_cterm_colors['orange'] ]
  let g:airline#themes#{s:palette}#palette.normal.airline_error = [ g:base16_hex_colors['black'], g:base16_hex_colors['red'], g:base16_cterm_colors['black'], g:base16_cterm_colors['red'] ]
  unlet s:N1 s:N2 s:N3

  let s:I1   = [ g:base16_hex_colors['dark3'], g:base16_hex_colors['blue'], g:base16_cterm_colors['dark3'], g:base16_cterm_colors['blue'] ]
  let s:I2   = [ g:base16_hex_colors['light3'], g:base16_hex_colors['dark2'], g:base16_cterm_colors['light3'], g:base16_cterm_colors['dark2'] ]
  let s:I3   = [ g:base16_hex_colors['orange'], g:base16_hex_colors['dark3'], g:base16_cterm_colors['orange'], g:base16_cterm_colors['dark3'] ]
  let g:airline#themes#{s:palette}#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#{s:palette}#palette.insert.airline_warning = [ g:base16_hex_colors['black'], g:base16_hex_colors['orange'], g:base16_cterm_colors['black'], g:base16_cterm_colors['orange'] ]
  let g:airline#themes#{s:palette}#palette.insert.airline_error = [ g:base16_hex_colors['black'], g:base16_hex_colors['red'], g:base16_cterm_colors['black'], g:base16_cterm_colors['red'] ]
  unlet s:I1 s:I2 s:I3

  let s:R1   = [ g:base16_hex_colors['dark3'], g:base16_hex_colors['red'], g:base16_cterm_colors['dark3'], g:base16_cterm_colors['red'] ]
  let s:R2   = [ g:base16_hex_colors['light3'], g:base16_hex_colors['dark2'], g:base16_cterm_colors['light3'], g:base16_cterm_colors['dark2'] ]
  let s:R3   = [ g:base16_hex_colors['orange'], g:base16_hex_colors['dark3'], g:base16_cterm_colors['orange'], g:base16_cterm_colors['dark3'] ]
  let g:airline#themes#{s:palette}#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
  let g:airline#themes#{s:palette}#palette.replace.airline_warning = [ g:base16_hex_colors['black'], g:base16_hex_colors['orange'], g:base16_cterm_colors['black'], g:base16_cterm_colors['orange'] ]
  let g:airline#themes#{s:palette}#palette.replace.airline_error = [ g:base16_hex_colors['black'], g:base16_hex_colors['red'], g:base16_cterm_colors['black'], g:base16_cterm_colors['red'] ]
  unlet s:R1 s:R2 s:R3

  let s:V1   = [ g:base16_hex_colors['dark3'], g:base16_hex_colors['purple'], g:base16_cterm_colors['dark3'], g:base16_cterm_colors['purple'] ]
  let s:V2   = [ g:base16_hex_colors['light3'], g:base16_hex_colors['dark2'], g:base16_cterm_colors['light3'], g:base16_cterm_colors['dark2'] ]
  let s:V3   = [ g:base16_hex_colors['orange'], g:base16_hex_colors['dark3'], g:base16_cterm_colors['orange'], g:base16_cterm_colors['dark3'] ]
  let g:airline#themes#{s:palette}#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
  let g:airline#themes#{s:palette}#palette.visual.airline_warning = [ g:base16_hex_colors['black'], g:base16_hex_colors['orange'], g:base16_cterm_colors['black'], g:base16_cterm_colors['orange'] ]
  let g:airline#themes#{s:palette}#palette.visual.airline_error = [ g:base16_hex_colors['black'], g:base16_hex_colors['red'], g:base16_cterm_colors['black'], g:base16_cterm_colors['red'] ]
  unlet s:V1 s:V2 s:V3

  let s:IA1   = [ g:base16_hex_colors['light2'], g:base16_hex_colors['dark3'], g:base16_cterm_colors['light2'], g:base16_cterm_colors['dark3'] ]
  let s:IA2   = [ g:base16_hex_colors['light2'], g:base16_hex_colors['dark3'], g:base16_cterm_colors['light2'], g:base16_cterm_colors['dark3'] ]
  let s:IA3   = [ g:base16_hex_colors['light2'], g:base16_hex_colors['dark3'], g:base16_cterm_colors['light2'], g:base16_cterm_colors['dark3'] ]
  let g:airline#themes#{s:palette}#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
  let g:airline#themes#{s:palette}#palette.inactive.airline_warning = [ g:base16_hex_colors['black'], g:base16_hex_colors['orange'], g:base16_cterm_colors['black'], g:base16_cterm_colors['orange'] ]
  let g:airline#themes#{s:palette}#palette.inactive.airline_error = [ g:base16_hex_colors['black'], g:base16_hex_colors['red'], g:base16_cterm_colors['black'], g:base16_cterm_colors['red'] ]
  unlet s:IA1 s:IA2 s:IA3

  let g:airline#themes#{s:palette}#palette.accents = {
          \ 'red': [ g:base16_hex_colors['red'], g:base16_hex_colors['red'], g:base16_cterm_colors['red'], g:base16_cterm_colors['red']],
          \ 'green': [ g:base16_hex_colors['green'], g:base16_hex_colors['green'], g:base16_cterm_colors['green'], g:base16_cterm_colors['green']],
          \ 'blue': [ g:base16_hex_colors['blue'], g:base16_hex_colors['blue'], g:base16_cterm_colors['blue'], g:base16_cterm_colors['blue']],
          \ 'yellow': [ g:base16_hex_colors['yellow'], g:base16_hex_colors['yellow'], g:base16_cterm_colors['yellow'], g:base16_cterm_colors['yellow']],
          \ 'orange': [ g:base16_hex_colors['orange'], g:base16_hex_colors['orange'], g:base16_cterm_colors['orange'], g:base16_cterm_colors['orange']],
          \ 'purple': [ g:base16_hex_colors['purple'], g:base16_hex_colors['purple'], g:base16_cterm_colors['purple'], g:base16_cterm_colors['purple']]}

  call airline#switch_theme(s:palette)
  unlet s:palette
endif

