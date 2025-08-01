# Sistema original
using DifferentialEquations, Plots, Statistics, DSP

function f(du, u, p, t)
    lambda = 1.0
    epsilon = 0.01

    x, y1, y2, y3 = u

    du[1] = x - x^3 + (lambda/epsilon) * y2
    du[2] = (10 / epsilon^2) * (y2 - y1)
    du[3] = (1 / epsilon^2) * (28*y1 - y2 - y1*y3)  
    du[4] = (1 / epsilon^2) * (y1*y2 - (8/3)*y3)
end

u0 = [0.1, 0.01, 0.01, 0.01]
tspan = (0.0, 100.0)
prob = ODEProblem(f, u0, tspan)
solucao_deterministico = solve(prob, Rodas5())

plot(solucao_deterministico.t, solucao_deterministico[1, :];
     label = "x(t)",
     xlabel = "Tempo",
     ylabel = "x",
     title = "Modelo acoplado determinado",
     size = (960, 540),
     color = :red,
     linewidth = 1.5)


y2 = solucao_deterministico[3, :]
y2 = y2 .- mean(y2)                    

# Autocorrelação normalizada (com ρ(0) = 1)
acor = xcorr(y2; scaling = :coeff)

# Lags positivos: o centro da autocorrelação está na posição `n`
n = 200
lag0 = n
acor_pos = acor[lag0:end]

# Variância e passo temporal
var_y2 = var(y2)
dt = solucao_deterministico.t[2] - solucao_deterministico.t[1]

# Parâmetro do sistema
lambda = 1.0  

# Estimativa de sigma² (com integral da função de autocorrelação)
sigma2 = 2 * lambda^2 * var_y2 * dt * sum(acor_pos)
sigma = sqrt(sigma2)

# Exibe os resultados
println("Estimativa de sigma² ≈ ", sigma2)
println("Estimativa de sigma  ≈ ", sigma)
