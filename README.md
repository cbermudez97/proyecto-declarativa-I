# Simulador del Juego Azul implementado en Prolog

[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg?label=license)](https://opensource.org/licenses/MIT) [![Last commit](https://img.shields.io/github/last-commit/stdevCbermudez/proyecto-declarativa-I.svg?style=flat)](https://github.com/stdevCbermudez/proyecto-declarativa-I/commits) [![GitHub commit activity](https://img.shields.io/github/commit-activity/m/stdevCbermudez/proyecto-declarativa-I)](https://github.com/stdevCbermudez/proyecto-declarativa-I/commits) [![Github Stars](https://img.shields.io/github/stars/stdevCbermudez/proyecto-declarativa-I?style=flat&logo=github)](https://github.com/stdevCbermudez/proyecto-declarativa-I) [![Github Forks](https://img.shields.io/github/forks/stdevCbermudez/proyecto-declarativa-I?style=flat&logo=github)](https://github.com/stdevCbermudez/proyecto-declarativa-I) [![Github Watchers](https://img.shields.io/github/watchers/stdevCbermudez/proyecto-declarativa-I?style=flat&logo=github)](https://github.com/stdevCbermudez/proyecto-declarativa-I) [![GitHub contributors](https://img.shields.io/github/contributors/stdevCbermudez/proyecto-declarativa-I)](https://github.com/stdevCbermudez/proyecto-declarativa-I/graphs/contributors)

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

**Ficha de jugador inicial:** Determina qué jugador será el primero en escoger en una ronda. Esta ficha, además, funcionará como un azulejo pero que siempre será colocado en la fila de penalización.

### Preparación de la Partida

1. Cada jugador recibe un tablero personal y un marcador de puntuación que colocará en la casilla de valor 0.
2. Se coloca, formando un círculo, un número de losetas de fábrica dependiente del número de jugadores:
    * 2 Jugadores: 5 Losetas de Fábrica.
    * 3 Jugadores: 7 Losetas de Fábrica.
    * 4 Jugadores: 9 Losetas de Fábrica.
3. Se introducen en la bolsa los 100 azulejos (20 de cada color) y se mezclan bien.
4. Se rellena cada loseta de fábrica con 4 piezas extraídas de la bolsa al azar.
5. Se escoge al jugador inicial del partido de forma aleatoria, en las siguientes rondas el jugador inicial, es quien escoja azulejos por primera vez del centro y no de las fábricas, y éste obtendrá la ficha de jugador inicial que debe ponerse en el suelo del tablero, restando puntos.

### Desarrollo de la Partida

Una partida de ***Azul*** consta de un número indeterminado de rondas hasta que se cumpla la condición de finalización.

#### Condiciones de Finalización

* Se acabaron todos los azulejos
* Un jugador al terminar la ronda completó una fila.

Cada ronda consta a su vez, de tres fases.

#### Fase I: Selección de Azulejos

Esta fase consta de una serie de turnos alternados entre los jugadores, comenzando por el jugador inicial y continuando en el sentido de las agujas del reloj hasta que finaliza la fase.

El turno de un jugador se desarrolla de la siguiente forma:

1. De forma obligatoria, el jugador debe tomar todos los azulejos de un mismo color de una de las ubicaciones posibles:
    * Si se toman de una fábrica, los azulejos de otros colores que no se cojan se desplazan al centro de la mesa.
    * Si se toman del centro de la mesa y es el primer jugador en tomar azulejos de esta zona, el jugador debe tomar, adicionalmente, la ficha de jugador inicial y colocarla en la primera casilla disponible de la fila de suelo. En la siguiente ronda será el jugador inicial en esta fase.
2. A continuación, el jugador debe colocar las losetas en alguna de las filas de su zona de preparación cumpliendo las siguientes normas:
    * Si la fila ya contiene algún azulejo, los nuevos azulejos a colocar deben ser del mismo color.
    * No se puede colocar azulejos de un tipo concreto en una fila de la zona de preparación si en la fila del muro correspondiente ya se encuentra un azulejo de ese tipo.
    * Si todos los azulejos no caben en la fila escogida, los sobrantes deben colocarse en la fila de suelo (empezando por la primera casilla libre situada más a la izquierda).
    * Es posible colocar directamente en la fila de suelo todos los azulejos escogidos en un turno de esta fase.

La fase finaliza tras el turno del jugador que ha tomado el último azulejo en juego, es decir, no quedan azulejos en ninguna fábrica ni en el centro de la mesa.

#### Fase II: Revestir el Muro

Esta fase es automática y se puede desarrollar en paralelo. Cada jugador transporta un azulejo de cada una de las filas completadas al muro, comenzando por la fila superior y continuando hacia abajo. Por cada azulejo colocado en el muro se anotan puntos en función de los azulejos directamente conectados en la fila y/o columna correspondiente:

* Si el azulejo no se coloca adyacente a ningún otro azulejo de forma ortogonal, se anotará 1 punto.
* Si el azulejo se coloca adyacente al menos un azulejo, se cuentan cuántos azulejos directamente conectados en línea recta en la fila y/o columna hay. Por cada azulejo en cada una de ambas rectas se anota un punto, incluyendo al azulejo recién colocado. Por ejemplo, si el azulejo colocado tiene 1 azulejo adyacente en la columna y 1 azulejo adyacente en la fila, el jugador anotó 4 puntos (2 azulejos en la fila y 2 azulejos en la columna).
* El resto de azulejos de cada fila completada se colocan en la tapa de la caja (visibles para todos los jugadores).
* Los azulejos que se encuentran en filas incompletas, permanecen en su posición para la siguiente ronda.
* Por último, los jugadores restan puntos según las losetas que se encuentran en su fila de suelo, retrasando su marcador tantos puntos como indique cada casilla ocupada.

La fase finaliza una vez todos los jugadores han anotado sus puntos.

#### Fase III: Mantenimiento

Si la partida no ha finalizado, se prepara la siguiente ronda, volviendo a sacar de la bolsa 4 azulejos por fábrica. Si la bolsa quedase vacía, en ese momento se re-introducirán todos los azulejos que se encuentran en la tapa de la caja a la bolsa y se continuaría reponiendo.

Puede darse el caso de que, aún reintroduciendo los azulejos de la caja no haya azulejos suficientes para reponer todas las fábricas. En este caso se repondrá hasta donde fuese posible.

### Fin de la Partida

La partida termina en la ronda en la que un jugador consigue completar una o más filas, o los azulejos se agotaron. A los puntos acumulados se suman los siguientes:

* 10 Puntos por cada color de azulejo que se haya completado (se tiene un azulejo de ese color en cada fila)
* 7 Puntos por cada columna completa
* 2 Puntos por cada fila completa.

El jugador con más puntos se proclama vencedor. En caso de empate, el jugador con más filas completadas será el ganador. Si la igualdad permanece, se comparte la victoria.

## Implementación

La implementación se ha dividido en tres componentes principales. La primera componente es la encargada de manejar los conceptos las losas, de la bolsa, las fábricas, el centro de la mesa y la tapa de la caja. La segunda componente es la encargada de manejar los conceptos de jugador, sus filas de preparación, su fila de piso y su muro. Por último, la tercera componente es la encargada de utilizando las dos anteriores simular el juego según la estrategia implementada.

### Primera Componente

De la primera componente forman parte los archivos `tiles.pl` y `utils.pl`.

El archivo `utils.pl` contiene predicados utiles para trabajar con listas principalmente y se utiliza en las restantes componentes también por lo que solo será mencionado en esta.

El archivo `tiles.pl` contiene predicados para la definición de los tipos de losas y la cantidad de cada tipo al empezar el juego. También tiene predicados para iniciar el estado de la bolsa, llenar las fábricas posibles con las losas que estén en la bolsa y colocar la losa especial (ficha de jugador inicial) en el centro de la mesa cuando sea necesario. Además de los predicados para escoger las losas de una de las fábricas o del centro de la mesa y de imprimir tanto el estado de cada fábrica como el del centro de la mesa.

### Segunda Componente

De la segunda componente forman parte los archivos `player.pl`, `wall.pl` y `utils.pl`.

El archivo `wall.pl` contiene predicados para la definición del muro (tipo de losa que debe ir en cada casilla del muro), para la inserción de losas en el muro, para obtener las losas del muro según varios criterios y para calcular los puntos al insertar una losa en el muro.

El archivo `player.pl` continue predicados para la inicialización de los estados de los jugadores, para cambiar el jugador que le toca jugar, para actualizar sus filas de preparación, para actualizar su fila de piso, para actualizar su muro, para calcular los puntos cuando se inserta una losa determina en una de las filas de preparación, para imprimir el estado de cada jugador, etc.

### Tercera Componente

De la tercera componente forman parte los archivos `game.pl` y `player_logic.pl`.

El archivo `player_logic.pl` contiene predicados para simular la estrategia (que será explicada luego) utilizada por los jugadores basada en una métrica calculada para cada posible jugada escogiendo la de mayor valor resultado de aplicarle la métrica para realizarse.

El archivo `game.pl` contiene predicados para simular las rondas del juego, la rotación de los jugadores y la condición de finalización del juego.

### Estrategia implementada

La estrategia implementada para escoger la jugada fue calcular los puntos que se obtenían con cada jugada posible, escogiendo la jugada con la cual se obtenía mayor cantidad de puntos. Si coincide que con más de una jugada se obtiene la máxima cantidad de puntos se escoge la jugada que implique la utilización de la fila de preparación con mayor tamaño.

## Manual del Simulador

### Requerimientos

Es necesario tener instalado `swi-prolog` para utilizar el simulador. Si se encuentra en un sistema operativo Linux puede instalarlo de los repositorios ejecutado `sudo apt-get install swi-prolog` en la consola.

### Correr simulación

Una vez cumplidos los requerimientos para correr una simulación debe ejecutar el comando `swipl game.pl` en la raíz del simulador. Luego dentro del entorno de `swi-prolog` debe introducir `startAzulGame(n).`, `n` representa la cantidad de jugadores con que se desea correr la simulación, siendo válido de `2` a `4` jugadores. El resultado de la simulación se mostrará en la consola mediante la descripción de cada jugada realizada y el estado resultante después de realizada esta, hasta la finalización del juego que se muestran los puntos obtenidos por cada jugador.

## Ejemplo de Simulación

```prolog
Empezando juego de Azul con 4 jugadores!
Empezando Nueva Ronda:
Turno del Jugador 1.
Estado de la Mesa:
Factoria #1 : [blanco,rojo,negro,rojo].
Factoria #2 : [amarillo,azul,negro,azul].
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #4 : [blanco,azul,blanco,blanco].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Factoria #9 : [negro,amarillo,amarillo,amarillo].
Centro [especial].
Jugador 1 juega 2 fichas de tipo rojo en la fila 2 desde la Factoría 1
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #2 : [amarillo,azul,negro,azul].
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #4 : [blanco,azul,blanco,blanco].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Factoria #9 : [negro,amarillo,amarillo,amarillo].
Centro [especial,blanco,negro].
Jugador 2 juega 2 fichas de tipo azul en la fila 2 desde la Factoría 2
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #4 : [blanco,azul,blanco,blanco].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Factoria #9 : [negro,amarillo,amarillo,amarillo].
Centro [especial,blanco,negro,amarillo,negro].
Jugador 3 juega 2 fichas de tipo negro en la fila 2 desde el centro
El jugador 3 tomo la ficha especial y sera el primero en la siguiente Ronda.
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #4 : [blanco,azul,blanco,blanco].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Factoria #9 : [negro,amarillo,amarillo,amarillo].
Centro [blanco,amarillo].
Jugador 4 juega 3 fichas de tipo blanco en la fila 3 desde la Factoría 4
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Factoria #9 : [negro,amarillo,amarillo,amarillo].
Centro [blanco,amarillo,azul].
Jugador 1 juega 1 fichas de tipo blanco en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Factoria #9 : [negro,amarillo,amarillo,amarillo].
Centro [amarillo,azul].
Jugador 2 juega 3 fichas de tipo amarillo en la fila 3 desde la Factoría 9
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [amarillo,azul,negro].
Jugador 3 juega 1 fichas de tipo amarillo en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [azul,negro].
Jugador 4 juega 1 fichas de tipo azul en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [negro].
Jugador 1 juega 1 fichas de tipo negro en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #3 : [amarillo,rojo,blanco,azul].
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [].
Jugador 2 juega 1 fichas de tipo amarillo en la fila 1 desde la Factoría 3
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [rojo,blanco,azul].
Jugador 3 juega 1 fichas de tipo rojo en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [blanco,azul].
Jugador 4 juega 1 fichas de tipo blanco en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [azul].
Jugador 1 juega 1 fichas de tipo azul en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #5 : [rojo,amarillo,negro,amarillo].
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [].
Jugador 2 juega 1 fichas de tipo rojo en la fila 5 desde la Factoría 5
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Factoria #8 : [rojo,amarillo,negro,rojo].
Centro [amarillo,amarillo,negro].
Jugador 3 juega 2 fichas de tipo rojo en la fila 3 desde la Factoría 8
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Centro [amarillo,amarillo,negro,amarillo,negro].
Jugador 4 juega 3 fichas de tipo amarillo en la fila 4 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #6 : [negro,amarillo,rojo,azul].
Factoria #7 : [azul,amarillo,rojo,azul].
Centro [negro,negro].
Jugador 1 juega 2 fichas de tipo azul en la fila 3 desde la Factoría 7
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #6 : [negro,amarillo,rojo,azul].
Centro [negro,negro,amarillo,rojo].
Jugador 2 juega 1 fichas de tipo rojo en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #6 : [negro,amarillo,rojo,azul].
Centro [negro,negro,amarillo].
Jugador 3 juega 1 fichas de tipo amarillo en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #6 : [negro,amarillo,rojo,azul].
Centro [negro,negro].
Jugador 4 juega 2 fichas de tipo negro en la fila 2 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #6 : [negro,amarillo,rojo,azul].
Centro [].
Jugador 1 juega 1 fichas de tipo negro en la fila 5 desde la Factoría 6
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Centro [amarillo,rojo,azul].
Jugador 2 juega 1 fichas de tipo rojo en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Centro [amarillo,azul].
Jugador 3 juega 1 fichas de tipo amarillo en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Centro [azul].
Jugador 4 juega 1 fichas de tipo azul en la fila 1 desde el centro
Fin del Turno.
No se pueden realizar jugadas.
Fin de la Ronda.
Preparando Siguiente Ronda.
Fin de la Preparación.
Empezando Nueva Ronda:
Turno del Jugador 3.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #2 : [azul,negro,amarillo,amarillo].
Factoria #3 : [negro,azul,negro,blanco].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #6 : [rojo,rojo,blanco,blanco].
Factoria #7 : [azul,rojo,blanco,azul].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [especial].
Jugador 3 juega 1 fichas de tipo blanco en la fila 1 desde la Factoría 3
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #2 : [azul,negro,amarillo,amarillo].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #6 : [rojo,rojo,blanco,blanco].
Factoria #7 : [azul,rojo,blanco,azul].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [especial,negro,negro,azul].
Jugador 4 juega 2 fichas de tipo rojo en la fila 2 desde la Factoría 6
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #2 : [azul,negro,amarillo,amarillo].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #7 : [azul,rojo,blanco,azul].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [especial,negro,negro,azul,blanco,blanco].
Jugador 1 juega 2 fichas de tipo negro en la fila 2 desde el centro
El jugador 1 tomo la ficha especial y sera el primero en la siguiente Ronda.
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #2 : [azul,negro,amarillo,amarillo].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #7 : [azul,rojo,blanco,azul].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [azul,blanco,blanco].
Jugador 2 juega 2 fichas de tipo blanco en la fila 2 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #2 : [azul,negro,amarillo,amarillo].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #7 : [azul,rojo,blanco,azul].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [azul].
Jugador 3 juega 2 fichas de tipo azul en la fila 2 desde la Factoría 7
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #2 : [azul,negro,amarillo,amarillo].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [azul,rojo,blanco].
Jugador 4 juega 1 fichas de tipo blanco en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #2 : [azul,negro,amarillo,amarillo].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [azul,rojo].
Jugador 1 juega 1 fichas de tipo negro en la fila 1 desde la Factoría 2
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [azul,rojo,azul,amarillo,amarillo].
Jugador 2 juega 1 fichas de tipo rojo en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #1 : [azul,rojo,azul,azul].
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [azul,azul,amarillo,amarillo].
Jugador 3 juega 3 fichas de tipo azul en la fila 3 desde la Factoría 1
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [azul,azul,amarillo,amarillo,rojo].
Jugador 4 juega 2 fichas de tipo azul en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #4 : [negro,negro,rojo,negro].
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [amarillo,amarillo,rojo].
Jugador 1 juega 3 fichas de tipo negro en la fila 5 desde la Factoría 4
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [amarillo,amarillo,rojo,rojo].
Jugador 2 juega 2 fichas de tipo rojo en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [amarillo,amarillo].
Jugador 3 juega 2 fichas de tipo amarillo en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #5 : [rojo,azul,negro,negro].
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [].
Jugador 4 juega 1 fichas de tipo azul en la fila 3 desde la Factoría 5
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [rojo,negro,negro].
Jugador 1 juega 1 fichas de tipo rojo en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [negro,negro].
Jugador 2 juega 2 fichas de tipo negro en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #8 : [rojo,negro,blanco,amarillo].
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [].
Jugador 3 juega 1 fichas de tipo amarillo en la fila 5 desde la Factoría 8
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [rojo,negro,blanco].
Jugador 4 juega 1 fichas de tipo rojo en la fila 2 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [negro,blanco].
Jugador 1 juega 1 fichas de tipo negro en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #9 : [negro,amarillo,amarillo,blanco].
Centro [blanco].
Jugador 2 juega 1 fichas de tipo negro en la fila 3 desde la Factoría 9
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Centro [blanco,amarillo,amarillo,blanco].
Jugador 3 juega 2 fichas de tipo amarillo en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Centro [blanco,blanco].
Jugador 4 juega 2 fichas de tipo blanco en la fila 1 desde el centro
Fin del Turno.
No se pueden realizar jugadas.
Fin de la Ronda.
Preparando Siguiente Ronda.
Fin de la Preparación.
Empezando Nueva Ronda:
Turno del Jugador 1.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #2 : [azul,rojo,blanco,negro].
Factoria #3 : [amarillo,amarillo,azul,rojo].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #6 : [blanco,amarillo,blanco,amarillo].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [especial].
Jugador 1 juega 2 fichas de tipo amarillo en la fila 2 desde la Factoría 3
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #2 : [azul,rojo,blanco,negro].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #6 : [blanco,amarillo,blanco,amarillo].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [especial,azul,rojo].
Jugador 2 juega 1 fichas de tipo azul en la fila 1 desde el centro
El jugador 2 tomo la ficha especial y sera el primero en la siguiente Ronda.
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #2 : [azul,rojo,blanco,negro].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #6 : [blanco,amarillo,blanco,amarillo].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [rojo].
Jugador 3 juega 2 fichas de tipo amarillo en la fila 2 desde la Factoría 6
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #2 : [azul,rojo,blanco,negro].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [rojo,blanco,blanco].
Jugador 4 juega 1 fichas de tipo negro en la fila 1 desde la Factoría 2
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [rojo,blanco,blanco,azul,rojo,blanco].
Jugador 1 juega 2 fichas de tipo rojo en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [blanco,blanco,blanco,azul].
Jugador 2 juega 3 fichas de tipo blanco en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [azul].
Jugador 3 juega 1 fichas de tipo azul en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #1 : [azul,azul,amarillo,rojo].
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [].
Jugador 4 juega 2 fichas de tipo azul en la fila 2 desde la Factoría 1
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [amarillo,rojo].
Jugador 1 juega 1 fichas de tipo rojo en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #5 : [blanco,azul,blanco,negro].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [amarillo].
Jugador 2 juega 1 fichas de tipo azul en la fila 1 desde la Factoría 5
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [amarillo,blanco,blanco,negro].
Jugador 3 juega 1 fichas de tipo amarillo en la fila 4 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [blanco,blanco,negro].
Jugador 4 juega 2 fichas de tipo blanco en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #4 : [blanco,rojo,blanco,rojo].
Factoria #7 : [blanco,negro,blanco,negro].
Centro [negro].
Jugador 1 juega 2 fichas de tipo blanco en la fila 5 desde la Factoría 4
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #7 : [blanco,negro,blanco,negro].
Centro [negro,rojo,rojo].
Jugador 2 juega 2 fichas de tipo rojo en la fila 2 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #7 : [blanco,negro,blanco,negro].
Centro [negro].
Jugador 3 juega 1 fichas de tipo negro en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #7 : [blanco,negro,blanco,negro].
Centro [].
Jugador 4 juega 2 fichas de tipo blanco en la fila 5 desde la Factoría 7
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Centro [negro,negro].
Jugador 1 juega 2 fichas de tipo negro en la fila 4 desde el centro
Fin del Turno.
No se pueden realizar jugadas.
Fin de la Ronda.
Preparando Siguiente Ronda.
Fin de la Preparación.
Empezando Nueva Ronda:
Turno del Jugador 2.
Estado de la Mesa:
Factoria #1 : [negro,blanco,blanco,negro].
Factoria #2 : [azul,amarillo,blanco,negro].
Factoria #3 : [amarillo,azul,rojo,negro].
Factoria #4 : [rojo,amarillo,azul,blanco].
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [especial].
Jugador 2 juega 1 fichas de tipo negro en la fila 1 desde la Factoría 2
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #1 : [negro,blanco,blanco,negro].
Factoria #3 : [amarillo,azul,rojo,negro].
Factoria #4 : [rojo,amarillo,azul,blanco].
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [especial,azul,amarillo,blanco].
Jugador 3 juega 1 fichas de tipo rojo en la fila 1 desde la Factoría 3
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #1 : [negro,blanco,blanco,negro].
Factoria #4 : [rojo,amarillo,azul,blanco].
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [especial,azul,amarillo,blanco,amarillo,azul,negro].
Jugador 4 juega 2 fichas de tipo amarillo en la fila 2 desde el centro
El jugador 4 tomo la ficha especial y sera el primero en la siguiente Ronda.
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #1 : [negro,blanco,blanco,negro].
Factoria #4 : [rojo,amarillo,azul,blanco].
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [azul,azul,blanco,negro].
Jugador 1 juega 2 fichas de tipo blanco en la fila 2 desde la Factoría 1
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #4 : [rojo,amarillo,azul,blanco].
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [azul,azul,blanco,negro,negro,negro].
Jugador 2 juega 2 fichas de tipo azul en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #4 : [rojo,amarillo,azul,blanco].
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [blanco,negro,negro,negro].
Jugador 3 juega 1 fichas de tipo blanco en la fila 2 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #4 : [rojo,amarillo,azul,blanco].
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [negro,negro,negro].
Jugador 4 juega 1 fichas de tipo amarillo en la fila 1 desde la Factoría 4
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #5 : [amarillo,negro,azul,azul].
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [negro,negro,negro,rojo,azul,blanco].
Jugador 1 juega 1 fichas de tipo amarillo en la fila 1 desde la Factoría 5
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [negro,negro,negro,rojo,azul,blanco,negro,azul,azul].
Jugador 2 juega 4 fichas de tipo negro en la fila 4 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [rojo,azul,azul,azul,blanco].
Jugador 3 juega 1 fichas de tipo rojo en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #7 : [negro,negro,rojo,amarillo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [azul,azul,azul,blanco].
Jugador 4 juega 1 fichas de tipo amarillo en la fila 4 desde la Factoría 7
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [azul,azul,azul,blanco,negro,negro,rojo].
Jugador 1 juega 1 fichas de tipo blanco en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #6 : [amarillo,azul,amarillo,rojo].
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [azul,azul,azul,negro,negro,rojo].
Jugador 2 juega 2 fichas de tipo amarillo en la fila 2 desde la Factoría 6
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [azul,azul,azul,negro,negro,rojo,azul,rojo].
Jugador 3 juega 4 fichas de tipo azul en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [negro,negro,rojo,rojo].
Jugador 4 juega 2 fichas de tipo negro en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #8 : [azul,azul,blanco,blanco].
Factoria #9 : [blanco,negro,blanco,azul].
Centro [rojo,rojo].
Jugador 1 juega 2 fichas de tipo blanco en la fila 5 desde la Factoría 8
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #9 : [blanco,negro,blanco,azul].
Centro [rojo,rojo,azul,azul].
Jugador 2 juega 2 fichas de tipo rojo en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #9 : [blanco,negro,blanco,azul].
Centro [azul,azul].
Jugador 3 juega 1 fichas de tipo negro en la fila 3 desde la Factoría 9
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Centro [azul,azul,blanco,blanco,azul].
Jugador 4 juega 3 fichas de tipo azul en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Centro [blanco,blanco].
Jugador 1 juega 2 fichas de tipo blanco en la fila 3 desde el centro
Fin del Turno.
No se pueden realizar jugadas.
Fin de la Ronda.
Preparando Siguiente Ronda.
Fin de la Preparación.
Empezando Nueva Ronda:
Turno del Jugador 4.
Estado de la Mesa:
Factoria #1 : [rojo,rojo,blanco,rojo].
Factoria #2 : [amarillo,rojo,negro,rojo].
Factoria #3 : [rojo,azul,rojo,blanco].
Factoria #4 : [rojo,azul,negro,amarillo].
Centro [especial].
Jugador 4 juega 1 fichas de tipo rojo en la fila 1 desde la Factoría 4
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #1 : [rojo,rojo,blanco,rojo].
Factoria #2 : [amarillo,rojo,negro,rojo].
Factoria #3 : [rojo,azul,rojo,blanco].
Centro [especial,azul,negro,amarillo].
Jugador 1 juega 1 fichas de tipo azul en la fila 1 desde el centro
El jugador 1 tomo la ficha especial y sera el primero en la siguiente Ronda.
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #1 : [rojo,rojo,blanco,rojo].
Factoria #2 : [amarillo,rojo,negro,rojo].
Factoria #3 : [rojo,azul,rojo,blanco].
Centro [negro,amarillo].
Jugador 2 juega 1 fichas de tipo blanco en la fila 1 desde la Factoría 1
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #2 : [amarillo,rojo,negro,rojo].
Factoria #3 : [rojo,azul,rojo,blanco].
Centro [negro,amarillo,rojo,rojo,rojo].
Jugador 3 juega 1 fichas de tipo negro en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Factoria #2 : [amarillo,rojo,negro,rojo].
Factoria #3 : [rojo,azul,rojo,blanco].
Centro [amarillo,rojo,rojo,rojo].
Jugador 4 juega 1 fichas de tipo negro en la fila 3 desde la Factoría 2
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Factoria #3 : [rojo,azul,rojo,blanco].
Centro [amarillo,rojo,rojo,rojo,amarillo,rojo,rojo].
Jugador 1 juega 5 fichas de tipo rojo en la fila 5 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Factoria #3 : [rojo,azul,rojo,blanco].
Centro [amarillo,amarillo].
Jugador 2 juega 2 fichas de tipo amarillo en la fila 4 desde el centro
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Factoria #3 : [rojo,azul,rojo,blanco].
Centro [].
Jugador 3 juega 1 fichas de tipo azul en la fila 1 desde la Factoría 3
Fin del Turno.
Turno del Jugador 4.
Estado de la Mesa:
Centro [rojo,rojo,blanco].
Jugador 4 juega 2 fichas de tipo rojo en la fila 1 desde el centro
Fin del Turno.
Turno del Jugador 1.
Estado de la Mesa:
Centro [blanco].
Jugador 1 juega 1 fichas de tipo blanco en la fila 3 desde el centro
Fin del Turno.
Turno del Jugador 2.
Estado de la Mesa:
Centro [].
Jugador 2 juega 1 fichas de tipo blanco en la fila 1 desde la Factoría 5
Fin del Turno.
Turno del Jugador 3.
Estado de la Mesa:
Centro [amarillo].
Jugador 3 juega 1 fichas de tipo amarillo en la fila 4 desde el centro
Fin del Turno.
No se pueden realizar jugadas.
Fin de la Ronda.
Preparando Siguiente Ronda.
Fin de la Preparación.
El juego termina pues el jugador 4 ha completado una fila.
Resultados:
Jugador 2 : 60
Jugador 1 : 48
Jugador 4 : 38
Jugador 3 : 23
true.
```
