import numpy as np
import matplotlib.pyplot as plt
import control as ctrl
import os
os.system('cls')
# Parámetros
Ta = 25  # Temperatura ambiente
Tfinal = 300  # Temperatura del horno en régimen estacionario
potencia_aplicada = 1000  # [W]
Rt = (Tfinal - Ta) / potencia_aplicada

c = 1005  # Calor específico del aire [J/kg]
V = 0.067  # Volumen del horno [m^3]
ro = 1.225  # Densidad del aire [kg/m^3]
m = ro * V  # Masa de aire
C = m * c

K = Rt
tau = C * Rt

# Función de transferencia del horno
s = ctrl.TransferFunction.s
G = K / (tau * s + 1)

Ksensor = 0.01
Krele = 200 #3.5

# FTLA
FTLA = G * Ksensor * Krele
print("FTLA:", FTLA)

# Gtotal
Gtotal = G * Krele

# FTLC
FTLC = Gtotal / (1 + Gtotal * Ksensor)
print("FTLC:", FTLC)

# Tiempo de simulación
t = np.linspace(0, 100)

# Escalón de temperatura deseada (275°C sobre Ta)
Tref = 300  # temperatura deseada
delta_T = Tref - Ta

# Respuesta al escalón de temperatura
t_out, y_out = ctrl.step_response(FTLC, T=t)
y_out = y_out + Ta  # convertir a temperatura absoluta

# Graficar
plt.plot(t_out, y_out, label="Temperatura del horno")
#plt.axhline(Tref, color='r', linestyle='--', label="Referencia (300°C)")
plt.xlabel('Tiempo [s]')
plt.ylabel('Temperatura [°C]')
plt.title('Respuesta del horno a una referencia de temperatura')
plt.grid(True)
plt.legend()
plt.show()

print("Terminado")
