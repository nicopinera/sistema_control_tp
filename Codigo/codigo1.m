# Comandos principales
close all;clear all;clc;

# Paquetes
pkg load control;
pkg load symbolic;

# Variable de Laplace
s=tf('s');

# Variable Simbolica
syms x;

# ---------------------------
## Calculo de La Resistencia Termica
Ta = 25;                    # Temperatura ambiente
Tfinal = 300;               # Temperatura del Horno en regimen estacionario
potencia_aplicada = 1000;   # [W]

# Resistencia termica
Rt = (Tfinal-Ta)/potencia_aplicada;

# Calculo del Calor total
c = 1005;                   # Calor especifico del aire 1005 J/kg
V = 0.067;                  # Volumen del horno 0.067 m^3
ro = 1.225;                 # densidad del aire 1.2 kg/m^3
m = ro * V;                 # Masa de aire
C = m * c;

# Calculo de las variables de la planta
K = Rt;                     # Ganancia
tau = C * Rt;               # Constante de tiempo

G = K / (tau*s+1);          # FT de la planta
#step(G);                   # Grafico de la respuesta al escalon

Ksensor = 0.01              # FT del sensor
Krele = 200                 # FT del Actuador - Rele
Has = 1.5/(0.0318*s+1);     # FT del Acondicionador de Se\u00f1al

# Funcion de transferencia a lazo abierto
FTLA = G * Ksensor * Krele * Has;
#step(FTLA,250)             # Grafico de FTLA

# Funcion de transferencia a lazo cerrado
Gtotal = G * Krele;
Htotal = Ksensor * Has;
FTLC = Gtotal / (1+Gtotal*Htotal)
# step(FTLC);               # Grafico de la FTLA

# ---------------------------
# Estudio de la relatividad absoluta
# Polos y zeros de nuestra FT
P = pole(FTLA); #Puntos de origen
Z = zero(FTLA); # Puntos terminales
# disp(Z);
# disp(P);

centroide = (-31.447-0.044085)/2;
# disp(centroide);

# FTLA definida con la variable simbolica
y1 = 0.825 / (0.7213 * x^2 + 22.72 * x + 1);

#Derivada respecto de 'x' para calcular punto de separacion
dy1_dx = diff(y1, x);
# disp(dy1_dx);
soluciones_x = solve(dy1_dx == 0, x);
# disp(soluciones_x);

# Lugar de raices
rlocus(FTLA);
disp('Terminado');
