close all; clear all; clc;
pkg load control;

# Par\u00e1metros de la Planta (Horno)
K_planta = 0.275; # [\u00b0C/W]
tau_planta = 22.22; # [s] tau = C * Rt (Constante de tiempo)

# Definici\u00f3n de la Funci\u00f3n de Transferencia de la Planta
num_planta = [K_planta];
den_planta = [tau_planta 1];
G_planta = tf(num_planta, den_planta)

# Escal\u00f3n de Potencia de 1000 W
potencia_escalon = 1000; # Potencia aplicada en [W]
Ta = 25; # Temperatura ambiente [\u00b0C]

# Tiempo de simulaci\u00f3n
t_sim = 10 * tau_planta;
t = 0:0.1:t_sim; # Vector de tiempo
t_establecimiento = 4*tau_planta;
# Simular la respuesta al escal\u00f3n de potencia
# La funci\u00f3n 'step' en MATLAB asume un escal\u00f3n unitario.
# Para un escal\u00f3n de magnitud 'A', multiplicamos la salida por 'A'.
# Adem\u00e1s, sumamos la temperatura ambiente para obtener la temperatura absoluta.
[delta_T_out_escalon_unit, t_out] = step(G_planta, t);
T_out_absoluta = (delta_T_out_escalon_unit * potencia_escalon) + Ta;

# Graficar la respuesta
figure;
plot(t_out, T_out_absoluta, 'b', 'LineWidth', 1.5);
grid on;hold on;

# Valor final esperado en r\u00e9gimen estacionario
# Delta T en estado estacionario = K_planta * potencia_escalon
delta_T_ss = K_planta * potencia_escalon;
T_final_esperada = Ta + delta_T_ss; # Temperatura final absoluta

# Obtener los l\u00edmites actuales del eje Y para que la l\u00ednea abarque todo el gr\u00e1fico
y_limits = ylim;

# Dibuja la l\u00ednea vertical de puntos
plot([tau_planta tau_planta], y_limits, 'r:', 'LineWidth', 1);
plot([t_establecimiento t_establecimiento], y_limits, 'k:', 'LineWidth', 1);

plot(t, T_final_esperada * ones(size(t)), 'r--', 'LineWidth', 1, 'DisplayName', ['Temperatura Final Esperada (', num2str(T_final_esperada), ' \u00b0C)']);
title('Respuesta de la Temperatura del Horno a un Escal\u00f3n de Potencia (1000 W)');
xlabel('Tiempo [s]');
ylabel('Temperatura [\u00b0C]');
legend('Temperatura del Horno', 'Temperatura Final Esperada', 'Location', 'southeast');
ylim([Ta-5 T_final_esperada+5]); # Ajustar los l\u00edmites del eje Y para visualizaci\u00f3n
hold off;
