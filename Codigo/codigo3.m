# Comandos principales
close all;clear all;clc;

# Analisis de la respuesta temporal

# Definici\u00f3n de la Funci\u00f3n de Transferencia a Lazo Cerrado (FTLC)
num_ftlc = [39.67 1249 55]; # Numerador de la FTLC
den_ftlc = [16.36 516 64.11 1.825]; # Denominador de la FTLC
FTLC = tf(num_ftlc, den_ftlc)

# Par\u00e1metros de la Simulaci\u00f3n
temperatura_setpoint = 300; # [\u00b0C] - Magnitud del escal\u00f3n de referencia
temperatura_ambiente = 25; # [\u00b0C] - Temperatura inicial del horno

# Calcular la ganancia en estado estacionario de la FTLC
ganancia_ss_ftlc = dcgain(FTLC); # dcgain(sys) calcula la ganancia DC (s=0)
disp('Ganancia en Estado Estacionario de la FTLC (FTLC(0)):');
disp(ganancia_ss_ftlc);

% Tiempo de simulacion
P = max(pole(FTLC))

% el polo m\u00e1s lento est\u00e1 en  lo que implica una constante de tiempo de ~357 segundos.
% Para ver el r\u00e9gimen estacionario, necesitamos al menos 3 a 5 veces esa constante de tiempo.
t_sim = 5 * (1 / abs(P)); % Usamos el polo m\u00e1s lento para estimar el tiempo de asentamiento

t = 0:1:t_sim; % Vector de tiempo con un paso de 1 segundo

% Simular la Respuesta al Escal\u00f3n del Lazo Cerrado ---
[T_horno_simulado, t_out] = step(FTLC * temperatura_setpoint, t);

% 4. Obtener el Valor Final de la Temperatura
% El \u00faltimo valor de T_horno_simulado ser\u00e1 el valor en estado estacionario (o muy cercano)
temperatura_final_simulada = T_horno_simulado(end);

fprintf('\nTemperatura Final Alcanzada en la Simulaci\u00f3n (Estado Estacionario): %.2f \u00b0C\n', temperatura_final_simulada);
fprintf('La temperatura esperada si la FTLC tuviera ganancia 1 ser\u00eda: %.2f \u00b0C\n', temperatura_setpoint);

%5. Graficar la Respuesta Temporal
figure;
plot(t_out, T_horno_simulado, 'b', 'LineWidth', 1.5, 'DisplayName', 'Temperatura Medida (Simulada)');
grid on;
hold on;

% L\u00ednea del setpoint
#plot(t, temperatura_setpoint * ones(size(t)), 'r--', 'LineWidth', 1, 'DisplayName', ['Setpoint (', num2str(temperatura_setpoint), ' \u00b0C)']);

% L\u00ednea del valor final simulado (para comparaci\u00f3n visual)
#plot(t, temperatura_final_simulada * ones(size(t)), 'g:', 'LineWidth', 1, 'DisplayName', ['Temperatura Final Simulada (', num2str(temperatura_final_simulada, '%.2f'), ' \u00b0C)']);


title('Respuesta Temporal del Horno a Lazo Cerrado (Setpoint de 300\u00b0C)');
xlabel('Tiempo [s]');
ylabel('Temperatura [\u00b0C]');
legend('Location', 'southeast'); % Muestra todas las leyendas

% Ajustar los l\u00edmites del eje Y din\u00e1micamente para ver todo el rango
% Esto es crucial para ver la "disparada" si ocurre
max_val_plot = max(max(T_horno_simulado), temperatura_setpoint * 1.2); % Asegura que se vea el sobrepaso o el valor final
min_val_plot = min(min(T_horno_simulado), temperatura_ambiente - 5); % Asegura que se vea desde abajo

ylim([min_val_plot max_val_plot]);

hold off;

% --- 6. Medici\u00f3n de Par\u00e1metros de Respuesta (Opcional, pero recomendado) ---
% info = stepinfo(FTLC); % Esto solo es \u00fatil si la respuesta es subamortiguada t\u00edpica
% disp('Informaci\u00f3n de la Respuesta al Escal\u00f3n (FTLC - Requiere un comportamiento de asentamiento):');
% disp(info);
disp('terminado');
