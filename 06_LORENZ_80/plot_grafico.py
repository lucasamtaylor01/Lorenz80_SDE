from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

# Caminhos base
BASE = Path(__file__).resolve().parent
DATADIR = BASE / "data"
OUTDIR = BASE / "src"
OUTDIR.mkdir(parents=True, exist_ok=True)

# Ler o CSV
df = pd.read_csv(DATADIR / "solucao_01a.csv")

# Extrair colunas
t = df["time"] / 8  
x1 = df["x1"]
y1 = df["y1"]
z1 = df["z1"]

# Plotar evolução temporal
plt.figure(figsize=(12, 8), dpi=300)
#plt.plot(t, x1, label="x₁", linewidth=2, color="green")
plt.plot(t, y1, label="y₁", linewidth=2, color="blue")
plt.plot(t, z1, label="z₁", linewidth=2, color="red")

plt.ylim(-0.4, 0.6)
plt.xlabel("t (dias)", fontsize=16)
plt.ylabel("Valores", fontsize=16)
plt.title("Evolução temporal de $x_1$, $y_1$ e $z_1$", fontsize=18)
plt.legend(fontsize=14)
plt.grid(True, linestyle="--", alpha=0.6)

# Caminho de saída
OUTPNG = OUTDIR / "x1y1z1_01d.png"
plt.savefig(OUTPNG, bbox_inches="tight")