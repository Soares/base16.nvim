#!/usr/bin/env python3
import argparse, os
from string import Template

parser = argparse.ArgumentParser()
parser.add_argument('-s', '--schemedir', default='./schemes')
parser.add_argument('-t', '--templatedir', default='./templates')
args = parser.parse_args()

# Output configurations: (template_file, output_dir, output_suffix)
OUTPUTS = [
    ('nvim.template', './colors', '.vim'),
    ('kitty-dark.template', './kitty', '-dark.conf'),
    ('kitty-light.template', './kitty', '-light.conf'),
    ('fish-dark.template', './fish', '-dark.theme'),
    ('fish-light.template', './fish', '-light.theme'),
]

def parse_yaml(text):
    """Simple YAML parser for our specific format (flat or one-level nested)."""
    result, section = {}, None
    for line in text.splitlines():
        line = line.split('#')[0]  # strip inline comments
        if not line.strip(): continue
        indent = len(line) - len(line.lstrip())
        key, _, val = line.strip().partition(':')
        val = val.strip().strip('"\'')
        if indent == 0 and val:
            result[key] = val
            section = None
        elif indent == 0:  # section header like "dark:"
            section = result[key] = {}
        elif section is not None:
            section[key] = val
    return result

def load_scheme(path):
    data = parse_yaml(open(path).read())
    if 'dark' in data:  # 32-color format
        return data['scheme'], data['author'], data['dark'], data['light']
    # 16-color format: use same colors for light (template handles the swap)
    dark = {k: data[k] for k in data if k.startswith('base')}
    light = dark.copy()
    return data['scheme'], data['author'], dark, light

# Load all templates
templates = {}
for template_file, outdir, suffix in OUTPUTS:
    template_path = os.path.join(args.templatedir, template_file)
    if os.path.exists(template_path):
        templates[template_file] = Template(open(template_path).read())
        os.makedirs(outdir, exist_ok=True)

# Process each scheme
for f in os.listdir(args.schemedir):
    if not f.endswith(('.yml', '.yaml')): continue
    slug = os.path.splitext(f)[0]
    scheme, author, dark, light = load_scheme(os.path.join(args.schemedir, f))
    subs = {'scheme': scheme, 'author': author, 'slug': slug}
    subs.update({f'dark_{k}': v for k, v in dark.items()})
    subs.update({f'light_{k}': v for k, v in light.items()})

    for template_file, outdir, suffix in OUTPUTS:
        if template_file in templates:
            outfile = os.path.join(outdir, slug + suffix)
            print(f'Generating {outfile}')
            open(outfile, 'w').write(templates[template_file].substitute(subs))
