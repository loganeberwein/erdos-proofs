from back import chains
# for each residue r mod 64 (r = 3 mod 4), minimal L at which ALL lifts n = r + 64*k (k large, 400 samples) have no chain
import random
random.seed(3)
for r in range(3,64,4):
    dead=None
    for L in range(1,13):
        if all(chains(r+64*random.randrange(10**12,10**13),L)==0 for _ in range(400)): dead=L; break
    print(f"n = {r:2d} mod 64 (= {r%16:2d} mod 16): all chains dead by L = {dead}")
