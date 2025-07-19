# Sistema de Control de Temperatura Aplicado a un Horno Eléctrico Doméstico

![Diagrama de Bloques General del Sistema de Control](/img/Diagramas%20de%20Bloques/DiagramaBloques.png)

## 📌 Resumen del Proyecto

Este repositorio documenta el desarrollo de un **Sistema de Control de Temperatura** para un horno eléctrico doméstico, realizado como Trabajo Práctico Integrador para la Cátedra de Sistemas de Control. El proyecto abarcó desde el **modelado matemático** de sus componentes clave hasta el **diseño, simulación y análisis** de un controlador para garantizar un control de temperatura preciso y estable.

El estudio inicial reveló que el horno en lazo abierto presentaba un **elevado error en estado estacionario** que impedía alcanzar las temperaturas deseadas. Para cumplir con el requerimiento de un **tiempo de establecimiento más estricto** y **eliminar por completo el error en estado estacionario** bajo cualquier condición, se optó por un controlador **Proporcional-Integral (PI)**. 

Esta elección final representó un **compromiso de ingeniería válido y bien fundamentado**, permitiendo un **error excepcionalmente bajo (teóricamente cero en estado estacionario para entradas escalón)** gracias a la acción integral y la simplicidad operacional de dos parámetros de sintonía ($K_p$ y $T_i$), lo que facilita tanto la implementación como el mantenimiento del sistema. Los resultados obtenidos demuestran que el sistema de control diseñado es viable para su implementación en hornos eléctricos domésticos, garantizando una alta precisión y estabilidad sin sobrepaso, y cumpliendo las especificaciones clave de diseño.

## 🌟 Motivación y Objetivos

El control de temperatura es una aplicación fundamental de los sistemas de control en la vida cotidiana y la industria. Este proyecto surge de la necesidad de comprender y aplicar los principios teóricos de los sistemas de control a un sistema físico real, buscando una solución de control eficaz para un horno eléctrico. La metodología incluyó el modelado detallado de cada componente, el análisis de las funciones de transferencia en lazo abierto y cerrado, y la sintonización de un controlador.

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

