#!/usr/bin/env python3

import sys
if sys.version_info[0] != (3):
    sys.stdout.write("This software requires Python 3. This is Python {}.\n".format(sys.version_info[0]))
    sys.exit(1)

import random

try:
    input = str(sys.argv[1])
except IndexError:
    print("Please supply exactly one argument, such as 'websrv', 'pgsql' or 'dagger'.\n")
    sys.exit(1)

prefix = [
    'hyenas', 'frogs', 'spiders', 'ravens', 'snakes', 'serpents', 'drakes',
    'dragons', 'wyrms', 'hydras', 'vulnerable', 'rusted', 'fine', 'strong',
    'grand', 'valiant', 'glorious', 'blessed', 'saintly', 'awesome',
    'holy', 'godly', 'tin', 'brass', 'bronze', 'iron', 'steel', 'silver',
    'gold', 'platinum', 'mithril', 'meteoric', 'weird', 'strange',
    'clumsy', 'dull', 'sharp', 'fine', 'warriors', 'soldiers', 'lords',
    'knights', 'masters', 'champions', 'kings', 'dopplegangers', 'useless',
    'bent', 'weak', 'jagged', 'deadly', 'heavy', 'vicious', 'brutal',
    'massive', 'savage', 'ruthless', 'merciless', 'crystalline',
    'white', 'pearl', 'ivory', 'crystal', 'diamond', 'red', 'crimson',
    'garnet', 'ruby', 'blue', 'azure', 'lapis', 'cobalt', 'sapphire',
    'topaz', 'amber', 'jade', 'obsidian', 'emerald', 'angels', 'archangels',
    'plentiful', 'bountiful', 'flaming', 'lightning', 'jesters'
]

# 'of' is added outside of this data set, but goes before every word

suffix = [
    'frailty', 'weakness', 'strength', 'might', 'power', 'giants', 'titans',
    'dyslexia', 'magic', 'brilliance', 'sorcery', 'wizardry', 'paralysis',
    'atrophy', 'dexterity', 'skill', 'accuracy', 'precision', 'perfection',
    'illness', 'disease', 'vitality', 'zest', 'vim', 'vigor', 'life',
    'trouble', 'quality', 'maiming', 'slaying', 'gore', 'carnage', 'slaughter',
    'fragility', 'brittleness', 'sturdiness', 'craftsmanship', 'structure',
    'many', 'plenty', 'light', 'radiance', 'blood', 'vampires', 'piercing',
    'puncturing', 'bashing', 'flame', 'fire', 'burning', 'shock', 'lightning',
    'thunder', 'pain', 'tears', 'health', 'protection', 'absorption',
    'deflection', 'osmosis', 'readiness', 'swiftness', 'speed', 'haste',
    'balance', 'stability', 'harmony', 'blocking', 'corruption', 'thieves',
    'thorns', 'devastation', 'peril'
]

print(
    random.choice(prefix) + "-" + \
    input + "-" + \
    "of-" + \
    random.choice(suffix)
)
