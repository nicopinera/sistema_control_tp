# Sistema de Control de Temperatura Aplicado a un Horno Eléctrico Doméstico

![Diagrama de Bloques General del Sistema de Control](/img/Diagramas%20de%20Bloques/DiagramaBloques.png)

## 📌 Resumen del Proyecto

Este repositorio documenta el desarrollo de un **Sistema de Control de Temperatura** para un horno eléctrico doméstico, realizado como Trabajo Práctico Integrador para la Cátedra de Sistemas de Control. El proyecto abarcó desde el **modelado matemático** de sus componentes clave hasta el **diseño, simulación y análisis** de un controlador para garantizar un control de temperatura preciso y estable.

El estudio inicial reveló que el horno en lazo abierto presentaba un **elevado error en estado estacionario** que impedía alcanzar las temperaturas deseadas. Para resolver esto, se diseñó e implementó un controlador. Tras un proceso de sintonización y evaluación exhaustiva, se optó por un controlador **Proporcional (P)** con una ganancia $K_p = 3.69$. Esta solución, a pesar de su simplicidad, demostró ser altamente efectiva, logrando un error en estado estacionario mínimo (0.15 °C para un setpoint de 300 °C) y una respuesta sin sobrepaso, cumpliendo las especificaciones clave de diseño.

## 🌟 Motivación y Objetivos

El control de temperatura es una aplicación fundamental de los sistemas de control en la vida cotidiana y la industria. Este proyecto surge de la necesidad de comprender y aplicar los principios teóricos de los sistemas de control a un sistema físico real y familiar como un horno eléctrico.

Los objetivos principales de este trabajo fueron:

1.  **Modelar matemáticamente** el comportamiento térmico del horno eléctrico y de sus componentes asociados (sensor, actuador, acondicionador de señal).
2.  **Simular** el modelo desarrollado para predecir su respuesta dinámica.
3.  **Diseñar e implementar** una estrategia de control para lograr un control preciso y estable de la temperatura.
4.  **Verificar y analizar** el desempeño del sistema a lazo cerrado, comparando los resultados simulados con las especificaciones de diseño.
5.  **Aplicar y consolidar** los conocimientos teóricos adquiridos en la asignatura de Sistemas de Control.

## 🛠️ Componentes del Sistema y Modelado

Para la implementación del lazo de control, se identificaron y modelaron matemáticamente las siguientes partes principales del sistema:

* **1. Planta (Horno Eléctrico):**
    * Representa la cámara interna del horno y su interacción con la fuente de calor.
    * Modelada como un **sistema de primer orden**, caracterizado por su **ganancia $K_{planta} = 0.275 \text{ °C/W}$** y su **constante de tiempo $\tau_{planta} = 22.68 \text{ s}$**. Este modelo representa adecuadamente la dinámica térmica asintótica del horno sin oscilaciones naturales.
      
![Visualización de la respuesta a un escalón de la planta](/img/Respuesta%20Temporales/FTplanta.png)

* **2. Sensor de Temperatura (LM35):**
    * Mide la temperatura interna del horno.
    * Modelado como una **ganancia pura** de $K_{sensor} = 0.01 \text{ V/°C}$.

* **3. Actuador (Relé):**
    * Controla la potencia suministrada a las resistencias del horno.
    * Modelado como una **ganancia unitaria** $K_{rele} = 1$, asumiendo una respuesta instantánea y lineal.

* **4. Acondicionador de Señal:**
    * Procesa la señal del sensor antes de que llegue al controlador.
    * Modelado como un **sistema de primer orden** con una **ganancia de $1.5$** y una **constante de tiempo de $0.0318 \text{ s}$**, representando el retardo y la amplificación de la señal.

El **diagrama de bloques completo** del sistema con las funciones de transferencia de cada componente es el siguiente:
![Diagrama de Bloques con Funciones de Transferencia](/img/Diagramas%20de%20Bloques/FT.png)

## ⚙️ Diseño e Implementación del Controlador

