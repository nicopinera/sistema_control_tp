% Comandos principales
close all; clear all; clc;

s = tf('s'); % Definir la variable de Laplace 's'

% Par\u00e1metros
Ta = 25; % Temperatura ambiente
Tfinal = 300; % Temperatura del Horno en r\u00e9gimen estacionario esperada para 1000W
potencia_referencia = 1000; % Potencia aplicada para c\u00e1lculo de Rt

Rt = (Tfinal - Ta) / potencia_referencia; % Resistencia t\u00e9rmica

% C\u00e1lculo de la Capacidad T\u00e9rmica Total
c = 1005; % Calor espec\u00edfico del aire [J/kg\u00b0C]
V = 0.067; % Volumen del horno [m^3]
ro = 1.2; % Densidad del aire [kg/m^3]
m = ro * V; % Masa de aire [kg]
C = m * c; % Capacidad t\u00e9rmica [J/\u00b0C]

% Variables de la planta
K_planta = Rt; % Ganancia de la planta [\u00b0C/W]
tau_planta = C * Rt; % Constante de tiempo de la planta [s]

% Funci\u00f3n de Transferencia de la Planta
G_planta = K_planta / (tau_planta * s + 1);

% Funciones de Transferencia de otros componentes
Ksensor = 0.01; % FT del sensor [V/\u00b0C]
Krele = 1; % \u00a1Solicitado por el usuario: Krele = 1 [W/V]!
Has = 1.5 / (0.0318 * s + 1); % FT del Acondicionador de Se\u00f1al

% Calcular la FTLC
G_forward = G_planta * Krele; % Desde la salida del controlador hasta la salida de la planta
H_feedback = Ksensor * Has;   % Desde la salida de la planta hasta la entrada del punto de suma (sin incluir el controlador que ir\u00eda al inicio)
FTLC = feedback(G_forward, H_feedback);

disp('Funci\u00f3n de Transferencia a Lazo Cerrado (FTLC) calculada con feedback y Krele = 1:');
FTLC

% An\u00e1lisis de la Respuesta Temporal
temperatura_setpoint_sim = 300; % [\u00b0C] - Magnitud del escal\u00f3n de referencia para la simulaci\u00f3n

% Calcular la ganancia en estado estacionario de FTLC
ganancia_ss_ftlc = dcgain(FTLC);
fprintf('\nGanancia en Estado Estacionario de la FTLC (FTLC(0)): %.4f\n', ganancia_ss_ftlc);

% Obtener los polos de la FTLC para determinar el tiempo de simulaci\u00f3n
polos_LC = pole(FTLC);
disp('Polos del Sistema a Lazo Cerrado (sin controlador):');
disp(polos_LC);

% Calcular el tiempo de simulaci\u00f3n basado en el polo m\u00e1s lento
P = max(pole(FTLC)); #Polo mas lento
t_sim = 10 * (1 / abs(P));
t = 0:1:t_sim; % Vector de tiempo con un paso de 1 segundo

% Simular la Respuesta al Escal\u00f3n de la  FTLC
% Se simula con un setpoint de 300\u00b0C
[T_horno_simulado, t_out] = step(FTLC * temperatura_setpoint_sim, t);

% Obtener y Mostrar el Valor Final de la Temperatura
temperatura_final_simulada = T_horno_simulado(end);

fprintf('\nTemperatura Final Alcanzada en la Simulaci\u00f3n (Estado Estacionario) para setpoint de %.0f\u00b0C: %.2f \u00b0C\n', temperatura_setpoint_sim, temperatura_final_simulada);
fprintf('La temperatura esperada si la FTLC tuviera ganancia 1 ser\u00eda: %.2f \u00b0C\n', temperatura_setpoint_sim);

% Graficar la Respuesta Temporal
figure;
plot(t_out, T_horno_simulado, 'b', 'LineWidth', 1.5, 'DisplayName', 'Temperatura Medida (Simulada)');
grid on;hold on;

% Obtener los l\u00edmites actuales del eje Y para que la l\u00ednea abarque todo el gr\u00e1fico
y_limits = ylim; % Esto captura los l\u00edmites actuales del eje Y del gr\u00e1fico

% Dibuja la l\u00ednea vertical de puntos
# plot([tau_planta tau_planta], y_limits);
# plot([t_establecimiento t_establecimiento], y_limits);

% L\u00ednea del setpoint
plot(t, temperatura_setpoint_sim * ones(size(t)), 'r--', 'LineWidth', 1, 'DisplayName', ['Setpoint (', num2str(temperatura_setpoint_sim), ' \u00b0C)']);

% L\u00ednea del valor final simulado (para comparaci\u00f3n visual)
plot(t, temperatura_final_simulada * ones(size(t)), 'g:', 'LineWidth', 2, 'DisplayName', ['Temp. Final Simulada (', num2str(temperatura_final_simulada, '%.2f'), ' \u00b0C)']);

title(['Respuesta Temporal del Horno a Lazo Cerrado (Setpoint de ', num2str(temperatura_setpoint_sim), '\u00b0C)']);
xlabel('Tiempo [s]');
ylabel('Temperatura [\u00b0C]');
legend('Location', 'best');

% Ajustar los l\u00edmites del eje Y din\u00e1micamente para ver todo el rango
max_val_plot = max(max(T_horno_simulado), temperatura_setpoint_sim * 1.2);
min_val_plot = min(0, min(T_horno_simulado));
ylim([min_val_plot max_val_plot]);

hold off;

disp('Simulaci\u00f3n terminada.');
