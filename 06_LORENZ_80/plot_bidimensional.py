import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

BASE = Path(__file__).resolve().parent
DATA = BASE / "data" / "solucao_100.csv"
OUTDIR = BASE / "src"
OUTDIR.mkdir(parents=True, exist_ok=True)

# Ler CSV
df = pd.read_csv(DATA)
y1, y2, y3 = df["y1"], df["y2"], df["y3"]


plt.figure(figsize=(12, 5))
plt.plot(y1, y3, linewidth=1.5)
plt.title("L80 Attractor (y3 vs y2)")
plt.xlabel("y3")
plt.ylabel("y2")
plt.grid(True)
plt.savefig(OUTDIR / "L80_y3_vs_y2.png")
plt.close()
