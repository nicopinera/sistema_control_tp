# TPI: Sistema de control de temperatura en un Horno Electrico

Trabajo Practico Integrador de Sistema de Control - FCEFyN
- Catedra de Sistema de control

**Grupo**
1. Sassi, Juan Ignacio
2. Piñera. Nicolas Agustin

---

## 1. Introduccion

En este trabajo se detalla el diseño y análisis de un sistema de control de temperatura para un horno eléctrico, un componente utilizado en diversas aplicaciones, desde la cocción doméstica hasta procesos industriales y de laboratorio. El objetivo principal de este trabajo es desarrollar un modelo simple de horno eléctrico para uso doméstico que controle de manera precisa la temperatura y se mantenga estable, además demostrar la capacidad de aplicar los conocimientos adquiridos en la materia de Sistemas de Control para resolver un problema de ingeniería real.

Para nuestro sistema las temperaturas máximas posibles de establecer varían según el tipo de horno y el uso. La mayoría de los hornos de cocina alcanzan entre 250 °C y 280 °C. Algunos modelos de gama alta pueden llegar a 300 °C. Para lograr una temperatura constante dentro del horno se utilizará un sensor de temperatura para realizar la medición y la retroalimentación al sistema. 

### 1.1 Objetivos
- Lograr modelar matematicamente el comportamiento del horno
- Simular el modelo matematico para verificar si el control que realiza es preciso
- Entender y simplificar el modelo para aplicar los conocimientos adquiridos

### 1.2 Modelo Comercial
Para este trabajo utilizaremos de referencia el siguiente modelo comercial para estudiar su comportamiento y características: **_Horno Whirlpool Empotrable Eléctrico 60 CM Inox (AKZM656IX)_** el cual posee las siguientes características:

- Dimensión: Ancho $595 [mm]$ x Profundidad $564 [mm]$ x Altura $595 [mm]$
- Potencia total: $2.4 [kW]$ - Se supondra una potencia de trabajo de $1[kW]$
- Tensión de entrada admitida: $198-242 [V]$
- Capacidad del Horno: $67 [Litros]$
- Temperatura mínima: $50 [ºC]$ – Temperatura máxima: $300 [ºC]$

## 2. Definicion del Problema 
Hablar de hornos es adentrarse en un mundo de cocción, donde la tecnología se ha hecho presente a través de diversos modelos que evolucionan con el paso del tiempo. Tener un horno eléctrico en casa es una alternativa a un horno de gas, quizá con una capacidad menor pero que funciona muy bien para cocinar los alimentos de una familia promedio.

Estos hornos emplean resistencias para convertir la energía eléctrica en calor. De esta manera, permiten que se lleve a cabo un proceso denominado efecto Joule. Consiste en producir calor mediante el choque de los electrones que generan la corriente eléctrica y los átomos. 

Cuando esto se produce, la temperatura se eleva. Mientras el horno esté conectado a la corriente, este proceso se seguirá produciendo. Los choques de los electrones y los átomos son constantes debido al movimiento desordenado de los primeros dentro del horno. La potencia de este tipo de hornos depende de la cantidad de [V] que sean capaces de absorber de la corriente eléctrica. En función de esto, el calor que emitan será mayor o menor.

Un horno eléctrico funciona generando calor a través de resistencias eléctricas que se calientan cuando se conectan a la corriente eléctrica. Este calor se distribuye dentro del horno, ya sea por convección natural o mediante un ventilador en los hornos de convección, para cocinar los alimentos. El efecto Joule, también conocido como calentamiento Joule, es el fenómeno físico que explica cómo la energía eléctrica se transforma en calor cuando una corriente eléctrica circula por un material resistivo.

En los hornos eléctricos, este efecto es la base de su funcionamiento, ya que las resistencias dentro del horno, al recibir la corriente eléctrica, se calientan debido a la resistencia que ofrecen al paso de los electrones, generando calor que se utiliza para cocinar los alimentos.

