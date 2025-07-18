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
Ksensor = 40e-6; # FT del sensor
Krele = 1; # Krele = 1 [W/V]
Has = 417/(0.0318*s+1); # FT del Acondicionador de Se\u00f1al
% Par\u00e1metros del PID
Kp = 8;     % Ganancia proporcional
Ti = 2.61;      % Tiempo integral

% Funci\u00f3n de Transferencia del PID
C = Kp * (1 + 1/(Ti * s));
G = Krele * G_planta;
H = Has * Ksensor;
FTLC = feedback(C * G, H)

t_simulacion = 1000;
step(FTLC,t_simulacion)
set(gca, 'yticklabel', []);

# Error en Estado Estable
FTLA = C * G * H;
Kdc = dcgain(FTLA);
ess = 1 / (1 + Kdc);
printf("Kdc = %.4f\n", Kdc);
printf("Error en estado estacionario: ess = %.4f\n", ess);

% Obtener respuesta al escal\u00f3n
[y, t] = step(FTLC, t_simulacion);

% Calcular sobrespaso m\u00e1ximo
y_final = y(end);               % Valor final en estado estacionario
[y_max, idx_max] = max(y);      % Valor m\u00e1ximo y su posici\u00f3n

% Calcular tiempo de establecimiento (2% de criterio)
y_lower = 0.98 * y_final;
y_upper = 1.02 * y_final;

% Encontrar el \u00faltimo punto fuera de la banda del 2%
idx_settling = find(y < y_lower | y > y_upper, 1, 'last');
if isempty(idx_settling)
    ts = 0;
else
    ts = t(idx_settling);
end
printf("Tiempo de establecimiento (2%%): ts = %.2f s\n", ts);

% Graficar con l\u00edneas de referencia
figure;
step(FTLC, t_simulacion);
hold on;
plot([0, t_simulacion], [y_final, y_final], 'r--');              % L\u00ednea de estado estacionario
plot([0, t_simulacion], [y_upper, y_upper], 'g--');              % L\u00edmite superior (2%)
plot([0, t_simulacion], [y_lower, y_lower], 'g--');              % L\u00edmite inferior (2%)
title('Respuesta al Escal\u00f3n del Sistema');
xlabel('Tiempo (s)');
ylabel('Temperatura (\u00b0C)');
set(gca, 'yticklabel', []);
legend('Respuesta', 'Estado estacionario', 'Banda del 2%');
grid on;
