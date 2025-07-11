# Comandos principales
close all;clear all;clc;
pkg load control;

s = tf('s');
temperatura_setpoint_sim = 300;
# Par\u00e1metros

Ta = 25; # Temperatura ambiente
Tfinal = 300; # Temperatura del Horno en r\u00e9gimen estacionario esperada para 1000W
potencia_referencia = 1000; # Potencia aplicada para c\u00e1lculo de Rt

Rt = (Tfinal - Ta) / potencia_referencia; # Resistencia t\u00e9rmica

# C\u00e1lculo de la Capacidad T\u00e9rmica Total
c = 1005; # Calor espec\u00edfico del aire [J/kg\u00b0C]
V = 0.067; # Volumen del horno [m^3]
ro = 1.225; # Densidad del aire [kg/m^3]
m = ro * V; # Masa de aire [kg]
C = m * c; # Capacidad t\u00e9rmica [J/\u00b0C]

# Variables de la planta
K_planta = Rt; # Ganancia de la planta [\u00b0C/W]
tau_planta = C * Rt; # Constante de tiempo de la planta [s]

# Funci\u00f3n de Transferencia de la Planta
G_planta = K_planta / (tau_planta * s + 1);

# Funciones de Transferencia
Ksensor = 0.01; # FT del sensor [V/\u00b0C]
Krele = 1; # Krele = 1 [W/V]
Has = 1.5 / (0.0318 * s + 1); # FT del Acondicionador de Se\u00f1al
ControladorProporcional = 3.69;


# Calcular la FTLC
G = G_planta * Krele*ControladorProporcional;
H = Ksensor * Has;
disp('Funci\u00f3n de Transferencia a Lazo Cerrado (FTLC):');
FTLC = feedback(G, H)

P = max(pole(FTLC)); #Polo mas lento
tau_sistema = (1 / abs(P))
t_establecimiento = 4*tau_sistema
t_sim = 10 * tau_sistema;
t = 0:1:t_sim;

[T_horno_simulado, t_out] = step(FTLC * temperatura_setpoint_sim, t);

# Valor Final de la Temperatura
temperatura_final_simulada = T_horno_simulado(end);

fprintf('\nTemperatura Final Alcanzada en la Simulaci\u00f3n (Estado Estacionario) para setpoint de %.0f\u00b0C: %.2f \u00b0C\n', temperatura_setpoint_sim, temperatura_final_simulada);
fprintf('La temperatura esperada si la FTLC tuviera ganancia 1 ser\u00eda: %.2f \u00b0C\n', temperatura_setpoint_sim);

# Graficar la Respuesta Temporal
figure;
plot(t_out, T_horno_simulado, 'b', 'LineWidth', 1.5, 'DisplayName', 'Temperatura Medida');
grid on;hold on;

y_limits = ylim; # Esto captura los l\u00edmites actuales del eje Y del gr\u00e1fico

# L\u00ednea del setpoint
plot(t, temperatura_setpoint_sim * ones(size(t)), 'r--', 'LineWidth', 1, 'DisplayName', ['Setpoint (', num2str(temperatura_setpoint_sim), ' \u00b0C)']);

# L\u00ednea del valor final simulado
plot(t, temperatura_final_simulada * ones(size(t)), 'g:', 'LineWidth', 2, 'DisplayName', ['Temp. Final Simulada (', num2str(temperatura_final_simulada, '%.2f'), ' \u00b0C)']);

title(['Respuesta Temporal del Horno a Lazo Cerrado (Setpoint de ', num2str(temperatura_setpoint_sim), '\u00b0C)']);
xlabel('Tiempo [s]');
ylabel('Temperatura [\u00b0C]');
legend();

max_val_plot = max(max(T_horno_simulado), temperatura_setpoint_sim * 1.2);
min_val_plot = min(0, min(T_horno_simulado));
ylim([min_val_plot max_val_plot]);
hold off;
