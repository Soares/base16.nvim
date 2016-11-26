# Base16 color schemes for nvim

Install with something like Plug:

    Plug 'Soares/base16.nvim'

The main features of these color schemes are:

1. They distinguish between "changing which red red is" and "changing which
   things show up as red". Each color scheme is based off of vim's default
   color scheme, but with the colors set to nicer base16 colors. Configuration
   options let you change which types of objects are which types of colors.
2. They set all the `g:terminal_color_*` variables, which makes the terminal
   emulator in neovim use a matching colorscheme.

Install this plugin in the usual way (with vim-plug or vundle or whatever). You
will need to either `set termguicolors=1` or use something like
[base16 shell](https://github.com/chriskempson/base16-shell) to set your
terminal colors to your preferred base16 color scheme. For airline support,
`let g:base16_airline=1`.

The current available color schemes are

    3024
    apathy
    ashes
    atelier-cave
    atelier-dune
    atelier-estuary
    atelier-forest
    atelier-heath
    atelier-lakeside
    atelier-plateau
    atelier-savanna
    atelier-seaside
    atelier-sulphurpool
    bespin
    brewer
    bright
    chalk
    codeschool
    colors
    darktooth
    default
    eighties
    embers
    flat
    gooey
    google
    grayscale
    greenscreen
    harmonic
    hopscotch
    irblack
    isotope
    macintosh
    marrakesh
    mocha
    monokai
    ocean
    oceanicnext
    oliveira
    paraiso
    phd
    pop
    railscasts
    redscreen
    royal
    seti
    shapeshifter
    solarized
    summerfruit
    tomorrow
    tube
    twilight
    unikitty
    yesterday-bright
    yesterday-night
    yesterday

To change what type of things show up as which color, you can configure with
commands such as

    let g:base16_color_modifiers = {'Comment': 'fg=green'}

which makes comments green (instead of vim's default blue). You can use the
special colors

    base similar3 similar2 similar1 contrast1 contrast2 contrast3 antibase

which range from black to white if `background` is `dark`, and from white to
black if `background` is `light`.

To use a transparent background (allowing you to take advantage of terminal
transparency and/or terminal background images), set

    let g:base16_transparent_background = 1

When you're ready, use a colorscheme of your choice:

    :set background=dark
    :colorscheme summerfruit

You're welcome to change colorschemes on the fly. For more info, see

    :help base16

It's also easy to make your own base16 color scheme, see the `schemes/`
directory for details. Basically, all you need to do is make a yaml file with
16 hex values in it. For reference, the order is:

    black dark3 dark2 dark1 light1 light2 light3 white
    red orange yellow green aqua blue purple brown

If you change the templates or add schemes, run `python buildall.py` to
generate all the pretty new color files. You'll need
[base16-builder](https://github.com/base16-builder/base16-builder) installed.
