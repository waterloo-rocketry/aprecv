from operator import itemgetter
from math import pi, inf

# (((960-j372)ohm) || (390nH * j45MHz * 2pi) || 250ohm) + 1 / (39pF * j45MHz *2pi)

# design parameters
#src_z = 1100-150j
src_z = 50
load_z = 2000
freq = 21.4e6
w = freq * 2 * pi

# test parameter from datasheet
#src_z = 960-372j
#load_z = 50
#freq = 45e6

base = [1.0, 1.1, 1.2, 1.3, 1.5, 1.6, 1.8, 2.0, 2.2, 2.4, 2.7, 3.0, 3.3, 3.6, 3.9, 4.3, 4.7, 5.1, 5.6, 6.2, 6.8, 7.5, 8.2, 9.1]
Rs = [r * n for n in [100, 1000, 10000, 100000, inf] for r in base]
Cs = [c * n for n in [1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7] for c in base]
Ls = [l * n for n in [1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5] for l in base]
def parts_gen():
    for L in Ls:
        for C in Cs:
            yield L, C

def ll(z1, z2):
    return z1 * z2 / (z1 + z2)

def impedance(w, L, C):
    ZL =  1j * (w * L)
    ZC = -1j / (w * C)

    Z1 = src_z + ZC
    Z2 = ll(Z1, ZL)

    return Z2

rsts = []

for L, C in parts_gen():
    Z = impedance(w, L, C)
    err = abs(Z - load_z) / abs(load_z)
    if err < 0.1:
        rsts.append({
            'z': Z,
            'e': err,
            'L': L,
            'C': C,
        })

rsts.sort(key=itemgetter('e'))

for rst in rsts[:20]:
    print(rst)
