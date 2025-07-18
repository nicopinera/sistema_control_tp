close all; %clear all; clc;
pkg load control;

s = tf('s');

## Calculo de La Resistencia Termica
Ta = 25; # Temperatura ambiente
Tfinal = 300; # Temperatura del Horno en regimen estacionario
potencia_aplicada = 1000; # [W]

## Resistencia termica
Rt = (Tfinal-Ta)/potencia_aplicada;

## Calculo del Calor total
c = 1005; # Calor especifico del aire 1005 J/kg
V = 0.067; # Volumen del horno 0.067 m^3
ro = 1.225; # densidad del aire 1.2 kg/m^3
m = ro * V; # Masa de aire
C = m * c;

# Calculo de las variables de la planta
K = Rt; # Ganancia
tau = C * Rt; # Constante de tiempo

G = K / (tau*s+1); # FT de la planta
Ksensor = 40e-6; # FT del sensor
Krele = 1; # FT del Actuador - Rele
Has = 417/(0.0318*s+1); # FT del Acondicionador de Se\u00f1al

# Calcular la FTLC
Gtotal = G * Krele;
Htotal = Ksensor * Has;
FTLC = feedback(Gtotal,Htotal)
%FTLC = minreal(G/(1+G*H))

# An\u00e1lisis de la Respuesta Temporal
temperatura_setpoint_sim = 300;

# Calcular el tiempo de simulaci\u00f3n basado en el polo m\u00e1s lento
# tau = 1/P -> Polo en 1/tau
P = max(pole(FTLC)); #Polo mas lento
tau_sistema = (1 / abs(P))
t_establecimiento = 4*tau_sistema
t_sim = 10 * tau_sistema;
t = 0:1:t_sim; # Vector de tiempo con un paso de 1 segundo

# Simular la Respuesta al Escal\u00f3n de la  FTLC
# Se simula con un setpoint de 300\u00b0C
[T_horno_simulado, t_out] = step(FTLC * temperatura_setpoint_sim, t);

# Obtener y Mostrar el Valor Final de la Temperatura
temperatura_final_simulada = T_horno_simulado(end);

# Graficar la Respuesta Temporal
figure;
plot(t_out, T_horno_simulado, 'b', 'LineWidth', 1.5, 'DisplayName', 'Temperatura Medida');
grid on;hold on;

y_limits = ylim;

# L\u00ednea del setpoint
plot(t, temperatura_setpoint_sim * ones(size(t)), 'r--', 'LineWidth', 1, 'DisplayName', ['Setpoint (', num2str(temperatura_setpoint_sim), ' \u00b0C)']);

# L\u00ednea del valor final simulado (para comparaci\u00f3n visual)
plot(t, temperatura_final_simulada * ones(size(t)), 'g:', 'LineWidth', 2, 'DisplayName', ['Temp. Final Simulada (', num2str(temperatura_final_simulada, '%.2f'), ' \u00b0C)']);

title(['Respuesta Temporal del Horno a Lazo Cerrado (Setpoint de ', num2str(temperatura_setpoint_sim), '\u00b0C)']);
xlabel('Tiempo [s]');
ylabel('Temperatura [\u00b0C]');
legend();

# Ajustar los l\u00edmites del eje Y din\u00e1micamente para ver todo el rango
max_val_plot = max(max(T_horno_simulado), temperatura_setpoint_sim * 1.2);
min_val_plot = min(0, min(T_horno_simulado));
ylim([min_val_plot max_val_plot]);
hold off;

disp('Simulaci\u00f3n terminada.');