El objetivo del controlador fue reducir el error en estado estacionario y asegurar una respuesta estable y sin sobrepaso, bajo las siguientes especificaciones de diseño:

* **Error en Estado Estable:** $e_{ss} \le 1.5 \text{ °C}$ (0.5% del setpoint de 300 °C).

Inicialmente, se consideró un controlador PID por su capacidad de eliminar errores y mejorar la respuesta transitoria. Sin embargo, tras varias simulaciones y un proceso de sintonización iterativo, se concluyó que un **controlador Proporcional (P) puro** era suficiente y óptimo para cumplir con las especificaciones y la simplicidad requerida en una aplicación doméstica.

La función de transferencia del controlador es simplemente $C(s) = K_p$. La **ganancia proporcional sintonizada** fue de **$K_p = 3.69$**.

## 📊 Resultados del Desempeño a Lazo Cerrado

La simulación del sistema a lazo cerrado con el controlador Proporcional (`Kp = 3.69`) demostró un cumplimiento exitoso de las especificaciones de diseño:

* **Temperatura Final Alcanzada (para un setpoint de 300 °C):** 299.85 °C.
* **Error en Estado Estable:** Se calculó a partir de la **Ganancia DC de la Función de Transferencia a Lazo Cerrado (FTLC)**. Para un setpoint de 300 °C, el error fue de **0.15 °C** (o 0.0005 °C para una entrada de escalón unitario). Este valor **supera holgadamente la especificación de error** ($\le 1.5 \text{ °C}$).
* **Sobrepaso:** La respuesta obtenida fue **asintótica y sin sobrepaso**, lo que cumple la especificación de $M_p = 0\%$.
* **Tiempo de Establecimiento:** El sistema se estabilizó en aproximadamente 89.372 segundos.

La **respuesta temporal del horno a lazo cerrado** con el controlador P se muestra a continuación:

![Respuesta Temporal del Horno a Lazo Cerrado con Controlador P](/img/Respuesta%20Temporales/FTLCconControlador.png)

El comportamiento del error para una entrada de escalón unitario, ilustrando su rápida reducción y estabilización en un valor mínimo:

![Respuesta del Sistema y Comportamiento del Error para Escalon Unitario](/img/EssConControlador.png)

## 💡 Conclusión General

Este proyecto ha demostrado la aplicación exitosa de principios fundamentales de sistemas de control para diseñar un controlador eficaz para un horno eléctrico. La metodología incluyó el modelado detallado de cada componente, el análisis de las funciones de transferencia en lazo abierto y cerrado, y la sintonización de un controlador.

La elección de un controlador Proporcional simple, con $K_p = 3.69$, representó un **compromiso de ingeniería óptimo**. Se logró una **alta precisión en estado estable** (error muy bajo) y la **estabilidad deseada sin sobrepaso**, todo ello con un controlador de baja complejidad. Este trabajo valida la capacidad de traducir un problema físico real en un sistema controlable, analizable y simulable, utilizando las herramientas y conceptos de la teoría de control.

## 💻 Tecnología y Herramientas

* **Octave/MATLAB:** Entorno de programación para el análisis numérico, la simulación de sistemas de control y el cálculo de funciones de transferencia. Se utiliza la `control package` de Octave.
* **Python:** Para análisis de datos, procesamiento de señales y visualización, con librerías como `NumPy`, `SciPy`, `Matplotlib` y `python-control`.
* **draw.io (Diagrams.net):** Herramienta para la creación de diagramas de bloques y esquemas.


## 🤝 Contribuciones

Este proyecto fue desarrollado por:

* **Sassi, Juan Ignacio**
* **Piñera, Nicolás Agustín**

**Profesores de la Cátedra:**

* Ing. Adrián Agüero
* Ing. Juan Pedroni

---
**Universidad Nacional de Córdoba**

**Facultad de Ciencias Exactas, Físicas y Naturales**

**Cátedra de Sistemas de Control**

