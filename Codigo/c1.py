import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import TransferFunction, step
import os
os.system('cls')

Ta = 25 # Temperatura ambiente
Tfinal = 300 # Temperatura del Horno en regimen estacionario
potencia_aplicada = 1000  # [W]
Rt = (Tfinal-Ta)/potencia_aplicada
print("Resistencia termica: ",Rt)

c = 1005 # Calor especifico del aire 1005 J/kg
V = 0.067 # Volumen del horno 0.067 m^3
ro = 1.225 # densidad del aire 1.2 kg/m^3
m = ro * V # Masa de aire
C = m * c
print(C)

# Parámetros del horno
K = Rt
tau = C * Rt

# Función de transferencia: G(s) = K / (tau*s + 1)
num = [K]
den = [tau, 1]
sistema = TransferFunction(num, den)

# Tiempo de simulación
t = np.linspace(0, 160) # 10000 ms

# Entrada: escalón de 2400 W (amplificador)
# entrada = np.ones_like(t) * potencia_aplicada

# Respuesta al escalón unitario (1 W)
t_out, T_out = step(sistema, T=t)
T_out = T_out * potencia_aplicada + Ta  # Amplifica y suma temperatura ambiente

# Gráfico
plt.figure(figsize=(8, 4))
plt.plot(t_out, T_out, label="Temperatura (°C)", color="orange")
plt.axhline(300, linestyle="--", color="gray", label="Valor final")
plt.title("Respuesta del horno a un escalón de 2.4 kW")
plt.xlabel("Tiempo [s]")
plt.ylabel("Temperatura [°C]")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
