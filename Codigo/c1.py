import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import TransferFunction, step

Ta = 25 # Temperatura ambiente
Tfinal = 300 # Temperatura del Horno en regimen estacionario
potencia_aplicada = 2.4  # [kW]
Rt = (Tfinal-Ta)/potencia_aplicada

c = 1005 # Calor especifico del aire 1005 J/kg
V = 0.0067 # Volumen del horno 0.0067 m^3
ro = 1.2 # densidad del aire 1.2 kg/m^3
m = ro * V # Masa de aire
C = m * c

# Parámetros del horno
tau = C*Rt  # Constante de tiempo [s]
K = 1/Rt       # Ganancia (1 / Rt)


# Función de transferencia: G(s) = K / (tau*s + 1)
num = [K * potencia_aplicada]
den = [tau, 1]
sistema = TransferFunction(num, den)

# Tiempo de simulación
t = np.linspace(0, 10000) # 10000 ms

# Respuesta al escalón
t_out, T_out = step(sistema, T=t)

# Gráfico
plt.figure(figsize=(8, 4))
plt.plot(t_out/1000, T_out, label="Temperatura (°C)", color="orange")
plt.axhline(potencia_aplicada * K, linestyle="--", color="gray", label="Valor final")
plt.title("Respuesta del horno a un escalón de 2.4 kW")
plt.xlabel("Tiempo [s]")
plt.ylabel("Temperatura [°C]")
plt.yticks([])  # Oculta los valores del eje Y
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
