import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

BASE = Path(__file__).resolve().parent
DATA = BASE / "data" / "solucao_01a.csv"
OUTDIR = BASE / "src"
OUTDIR.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA)
t, y1, y2, y3 = df["time"]/8, df["y1"], df["y2"], df["y3"]


plt.figure(figsize=(12, 5))

plt.plot(y2, y3, linewidth=1.5)
plt.title("L80 Attractor (y3 vs y2)")
plt.xlabel("t")
plt.ylabel("y1")
plt.grid(True)
plt.savefig(OUTDIR / "L80_Y1_T_HARDLEY.png")
