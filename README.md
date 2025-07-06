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
•	Dimensión: Ancho $595 [mm]$ x Profundidad $564 [mm]$ x Altura $595 [mm]$
•	Potencia total: $2.4 [kW]$
•	Tensión de entrada admitida: $198-242 [V]$
•	Capacidad del Horno: $67 [Litros]$
•	Temperatura mínima: $50 [ºC]$ – Temperatura máxima: $250 [ºC]$
