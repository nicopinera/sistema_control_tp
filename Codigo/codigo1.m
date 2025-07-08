# Comandos principales
close all;
clear all;
clc;

# Paquetes
pkg load control;
pkg load symbolic;

# Variable de Laplace
s=tf('s');

Ta = 25; # Temperatura ambiente
Tfinal = 300; # Temperatura del Horno en regimen estacionario
potencia_aplicada = 1000;  # [W]
Rt = (Tfinal-Ta)/potencia_aplicada

c = 1005; # Calor especifico del aire 1005 J/kg
V = 0.067; # Volumen del horno 0.067 m^3
ro = 1.225; # densidad del aire 1.2 kg/m^3
m = ro * V; # Masa de aire
C = m * c;

K = Rt;
tau = C * Rt;

G = K / (tau*s+1)
#step(G);
Ksensor = 0.01
Krele = 200

FTLA = G * Ksensor * Krele;
#step(FTLA,250)
FTLA

Gtotal = G * Krele;


FTLC = Gtotal / (1+Gtotal*Ksensor);
# step(FTLC,250);
FTLC

disp('Terminado');
