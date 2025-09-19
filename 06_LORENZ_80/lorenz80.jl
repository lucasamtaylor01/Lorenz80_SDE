"""
AFAZERES
1. Conferir as equações 
2. Conferir eq modular de i
3. Definir propriamente as condições iniciais
"""

using DifferentialEquations, ModelingToolkit, CSV, DataFrames

@parameters t
@variables (x(t))[1:3] (y(t))[1:3] (z(t))[1:3]
D = Differential(t)

a = [1.0, 1.0, 3.0]
b = [
    0.5 * (a[1] - a[2] - a[3]),
    0.5 * (a[2] - a[3] - a[1]),
    0.5 * (a[3] - a[1] - a[2]),
]
c = sqrt(3/4)  
h = [-1.0, 0.0, 0.0]
f = [0.3, 0.0, 0.0]
g_0, kappa_0, nu_0 = 8.0, 1/48, 1/48

j(i) = (i % 3) + 1         
k(i) = ((i + 1) % 3) + 1    

eqs = [
    D(x[i]) ~ (
        a[i]*b[i]*x[j(i)]*x[k(i)]
        - c*(a[i] - a[k(i)]) * x[j(i)]*y[k(i)]
        + c*(a[i] - a[j(i)]) * y[j(i)]*x[k(i)]
        - 2c^2 * y[j(i)]*y[k(i)]
        - nu_0*a[i]^2*x[i]
        + a[i]*(y[i] - z[i])
    ) / a[i]  for i in 1:3
]

append!(eqs, [
    D(y[i]) ~ (
        - a[j(i)]*b[j(i)] * x[k(i)]*y[j(i)]
        - a[k(i)]*b[k(i)] * y[k(i)]*x[j(i)]
        + c*(a[j(i)] - a[k(i)]) * y[j(i)]*y[k(i)]
        - a[i]*x[i]
        - nu_0*a[i]^2*y[i]
    ) / a[i]  for i in 1:3
])

append!(eqs, [
    D(z[i]) ~ (
        - b[j(i)] * x[k(i)] * (z[j(i)] - h[j(i)])
        - b[k(i)] * (z[k(i)] - h[k(i)]) * x[j(i)]
        + c * y[j(i)] * (z[j(i)] - h[j(i)])
        - c * (z[k(i)] - h[k(i)]) * y[k(i)]
        + g_0 * a[i] * x[i]
        - kappa_0 * a[i] * z[i]
        + f[i]
    ) for i in 1:3
])

@mtkbuild sys = ODESystem(eqs, t)

x0 = [-0.01111, 0, 0.0]
y0 = [ 0.53331, 1e-5, 0.0]
z0 = [ 0.53354, 1e-5, 0.0]
u0 = vcat(x0, y0, z0)

dias = 400
tspan = (0.0, 8*dias)  

prob = ODEProblem(sys, u0, tspan)
sol = solve(prob, RK4(); dt=4.2e-3)

U = Array(sol)
df = DataFrame(
    time = sol.t,
    x1 = U[1,:], x2 = U[2,:], x3 = U[3,:],
    y1 = U[4,:], y2 = U[5,:], y3 = U[6,:],
    z1 = U[7,:], z2 = U[8,:], z3 = U[9,:]
)

cd(@__DIR__)
isdir("data") || mkdir("data")
CSV.write("data/solucao_01a.csv", df)
println("Arquivo criado com sucesso em data/solucao_01.csv")