Cuando se enciende el horno, la corriente eléctrica fluye a través de estas resistencias. Los electrones que componen la corriente eléctrica chocan con los átomos del material de la resistencia, generando fricción. Esta fricción transforma la energía cinética de los electrones en energía térmica, elevando la temperatura de la resistencia y, por lo tanto, del interior del horno. El calor generado en las resistencias se distribuye por todo el interior del horno, calentando los alimentos que se encuentran dentro. 

El efecto Joule permite un calentamiento rápido y eficiente del horno, ya que la energía eléctrica se transforma directamente en calor. La potencia de calentamiento se puede controlar ajustando la corriente eléctrica que pasa por las resistencias, lo que permite regular la temperatura del horno.

**Principio de funcionamiento:**
1.	Generación de calor: El horno eléctrico utiliza resistencias (generalmente de alambre metálico) que, al ser atravesadas por la corriente eléctrica, se calientan debido al efecto Joule. 
2.	Distribución del calor: Convección natural: El aire caliente generado por las resistencias asciende, creando corrientes de aire caliente que distribuyen el calor por todo el horno. Convección forzada (en hornos de convección): Un ventilador impulsa el aire caliente generado por las resistencias, asegurando una distribución más uniforme y rápida del calor. 
3.	Control de temperatura: Un termostato regula la temperatura del horno, apagando las resistencias cuando se alcanza la temperatura deseada y volviéndolas a encender si la temperatura baja.

**Partes principales de un horno eléctrico:**
- Resistencias: Son los elementos calefactores que generan el calor, compuestas de materiales con una alta resistencia al paso de la corriente eléctrica.
- Termostato: Controla la temperatura del horno, regulando el encendido y apagado de las resistencias. 
- Ventilador (en hornos de convección): Circula el aire caliente para una cocción más uniforme. 
- Panel de control: Permite al usuario seleccionar la temperatura, el tipo de cocción y otras funciones. 

### Que se busca controlar

El desafío de este trabajo será diseñar un sistema de control que permita mantener la temperatura del horno en un valor deseado, compensando perturbaciones y variaciones en la carga térmica. Nuestra señal de salida será la temperatura del horno, la mediremos con el sensor **LM35** el cual es un sensor de temperatura lineal con salida equivalente a $10 [\frac{mV}{ºC}]$, además se utilizará un acondicionador de señal para que la salida del LM35 tenga un nivel adecuado para cualquier ADC y disminuir el ruido eléctrico generado por el horno.

### Accion de control

La acción de control se ejecuta mediante un **relé** que gobierna el encendido y apagado de la resistencia calefactora del horno. El sistema de control evalúa la diferencia entre la temperatura medida y la temperatura de referencia, y determina si la resistencia debe activarse.

### Variables
#### Variables de entrada
|Variable|Simbolo|Unidad|Descripcion|
|---|---|---|---|
|Potencia aplicada a la resistencia|$P_r$|$[W]$|Energia entregada al horno para generar calor|
|Tension de alimentacion|$V_{cc}$|$[V]$|Tension que activa la resistencia|
|Señal de referencia de temperatura|$T_{ref}$|$[ºC]$|Temperatura deseada en el horno|

#### Variables de salida
|Variable|Simbolo|Unidad|Descripcion|
|---|---|---|---|
|Temperatura interna del horno|$T(t)$|$[ºC]$|Variable controlada; salida del sistema|
|Señal del sensor (salida del LM35)|$V_{sensor}$|$[V]$|Señal analógica proporcional a la temperatura (10 mV/°C).|

#### Parametros del sistema
|Parametro|Simbolo|Unidad|Descripcion|
| ---| --- | --- | --- |
|Capacidad térmica del horno|$C$|$\frac{J}{°C}$|Energía necesaria para elevar 1 °C la temperatura del aire.|
|Resistencia térmica| $R_t$| $\frac{ºC}{W}$ | Oposición al flujo de calor hacia el ambiente.|
| Constante de tiempo| $\tau$ | $s$| $\tau = R_t . C$, indica cuán rápido responde el horno. |

