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

El desafio de este trabajo sera diseñar un sistema de control que permita mantener la temperatura del horno en un valor deseado, compensando perturbaciones y variaciones en la carga termica. Nuestra señal de salida sera la temperatura del horno, la mediremos con el sensor **LM35** el cual es un sensor de temperatura lineal con salida equivalente a $10 [\frac{mV}{ºC}]$ (falta explicar el acondicionador de señal). 

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
- Cambios en la temperatura ambiente que modifican las perdidad termicas
- Apertura de la puerta del horno que provoca caidas de temperatura
- Insercion de objetos frios que modifican el equilibrio termico
- Variaciones en la tension de red, que afectan la potencia real de la resistencia 

## 3. Analisis de la planta

Para nuestro trabajo la **planta** es el horno electrico, que se modela como un sistema termico que tranforma potencia electria en temperatura. El horno es un sistema donde se acumula calor, se pierde calor al ambiente y no hay oscilaciones ni sobrepaso natural, sino un aumento lento y asintotico de la temperatura en su interior. Debido a este comportamiento se decide modelar el sistema como un sistema de **primer orden**, cuya respuesta al escalon es:

$$T(t) = T_{\infin}(1-e^{-\frac{t}{\tau}})$$

El calor se almacena principalmente en el aire y en las paredes internas. La potencia que ingresa a nuestro sistema, calienta ese volumen de aire.

A continuacion se presenta un diagrama en bloques de nuestro sistema. (Agregar algo sobre la diferencia de unidades a la salida del sensor y la entrada del sistema)

![Diagrama en Bloques](/img/diagrama1.png "Diagrama en Bloques")

En este caso, se grafica un bloque controlador que luego se determinará si es requerido o node acuerdo a las especificaciones.

Como se dijo anteriormente nuestra planta se representara con un sistema de **primer orden**, para eso hay de definir dos parametros importantes
- $R_t [ºC/W]$: Representa la resistencia termica
- $C$: Capacidad termica Total

La **resistencia termica** se calcula de la siguiente manera

$$R_t = \frac{T_{\infin}-T_a}{P}$$
Donde:
- $T_{\infin}$ temperatura en regimen estacionario
- $T_a$: temperatura ambiente
- $P$: potencia constante aplicada

En nuestro sistema la temperatura ambiente sera de $25[ºC]$ y la temperatura del horno en regimen estacionario sera de $300[ºC]$, ademas la potencia aplicada sera de $1000[W]$ entonces el valor de la resistencia termica seria

$$R_t = \frac{T_{\infin}-T_a}{P} = \frac{300-25}{2400} = 275e-3[\Omega]$$

La **capacidad termica total** se la puede calcular de la siguiente manera

$$C = m.c$$

Siendo 
- $m$: la masa del material contenido
- $c$: calor especifico, en el caso del aire $c = 1005J/kg$

En funcion de los valores y dimensiones de nuestro horno tenemos que
- $V = 67 [litros] = 0.067[m^3]$ (Volumen)
- $\rho = 1.2 \frac{kg}{m^3}$ (Densidad del aire)

$$m = \rho . V = 1.2 * 0.067 = 0.0804 [Kg]$$

$$C = m . c = 0.0804 * 1005 = 82.48 \frac{J}{ºC}$$

### Ecuacion Diferencial de la Planta

Partiendo de la ley basica de conservacion de la energia termica

$$C.\frac{dT(t)}{dt} = P(t)-\frac{T(t)-T_a}{R_t}$$

si se considera que la temperatura ambiente $T_a = 0$ nos queda

$$C.\frac{dT(t)}{dt} +\frac{T(t)}{R_t}= P(t)$$

Aplicando la tranformada de Laplace con condicion inicial nula

$$C.s.T(s) +\frac{T(s)}{R_t}= P(s)$$
$$T(s)(C.s +\frac{1}{R_t})= P(s)$$
$$\frac{T(s)}{P(s)} = \frac{1}{(C.s +\frac{1}{R_t})} =\frac{R_t}{(C.R_t.s +1)} $$

Si la forma estandar de una funcion de tranferencia para un sistema de primer orden es
$$G(s) = \frac{K}{\tau .s + 1}$$
Entonces
- $\tau = C . R_t$ constante de tiempo termica
- $K = R_t$ ganancia estatica

A continuacion se presenta la grafica de nuestra funcion de transferencia para los parametros establecidos

![Respuesta temporal de la ](/img/Figure_1.png "Respuesta temporal")


### Funcion de transferencia del sensor LM35

La relacion entre la temperatura que entra al sensor y el voltaje que sale del mismo es simple:

$$V_{salida}(t) = K_{LM35} * T_{entrada}(t)$$

Donde:
- $V_{salida}$: Voltaje que sale del sensor
- $K_{LM35}$: Factor de escala del sensor
- $T_{entrada}$: Temperatura medida por el sensor

En este caso el valor de $K_{LM35} = 0.01 \frac{V}{ºC}$, entonces la funcion de tranferencia nos quedaria

$$G(s) = \frac{V_{salida}(s)}{T_{entrada}(s)} = K_{LM35} = 0.01  \frac{V}{ºC}$$

### Funcion de transferencia del Actuador (Rele)
En nuestro sistema, el actuador recivira una señal de control de $0[V]-5[V]$ y nos entregara $1000[W]$ de potencias necesarios para nuestro horno. El valor de $K_{Rele} = 200 [\frac{W}{V}]$

### Diagrama en Bloques


---

> Para controlar de forma adecuada la temperatura interna de un horno eléctrico, se realiza un control PID (proporcional, integral y derivado). Gracias a este mecanismo, es posible mantener el valor de la temperatura a un nivel constante, algo fundamental a la hora de cocinar determinados alimentos.

---

## 6. Conclusiones
