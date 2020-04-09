# Simulador del Juego Azul implementado en Prolog

> Proyecto I de la asignatura de Programación Declarativa del curso 2019-2020 de la carrera de Ciencia de la Computación de la Universidad de La Habana.

## Autores

* Carlos Bermudez Porto - C412 - [c.bermudez@estudiantes.matcom.uh.cu](mailto://c.bermudez@estudiantes.matcom.uh.cu)
* Leynier Gutiérrez González - C412 - [l.gutierrez@estudiantes.matcom.uh.cu](mailto://l.gutierrez@estudiantes.matcom.uh.cu)

## Descripción del Juego

### Componentes Básicas del Juego

**Azulejos:** Son una serie de piezas en cinco colores diferentes. El objetivo de los jugadores será obtener estos azulejos para conseguir conformar el muro que le han asignado.

**Fábricas:** Losetas circulares en las que se colocarán los azulejos en grupos de cuatro al comienzo de cada ronda. La cantidad de fábricas depende de la cantidad de jugadores.

El concepto básico es que **un jugador, al tomar piezas, siempre deberá tomar todas las de un mismo color que se encuentren en una ubicación concreta**. Estas ubicaciones serán las fábricas anteriores o el centro de la mesa, donde se irán colocando las losetas de las fábricas que no sean tomadas por un jugador al capturar las de un color concreto.

**Tablero Personal:** Cada jugador contará con uno y en dicho tablero encontramos los siguientes elementos:

* En la banda superior se encuentra el track de puntuación, con casillas numeradas de 0 a 99.
* En la zona inferior izquierda encontramos el espacio de preparación. Son cinco filas con un número diferente de columnas cada una (la fila superior solo tiene una posición y cada nueva fila tendrá una columna más hasta llegar a la última fila con cinco columnas).
* A la derecha encontramos el muro, compuesto por una cuadrícula de cinco filas y cinco columnas. En cada casilla de cada fila encontraremos impreso un tipo de azulejo, de forma que en ninguna fila y en ninguna columna se repite un mismo tipo.
* Por último, en la fila inferior, encontramos una fila de casillas con un valor negativo que aumenta en una unidad cada dos casilla. En esta fila se irán colocando los azulejos que no se puedan/quieran colocar en alguna de las filas de la zona de preparación.

**Ficha de jugador inicial:** Determina que jugador será el primero en escoger en una ronda. Esta ficha, además, funcionará como un azulejo pero que siempre será colocado en la fila de penalización.

### Preparación de la Partida

1. Cada jugador recibe un tablero personal y un marcador de puntuación que colocará en la casilla de valor 0.
2. Se coloca, formando un círculo, un número de losetas de fábrica dependiente del número de jugadores:
    * 2 Jugadores: 5 Losetas de Fábrica.
    * 3 Jugadores: 7 Losetas de Fábrica.
    * 4 Jugadores: 9 Losetas de Fábrica.
3. Se introducen en la bolsa los 100 azulejos (20 de cada color) y se mezclan bien.
4. Se rellena cada loseta de fábrica con 4 piezas extraídas de la bolsa al azar.
5. Se escoge al jugador inicial del partido de forma aleatoria, en las siguientes rondas el jugador inicial, es quien escoja azulejos por priera vez del centro y no de las fábricas, y este obtendrá la ficha de jugador inicial que debe ponerse en el suelo del tablero, restando puntos.