### Perturbaciones posibles
- Cambios en la temperatura ambiente que modifican las perdidas térmicas
- Apertura de la puerta del horno que provoca caídas de temperatura
- Inserción de objetos fríos que modifican el equilibrio térmico
- Variaciones en la tensión de red, que afectan la potencia real de la resistencia
 

## 3. Analisis de la planta

Para nuestro trabajo la **planta** es el horno eléctrico, que se modela como un sistema térmico que transforma potencia eléctrica en temperatura. El horno es un sistema donde se acumula calor, se pierde calor al ambiente y no hay oscilaciones ni sobrepaso natural, sino un aumento lento y asintótico de la temperatura en su interior. Debido a este comportamiento se decide modelar el sistema como un sistema de **primer orden**, cuya respuesta al escalón es:

$$T(t) = T_{\infty}(1-e^{-\frac{t}{\tau}})$$

El calor se almacena principalmente en el aire y en las paredes internas. La potencia que ingresa a nuestro sistema, calienta ese volumen de aire.

Como se dijo anteriormente nuestra planta se representará con un sistema de **primer orden**, para eso hay de definir dos parámetros importantes
- $R_t [ºC/W]$: Representa la resistencia térmica
- $C$: Capacidad térmica Total

La **resistencia térmica** se calcula de la siguiente manera

$$R_t = \frac{T_{\infty}-T_a}{P}$$
Donde:
- $T_{\infty}$ : Temperatura en régimen estacionario
- $T_a$: Temperatura ambiente
- $P$: Potencia constante aplicada

En nuestro sistema la temperatura ambiente será de $25[ºC]$ y la temperatura del horno en régimen estacionario será de $300[º C]$, además la potencia aplicada será de $1000[W]$ entonces el valor de la resistencia térmica seria

$$R_t = \frac{T_{\infty}-T_a}{P} = \frac{300-25}{1000} = 275e^{-3}[\Omega]$$

La **capacidad térmica total** se la puede calcular de la siguiente manera

$$C = m.c$$

Siendo 
- $m$: la masa del material contenido
- $c$: calor especifico, en el caso del aire $c = 1005J/kg$

En función de los valores y dimensiones de nuestro horno tenemos que
- $V = 67 [litros] = 0.067[m^3]$ (Volumen)
- $\rho_{aire} = 1.2 \frac{kg}{m^3}$ (Densidad del aire)

$$m = \rho . V = 1.2 * 0.067 = 0.0804 [kg]$$

$$C = m . c = 0.0804 * 1005 = 82.48 \frac{J}{ºC}$$

### Ecuación Diferencial de la Planta

Partiendo de la ley básica de conservación de la energía térmica

$$C.\frac{dT(t)}{dt} = P(t)-\frac{T(t)-T_a}{R_t}$$

si se considera que la temperatura ambiente $T_a = 0$ nos queda

$$C.\frac{dT(t)}{dt} +\frac{T(t)}{R_t}= P(t)$$

Aplicando la transformada de Laplace con condición inicial nula

$$C.s.T(s) +\frac{T(s)}{R_t}= P(s)$$
$$T(s)(C.s +\frac{1}{R_t})= P(s)$$
$$G(s)=\frac{T(s)}{P(s)} = \frac{1}{(C.s +\frac{1}{R_t})} =\frac{R_t}{(C.R_t.s +1)} $$

Si la forma estándar de una función de transferencia para un sistema de primer orden es
$$G(s) = \frac{K}{\tau .s + 1}$$
Entonces
- $\tau = C . R_t$ constante de tiempo térmica
- $K = R_t$ ganancia estática

A continuación, se presenta la gráfica de la respuesta en frecuencia al escalón unitario de nuestra función de transferencia para los parámetros establecidos de nuestra planta.


![Respuesta temporal de la ](/img/FTplanta.png "Respuesta temporal")

