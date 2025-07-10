close all; clear all;clc;
pkg load control;

s = tf('s');

Ta = 25; % Temperatura ambiente [\u00b0C]
Tfinal = 300; % Temperatura del Horno en r\u00e9gimen estacionario esperada para 1000W [\u00b0C]
potencia_referencia = 1000; % Potencia aplicada
Rt = (Tfinal - Ta) / potencia_referencia; % Resistencia t\u00e9rmica

c = 1005; % Calor espec\u00edfico del aire [J/kg\u00b0C]
V = 0.067; % Volumen del horno [m^3]
ro = 1.2; % Densidad del aire [kg/m^3]
m = ro * V; % Masa de aire
C = m * c; % Capacidad t\u00e9rmica

K_planta = Rt; % Ganancia de la planta [\u00b0C/W]
tau_planta = C * Rt; % Constante de tiempo de la planta [s]

G_planta = K_planta / (tau_planta * s + 1); % Funci\u00f3n de Transferencia de la Planta

Ksensor = 0.01; % FT del sensor [V/\u00b0C]
Krele = 1; % Ganancia del rel\u00e9
Has = 1.5 / (0.0318 * s + 1); % FT del Acondicionador de Se\u00f1al

% C\u00e1lculo de la FTLA y FTLC
G = G_planta * Krele; % Camino directo: Planta * Actuador
H = Ksensor * Has;   % Camino de retroalimentaci\u00f3n: Sensor * Acondicionador

FTLC = feedback(G, H);

% tau = 1/P -> Polo en 1/tau
P = max(pole(FTLC)); #Polo mas lento
t_sim = 15 * (1 / abs(P));
t = 0:0.1:t_sim; % Vector de tiempo con un paso de 0.1 segundos para una curva m\u00e1s suave

% Simular la Respuesta al Escal\u00f3n Unitario
[T_horno_simulado_unit, t_out_unit] = step(FTLC, t);

% Calcular el Error en Funci\u00f3n del Tiempo
% El error e(t) = r(t) - y(t)
% Donde r(t) es el setpoint y y(t) es la respuesta del sistema.
error_tiempo = 1 - T_horno_simulado_unit;

Y_ss_unit = dcgain(FTLC); % Salida en estado estable
e_ss_calculated = 1 - Y_ss_unit; % Error en estado estable calculado

fprintf('\nPara un escal\u00f3n unitario (1 \u00b0C):\n');
fprintf('Ganancia en Estado Estacionario de la FTLC (FTLC(0)): %.4f\n', dcgain(FTLC));
fprintf('Temperatura Final Alcanzada en la Simulaci\u00f3n: %.4f \u00b0C\n', T_horno_simulado_unit(end));
fprintf('Error en Estado Estable Calculado: %.4f \u00b0C\n', e_ss_calculated);

figure('Name', 'An\u00e1lisis de la Respuesta al Escal\u00f3n Unitario y Error');

% Subgr\u00e1fico 1: Entrada r(t) y Salida y(t)
subplot(2,1,1);
stairs(t_out_unit, 1 * ones(size(t_out_unit)), 'b', 'LineWidth', 1.5, 'DisplayName', 'r(t) (Setpoint)');
hold on;
plot(t_out_unit, T_horno_simulado_unit, 'g', 'LineWidth', 1.5, 'DisplayName', 'y(t) (Salida del Sistema)');
grid on;
title('Respuesta del Sistema: r(t) vs y(t)');
xlabel('Tiempo [s]');
ylabel('Amplitud [\u00b0C]');
legend('Location', 'northeast');
xlim([0 t_sim]);

subplot(2,1,2);
plot(t_out_unit, error_tiempo, 'b', 'LineWidth', 1.5, 'DisplayName', 'e(t) (Error)');
grid on;
title('Error en Funci\u00f3n del Tiempo: e(t)');
xlabel('Tiempo [s]');
ylabel('Error [\u00b0C]');
legend('Location', 'northeast');
xlim([0 t_sim]); %

hold off;

disp('Simulaci\u00f3n y gr\u00e1ficos terminados.');
