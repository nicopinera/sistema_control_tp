close all; clear all; clc;
pkg load control;

s = tf('s');

## Par\u00e1metros del sistema
Ta = 25;            % Temperatura ambiente [\u00b0C]
Tfinal = 300;       % Temperatura deseada [\u00b0C]
potencia_referencia = 1000; % Potencia [W]

% C\u00e1lculo de par\u00e1metros de la planta
Rt = (Tfinal - Ta) / potencia_referencia;  % Resistencia t\u00e9rmica [\u00b0C/W]
c = 1005;           % Calor espec\u00edfico del aire [J/kg\u00b0C]
V = 0.067;          % Volumen del horno [m\u00b3]
ro = 1.225;         % Densidad del aire [kg/m\u00b3]
m = ro * V;         % Masa de aire [kg]
C = m * c;          % Capacidad t\u00e9rmica [J/\u00b0C]

% Funci\u00f3n de transferencia de la planta
G_planta = Rt / (C*Rt * s + 1);

% Par\u00e1metros del sistema de control
Ksensor = 40e-6;    % Ganancia del sensor
Krele = 1;          % Ganancia del rel\u00e9
Has = 417/(0.0318*s + 1); % Acondicionador de se\u00f1al

% Rangos para ajuste del PI (valores m\u00e1s conservadores)
Kp_values = linspace(1, 10, 10);   % 10 valores entre 0.5 y 10
Ti_values = linspace(0.5, 10, 10);     % 10 valores entre 1 y 20

t_sim = 1000;        % Tiempo de simulaci\u00f3n m\u00e1s largo [s]

% Variables para almacenar mejores resultados
best_ts = Inf;
best_Kp = 0;
best_Ti = 0;
valid_combinations = 0;

printf("Buscando combinaciones PI con 0%% de sobrepasamiento...\n");
printf("%8s %8s %12s %15s\n", "Kp", "Ti", "Ess", "Ts (s)");
printf("--------------------------------------------\n");

for Kp = Kp_values
    for Ti = Ti_values
        % Controlador PI
        C = Kp * (1 + 1/(Ti*s));

        % Sistema en lazo cerrado
        G = Krele * G_planta;
        H = Has * Ksensor;
        FTLC = feedback(C * G, H);

        % Verificar estabilidad
        poles = pole(FTLC);
        if any(real(poles) >= 0)
            continue; % Sistema inestable
        end

        % Simular respuesta al escal\u00f3n
        [y, t] = step(FTLC, t_sim);

        final_samples = round(0.1*length(y));
        y_final = mean(y(end-final_samples:end));

        % C\u00e1lculo del sobrepasamiento
        [y_max, idx_max] = max(y);
        Mp = 100*(y_max - y_final)/y_final;

        % Solo considerar respuestas con 0% de sobrepasamiento
        if Mp > 0.1  % Margen del 0.1% para errores num\u00e9ricos
            continue;
        end

        % Calcular tiempo de establecimiento (2%)
        y_target_low = 0.98 * y_final;
        y_target_high = 1.02 * y_final;
        settling_idx = find(y < y_target_low | y > y_target_high, 1, 'last');

        if isempty(settling_idx)
            ts = 0;
        else
            ts = t(settling_idx);
        end

        % Error en estado estacionario
        ess = 1/(1 + dcgain(C * G * H));

        % Mostrar solo combinaciones v\u00e1lidas
        printf("%8.2f %8.2f %12.4f %15.2f\n", Kp, Ti, ess, ts);
        valid_combinations++;

        % Actualizar mejores par\u00e1metros (menor tiempo de establecimiento)
        if ts < best_ts
            best_ts = ts;
            best_Kp = Kp;
            best_Ti = Ti;
        end
    end
end

% Mostrar el mejor resultado encontrado
if valid_combinations > 0
    printf("\nMEJOR COMBINACI\u00d3N ENCONTRADA (%d v\u00e1lidas):\n", valid_combinations);
    printf("--------------------------------------------\n");
    printf("Par\u00e1metros con 0%% de sobrepasamiento y menor Ts:\n");
    printf("Kp = %.2f\n", best_Kp);
    printf("Ti = %.2f\n", best_Ti);
    printf("Tiempo de establecimiento (2%%) = %.2f s\n", best_ts);

    % Graficar la mejor respuesta
    figure;
    C_best = best_Kp * (1 + 1/(best_Ti*s));
    FTLC_best = feedback(C_best * Krele * G_planta, Has * Ksensor);
    step(FTLC_best, t_sim);
    title(sprintf('Mejor respuesta - Kp=%.2f, Ti=%.2f (Ts=%.2f s)', best_Kp, best_Ti, best_ts));
    xlabel('Tiempo (s)');
    set(gca, 'yticklabel', []);
    ylabel('Temperatura (\u00b0C)');
    grid on;
else
    printf("\nNo se encontraron combinaciones con 0%% de sobrepasamiento.\n");
    printf("Pruebe ampliando los rangos de Kp y Ti.\n");
end