### Función de transferencia del sensor LM35
La relación entre la temperatura que entra al sensor y el voltaje que sale del mismo es simple:

$$V_{salida}(t) = K_{LM35} * T_{entrada}(t)$$

Donde:
- $V_{salida}$: Voltaje que sale del sensor
- $K_{LM35}$: Factor de escala del sensor
- $T_{entrada}$: Temperatura medida por el sensor

En este caso el valor de $K_{LM35} = 0.01 [\frac{V}{ºC}]$, entonces la función de transferencia nos quedaría
$$H_{sensor}(s) = \frac{V_{salida}(s)}{T_{entrada}(s)} = K_{LM35} = 0.01  [\frac{V}{ºC}]$$


### Función de transferencia del Actuador (Relé)
En nuestro sistema, el actuador recibirá una señal de control de $0[V]-5[V]$ y nos entregará  $1000[W]$ de potencias necesarios para nuestro horno. El valor de $K_{Relé} = 200 [\frac{W}{V}]$

### Funcion de tranferencia del Acondicionador de señal
Se colocara un acondicionador de señal para mejorar el nivel ed voltaje a la salida del sensor de temperatura y disminuir el ruido electrico proporcionado por el Horno. Sera un **Amplificador no inversor con filtrado RC** ya que tiene alta impedancia de entrada asegurando que el amplificador no "extrae" cirruebte dek sensor, manteniendo la precision de su salida, tiene ganancia ajustable y precisa. 

Este acondicionador tiene los siguientes parametros:
- Ganancia
- RC y Tau

La ganancia se calcula con la siguiente expresion: 

$$G_v = \frac{\text{Amplitud de salida deseada}}{\text{Amplitud de entrada}} = 1 + \frac{R_{feedback}}{R_{gain}}$$ 

Debemos saber que el rango de valores entregados por el sensor es 0.5[V] a 3[V] ya que trabajaremos con temperaturas de 50[ºC] a 300[ºC], entonces tendremos una amplitud de señal equivalente a $3 - 0.5 = 2.5[V]$.

Se desea llevar este rango a uno mas apropiado por si se utiliza un ADC en el controlador para comparar, el cual sera de 0.75[V] a 4.5[V] lo que nos da una amplitud de señal de salida deseada equivalente a $4.5[V]-0.75[V] = 3.75[V]$

$$G_v = \frac{\text{Amplitud de salida deseada}}{\text{Amplitud de entrada}} = \frac{3.75[V]}{2.5[V]} = 1.5$$ 

En funcion de este valor se sabe que las resistencias deben tener la siguiente relacion

$$0.5 = \frac{R_{feedback}}{R_{gain}}$$

### Diagrama en Bloques
A continuación, se presenta un diagrama en bloques de nuestro sistema. (Agregar algo sobre la diferencia de unidades a la salida del sensor y la entrada del sistema)

![Diagrama en Bloques](/img/DiagramaBloques.png "Diagrama en Bloques")

Reemplazando las funciones de transferencias (FT) descriptas en la sección anterior, el diagrama en bloques nos quedaría de la siguiente manera

![FT](/img/FT.png "Diagrama en Bloques con FT")

### Función de Transferencia a Lazo Abierto

Aplicando algebra de bloques, se encuentra que la función de transferencia a lazo abierto es la siguiente: 

![FTLA](/img/FTLA.png "Función de Transferencia a lazo Abierto")

### Función de Transferencia a Lazo Cerrado

Aplicando algebra de bloques, se encuentra que la función de transferencia a lazo cerrado es la siguiente: 

![FTLC](/img/FTLC.png "Función de Transferencia a lazo Cerrado")


---

> Para controlar de forma adecuada la temperatura interna de un horno eléctrico, se realiza un control PID (proporcional, integral y derivado). Gracias a este mecanismo, es posible mantener el valor de la temperatura a un nivel constante, algo fundamental a la hora de cocinar determinados alimentos.

---

## 6. Conclusiones
