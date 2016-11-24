#!/usr/bin/env python3
from __future__ import print_function
import argparse
import os, sys
import subprocess

parser = argparse.ArgumentParser(description='Generate all color files for a given template.')
parser.add_argument('-t', '--template', help='the template (file or directory)', default='template.ejs')
parser.add_argument('-s', '--schemedir', help='where to find all the schemes', default='./schemes') 
parser.add_argument('-o', '--outdir', help='where to dump all the files', default='./colors')
parser.add_argument('-x', '--extension', help='what extension to put on the files', default='.vim')
parser.add_argument('-b', '--builder', help='the build program to run', default='base16-builder')
args = parser.parse_args()

def generate(name, scheme, brightness=None):
    filepath = os.path.join(os.path.expanduser(args.outdir), name)
    parts = [args.builder, '-s', scheme, '-t', args.template]
    if brightness is not None:
        parts += ['-b', brightness]
    print('Generating', filepath)
    with open(filepath, 'wb') as outfile:
        outfile.write(subprocess.check_output(parts))

for scheme in os.listdir(args.schemedir):
    scheme, _ = os.path.splitext(scheme)
    if os.path.isfile(args.template):
        name = '{}{}'.format(scheme, args.extension)
        generate(name, scheme)
    else:
        for brightness in ['light', 'dark']:
            name = '{}-{}.{}'.format(scheme, brightness, args.extension)
            generate(name, scheme, brightness)

