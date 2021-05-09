;--------------------------------- Load PSO Module ---------------------------------------------

__includes ["PSOVariantes.nls"]

;-----------------------------------------------------------------------------------------------

;--------------------------------- Specific Definitions ----------------------------------------
patches-own
[
  val  ; Cada patch tiene un valor de "fitness" asociado
       ; El objetivo del PS es encontrar el patch con el mejor valor de fitness
]

;-----------------------------------------------------------------------------------------------

;----------------------------------- Model Procedures ------------------------------------------

to setup-search-space
  ;; Prepara un espacio de búsqueda con colinas y valles
  ifelse num-max-locales = 0
  [ ask patches [ set val random-float 1.0 ]]
  [ ask n-of num-max-locales patches [ set val random-float 10.0 ]]
  ;; suaviza ligeramente el espacio
  repeat Suavizar-espacio [ diffuse val 1 ]
  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normaliza los valores para estar entre 0 y 0.99999
  ask patches [ set val 0.99999 * (val - min-val) / (max-val - min-val)  ]

  ; y hacemos que solo exista un máximo global, con valor 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
  ]

  ask patches [ set pcolor scale-color gray val 0.0 1.0]
  if ModoPiratas [
    ask patches [if val < 0.4
      [set pcolor blue]]

    ask patches [if val < 0.2
      [set pcolor [0 0 102]]]

    ask patches [if val > 0.4
      [set pcolor yellow]]

    ask patches [if val > 0.55
      [ set pcolor [153 76 0]]]

    ask patches [if val > 0.65
      [set pcolor green]]

    ask patches [if val > 0.95
      [set pcolor red]]
    ask patches [ if val > 0.9999
      [set pcolor black]
    ]
  ]
end

to setup
  clear-all
  if Familias and Geometrico [
    user-message ("La variación Familia y Geométrica no pueden usarse juntas")
    stop
  ]
  if Familias and NoAcumulativo [
    user-message ("La variación Familia y No Acumulativo no pueden usarse juntas")
    stop
  ]
  if Geometrico and NoAcumulativo [
    user-message ("La variación No Acumulativo y Geométrica no pueden usarse juntas")
    stop
  ]
  if Dinamico and NoAcumulativo [
    user-message ("La variación No Acumulativo y Dinamico no pueden usarse juntas")
    stop
  ]
  setup-search-space
  if Familias [
    AI:create-particlesFam poblacion 2 númeroFamilias
  ]
  if Geometrico [
    AI:create-particlesGeo poblacion 2 Pradio
  ]
  if NoAcumulativo [
    AI:Create-particlesNoAcum poblacion 2 RadioNoAcumulativo
  ]
  if not Geometrico and not Familias and not NoAcumulativo [
    AI:create-particles poblacion 2
  ]
  ; crear partículas y situarlas aleatoriamente en el mundo
  ask AI:particles [
    setxy (convert (first pos) min-pxcor max-pxcor) (convert (last pos) min-pycor max-pycor)
    pd
    set size 4
  ]

  if Familias [
    foreach families [f ->
      let rcolor  one-of base-colors
      ask AI:particles with [family = f] [
        set color rcolor
      ]
    ]
  ]

  if ModoPiratas[
    ask turtles [set shape "boat 3"]
    ask turtles [set size 10]
  ]
  reset-ticks
end

to LaunchCond
  if Familias and Geometrico [
    user-message ("La variación Familia y Geométrica no pueden usarse juntas")
    stop
  ]
  if Familias and NoAcumulativo [
    user-message ("La variación Familia y No Acumulativo no pueden usarse juntas")
    stop
  ]
  if Geometrico and NoAcumulativo [
    user-message ("La variación No Acumulativo y Geométrica no pueden usarse juntas")
    stop
  ]
  if Dinamico and NoAcumulativo [
    user-message ("La variación No Acumulativo y Dinamico no pueden usarse juntas")
    stop
  ]
  if Dinamico [LaunchDinamic]
  if not Dinamico [
    if Familias [LaunchFam]
    if Geometrico [LaunchGeo]
    if NoAcumulativo [LaunchNoAcum]
  ]
  if not Dinamico and not Familias and not Geometrico and not NoAcumulativo [Launch]
end

to Launch
  let best AI:PSO steps
  inercia-particula
  atraccion-mejor-personal
  atraccion-mejor-global
  lim-vel-particulas
  let p last best
  ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
  [ask patches in-radius 3 [ set pcolor red ]]
end

to LaunchFam
  let best AI:PSOFam steps
  inercia-particula
  atraccion-mejor-personal
  atraccion-mejor-global
  lim-vel-particulas
  let p last best
  ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
  [ask patches in-radius 3 [ set pcolor red ]]
end

to LaunchGeo
  let best AI:PSOGeo steps
  inercia-particula
  atraccion-mejor-personal
  atraccion-mejor-global
  lim-vel-particulas
  let p last best
  ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
  [ask patches in-radius 3 [ set pcolor red ]]
end

to LaunchNoAcum
  let best AI:PSONoAcum steps
  inercia-particula
  atraccion-mejor-personal
  atraccion-mejor-global
  lim-vel-particulas
  let p last best
  ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
  [ask patches in-radius 3 [ set pcolor red ]]
end

to LaunchDinamic
  if Familias [
    repeat repeticiones [
      setup-search-space
      DinamicGlobalSearch
      let best AI:PSOFam 1
      inercia-particula
      atraccion-mejor-personal
      atraccion-mejor-global
      lim-vel-particulas
      let p last best
      ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
      [
        ask patches in-radius 3 [ set pcolor red ]
      ]
    ]
  ]

  if Geometrico [
    repeat repeticiones [
      setup-search-space
      DinamicGlobalSearch
      let best AI:PSOGeo 1
      inercia-particula
      atraccion-mejor-personal
      atraccion-mejor-global
      lim-vel-particulas
      let p last best
      ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
      [
        ask patches in-radius 3 [ set pcolor red ]
      ]
    ]
  ]

  if not Geometrico and not Familias [
    repeat repeticiones [
      setup-search-space
      DinamicGlobalSearch
      let best AI:PSO 1
      inercia-particula
      atraccion-mejor-personal
      atraccion-mejor-global
      lim-vel-particulas
      let p last best
      ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
      [
        ask patches in-radius 3 [ set pcolor red ]
      ]
    ]
  ]
end
;-----------------------------------------------------------------------------------------------


;---------------------------------- Customizable Procedures ----------------------------------
; AI:evaluation reports the evaluation of the current particle. Must be individualize to
; fit the necesities of the problem

to-report AI:evaluation
  report val
end

; AI:PSOExternalUpdate contains the set of auxiliary actions to be performed in every
; iteration of the main loop

to AI:PSOExternalUpdate
  ask AI:particles [
    setxy (convert (first pos) min-pxcor max-pxcor) (convert (last pos) min-pycor max-pycor)
    ;set label (precision AI:evaluation 2)
  ]
  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
230
10
824
605
-1
-1
2.92
1
10
1
1
1
0
0
0
1
-100
100
-100
100
1
1
1
ticks
30.0

BUTTON
165
80
225
113
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
165
150
225
183
Launch
LaunchCond
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
10
45
225
78
poblacion
poblacion
1
100
55.0
1
1
NIL
HORIZONTAL

SLIDER
10
185
225
218
atraccion-mejor-personal
atraccion-mejor-personal
0
5
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
10
220
225
253
atraccion-mejor-global
atraccion-mejor-global
0
5
2.0
0.1
1
NIL
HORIZONTAL

SLIDER
10
115
160
148
inercia-particula
inercia-particula
0
1.0
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
10
150
160
183
lim-vel-particulas
lim-vel-particulas
0
1
0.01
.01
1
NIL
HORIZONTAL

MONITOR
905
160
1030
205
Mejor valor encontrado
global-best-value
4
1
11

SLIDER
10
10
225
43
Suavizar-espacio
Suavizar-espacio
0
100
43.0
1
1
NIL
HORIZONTAL

SLIDER
10
80
160
113
num-max-locales
num-max-locales
0
500
144.0
1
1
NIL
HORIZONTAL

PLOT
830
10
1030
160
Evolución Mejor Global
NIL
NIL
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot global-best-value"

MONITOR
830
160
887
205
Media:
mean [val] of patches
4
1
11

SLIDER
830
355
1005
388
númeroFamilias
númeroFamilias
1
10
3.0
1
1
NIL
HORIZONTAL

SWITCH
1035
10
1164
43
ModoPiratas
ModoPiratas
0
1
-1000

SLIDER
830
255
1002
288
repeticiones
repeticiones
0
500
100.0
10
1
NIL
HORIZONTAL

SWITCH
830
215
932
248
Dinamico
Dinamico
1
1
-1000

SLIDER
10
260
225
293
steps
steps
0
200
100.0
10
1
NIL
HORIZONTAL

SWITCH
830
315
933
348
Familias
Familias
1
1
-1000

SWITCH
830
415
947
448
Geometrico
Geometrico
1
1
-1000

SLIDER
830
455
1002
488
Pradio
Pradio
1
100
20.0
1
1
NIL
HORIZONTAL

MONITOR
10
305
75
350
Dinamico
Dinamico
17
1
11

MONITOR
80
305
170
350
Familias
Familias
17
1
11

MONITOR
10
355
75
400
NIL
Geometrico
17
1
11

SWITCH
830
510
967
543
NoAcumulativo
NoAcumulativo
1
1
-1000

SLIDER
830
550
1002
583
radioNoAcumulativo
radioNoAcumulativo
0
200
5.0
1
1
NIL
HORIZONTAL

MONITOR
80
355
172
400
NIL
NoAcumulativo
17
1
11

@#$#@#$#@
# 2º Proyecto Inteligencia Artificial
## Integrantes del grupo
* BAZAN TICSE, KEVIN ALEXANDER
* COMITRE PALACIOS, JOSE JOAQUIN
*  RUIZ JURADO, PABLO
## Proyecto Número 6
Extender la librería **PSO** vista en clase para reconocer **variantes**. Por ejemplo: conjuntos de partículas divididas en **familias** (cada partícula solo considera el óptimo global de su familia, no el del grupo completo), **geométricos** (cada partícula solo considera el óptimo global de entre aquellas partículas que están dentro de un determinado radio, que es un parámetro más del sistema), **funciones dinámicas** (la función a optimizar cambia en el tiempo, y por tanto el óptimo a buscar puede cambiar de localización, las partículas deben adaptarse a este cambio y ser capaces de seguirlo en el tiempo), estrategias de **no acumulación** (para que las partículas no exploren el mismo punto, por ejemplo, cuando acaban en torno al óptimo encontrado), etc...
>#### Ambientación
>Le hemos dado una ambientación al proyecto llamada Modo Pirata, si esta está activada el mapa de máximos y mínimos cambia a un mar con archipiélagos, siendo el mar valores pequeños y las islas, valores más altos, el color rojo indica que el tesoro (máximo) está cerca. Las partículas han tomado la forma de barcos piratas que buscan el tesoro entre las islas.

>*La ambientación está pensada para que una persona de nivel usuario pueda usar este programa sin saber como funciona PSO*

## Variantes realizadas
1. Familias
2. Geométrico
3. Función Dinámica
4. No Acumulación*
### Familias
Se dividen las partículas en familias, cada una de un color, cada familia comparte un máximo global. Obviamente, puede darse el caso de que varias familias compartan este máximo.
#### Familias Modo Piratas
Si el modo familias está activado, los piratas de un mismo color pertenecen al mismo bando, por ello se comunican entre sí para averiguar donde está el tesoro
### Geométrico
Dado un valor se crea un radio de influencia en cada partícula, toda partícula dentro del radio de otra partícula comparte máximo global.
#### Geométrico Modo Piratas
Si el modo geométrico está activado, los barcos indican a los barcos dentro de su radio de influencia la posible localización del tesoro.
### Función Dinámica
La función de entrada cambia en el tiempo, por lo que las partículas buscan el máximo que va cambiando de posición en el tiempo.
#### Función Dinámica
Un terremoto remueve la tierra, ¡pero este no impide que los piratas dejen de buscar el tesoro!
### No Acumulación
Las distintas partículas no exploran el mismo punto cuando una ya ha encontrado un máximo local, consiguiendo la dispersión de las partículas y con ello aumentar la posibilidad de encontrar un nuevo máximo local.
#### No Acumulación Modo Piratas
Los piratas ven los agujeros que han hecho el resto de piratas buscando el tesoro, pero les inspira más ánimo para seguir buscando en otro sitio.¡El tesoro puede andar cerca!

## Como usar la interfaz
* **Suavizar-Espacio:** Número de repeticiones de la función *diffuse* sobre el tablero
> **Diffuse:** Le dice a cada patch que proporcione partes iguales del (número * 100) por ciento del valor de la variable de patch a sus ocho patches vecinos. El número debe estar entre 0 y 1. Independientemente de la topología, la suma de la variable de parche se conservará en todo el mundo. (Si un parche tiene menos de ocho vecinos, cada vecino aún obtiene una octava parte; el parche conserva las partes restantes).

* **Población:** Número de agentes en el mundo
* **num-max-locales:** Número de máximos en el mundo, si este es 0 se hace una distribución de valores aleatoria por todo el mundo.
* **inercia-particula:** La tendencia de avance de una partícula una vez ha encontrado un máximo personal.
* **lim-vel-particulas:** Límite de velocidad de las partículas.
* **atraccion-mejor-personal:** Valor que indica la fuerza de atracción del mejor personal de esa partícula sobre ella, es decir, a mayor atracción, menos movimiento de la partícula sobre esa zona.
* **atraccion-mejor-global:** Valor que indica la fuerza de atracción del mayor global sobre cada partícula.
* **steps:** Número de pasos que realiza una partícula.
### Familias
* **númeroFamilias:** Número de familias en el mundo.
### Geométrico
* **Pradio:** Radio de influencia de una partícula, a mayor radio, mayor probabilidad de encontrar otra partícula en él y que estas compartan información.
### Dinámico
* **repeticiones:** Número de repeticiones de **steps**.
## Como usar la interfaz Pirata
* **Suavizar-Espacio:** Cuanto más grande sea este valor, menos profundo será el mar y más cantidad de playa y mar poco profundo habrá
* **Población:** Número de piratas en el mundo
* **num-max-locales:** Cuanto más grande sea este número, más zonas con tesoro habrá en el mundo, si es 0 la distribución de tesoros en el mundo es aleatoria.
* **inercia-particula:** La tendencia de avance de un bar pirata una vez ha encontrado un máximo personal.
* **lim-vel-particulas:** Límite de velocidad de los barcos piratas.
* **atraccion-mejor-personal:** Valor que indica la fuerza de atracción de la localización de un posible tesoro, es decir, a mayor atracción, más buscan los piratas el tesoro por esa zona.
* **atraccion-mejor-global:** Cuanto mayor sea este valor, más interés tendrán todos los piratas por ese punto.
* **steps:** Cuanto mayor sea este número, más avanzará un barco pirata.
### Familias
* **númeroFamilias:** Número de bandas de piratas en el mundo.
### Geométrico
* **Pradio:** Los piratas dentro del radio de otro barco pirata se comunican entre sí, buscando el tesoro en conjunto y compartiendo la mejor localización para buscar el tesoro.
### Dinámico
* **repeticiones:** Duración del terremoto.

# Explicación más a fondo
## ¿Qué es PSO?
La **Optimización por Enjambres de Partículas** (conocida como **PSO**, por sus siglas en inglés, **Particle Swarm Optimization**) es una técnica de optimización/búsqueda. PSO permite optimizar un problema a partir de una población de soluciones candidatas o partículas, repartidas por el "Espacio de búsqueda", el cual es una función de fitness con máximos y mínimos. El objetivo es encontrar tal f(x,y) que haga que esta solución sea máxima, en nuestro caso 1, ya que nuestro *espacio de búsqueda* está formado por valores aleatorios de 0 a 1.
El movimiento de cada partícula se ve influenciado por su mejor posición local hallada hasta el momento, así como por las mejores posiciones globales encontradas por otras partículas a medida que recorren el espacio de búsqueda.

### Funciones Originales

#### AI:PSO
```
to-report AI:PSO [#iters #inertia-particle #atraction-best-personal #atraction-best-global #lim-vel-particles]
  repeat #iters [
    AI:PSO-step #inertia-particle #atraction-best-personal #atraction-best-global #lim-vel-particles
    AI:PSOExternalUpdate
  ]
  report (list global-best-value global-best-pos)
end
```
Esta función llama a la función principal AI:PSO-step
#### AI:PSO-step
```
to AI:PSO-step [#inertia-particle #atraction-best-personal #atraction-best-global #lim-vel-particles]
  ; First, check if the best values mus be updated (personals and global)
  ask AI:particles [
    if evaluation > personal-best-value
    [
      set personal-best-value evaluation
      set personal-best-pos pos
    ]
    ;    if global-best-value < personal-best-value
    ;    [
    ;      set global-best-value personal-best-value
    ;      set global-best-pos personal-best-pos
    ;    ]
  ]
  let best min-one-of (AI:particles with-max [personal-best-value]) [who]
  set global-best-value [personal-best-value] of best
  set global-best-pos [personal-best-pos] of best
  
  ; Then, update velocities and positions of every particle
  ask AI:particles
  [
    ; Consider the inertia
    set velocity *v #inertia-particle velocity
    
    ; Attraction to personal best
    let to-personal-best-pos -v personal-best-pos pos
    set velocity +v velocity (*v ((1 - #inertia-particle) * #atraction-best-personal * (random-float 1.0)) to-personal-best-pos)
    
    ; Attraction to global best
    let to-global-best -v global-best-pos pos
    set velocity  +v velocity (*v ((1 - #inertia-particle) * #atraction-best-global * (random-float 1.0)) to-global-best)
    
    ; Bound the velocity
    let n norm velocity
    if n > #lim-vel-particles [set velocity (*v ( #lim-vel-particles / n) velocity)]
    
    ; Update the position of the particle
    set pos map cut01 (+v pos velocity)
    set evaluation AI:evaluation
  ]
  ; Restart particles that close too much
  ask AI:particles [
    let p pos
    let #d length p
    ask other AI:particles with [norm (-v  p pos) < .01] [
      set pos n-values #d [random-float 1]
      set velocity n-values #d  [(random-normal 0 1)]
      set evaluation AI:evaluation
    ]
  ]
end
```


Esta función realiza con cada iteración un paso en una dirección gobernada por un vector, este vector tiene en cuenta varios parámetros: 

* La **velocidad** y la **inercia**, que controlan la rapidez del movimiento.
* El **máximo local y el global**, que determinan la dirección y el sentido del vector, y dirigido por la atracción hacia cada uno de estos.
* Además, con cada step/paso se actualiza la evaluación de la partícula con el valor del patch en el que está, y comprueba si es mayor o menor que su mejor valor y posición personal y global.


## ¿Qué hemos hecho nosotros?
Nosotros hemos modificado la biblioteca proporcionada por nuestro profesor de IA, Fernando Sancho, para que nuestro programa pueda reconocer las siguientes 4 variantes:

* Familias
* Geométrico
* Dinámico
* No Acumulativo*

*No hemos sido capaces de implementar este método, aunque a continuación explicaremos un posible planteamiento de este. 

Además, a modo de ambientación hemos añadido un Modo Pirata, el cual hemos intentado que permita usar este programa a cualquier usuario, haciendo similitudes con las partículas y los máximos y mínimos, siendo estas barcos piratas que navegan por un archipielago, siendo el valor máximo una localización de un tesoro pirata. 
### Variante Familias
Para esta variante hemos modificado las funciones originales de AI:PSO y AI:PSO-step.
En AI:PSOFam hemos llamado simplemente a la función AI:PSO-step-Family, la cual es una modificación de la función AI:PSO-step.
A AI:PSO-step-Family le hemos añadido dos listas, una con los mejores valores por familia y otra con las mejores posiciones por familia, las cuales guardan los máximos globales por familia, finalmente, el fitness máximo que se devuelve es el valor más alto de esa lista con su posición.
### Variante Geométrico
Para esta variante hemos modificado las funciones originales de AI:PSO y AI:PSO-step.
En AI:PSOGeo hemos llamado simplemente a la función AI:PSO-step-Geometrico, la cual es una modificación de la función AI:PSO-step.
Con AI:PSO-step-Geometrico hemos conseguido que cada partícula tenga un radio de influencia, donde cada partícula dentro de ese radio comparte máximo local, así, al estar moviéndose por el mundo, entran en otros radios de otras partículas, las cuales se ven influenciadas de nuevo y así hasta encontrar el máximo.
Cabe destacar que este método funciona correctamente con algunos parámetros bien ajustados. Estos son el Radio y la Población. Si se pone un Radio muy pequeño, las partículas no compartirán información entre sí. Por contrapartida, si es muy grande el radio, todas las partículas compartirán información con todas, que sería como si no se hubiera modificado nada. El número de la población también afecta, ya que un número muy bajo de partículas, supondría una gran dificultad a la hora de compartir información.
### Variante Dinámico
Para esta variante no hemos modificado nada de la biblioteca PSO.nls, simplemente hemos modificado parámetros al llamar a la función AI:PSO-step, además de llamarla varias veces, funciona tal que así: 

```
repeat repeticiones [
      setup-search-space
      DinamicGlobalSearch
      let best AI:PSO 1
	      inercia-particula
	      atraccion-mejor-personal
	      atraccion-mejor-global
	      lim-vel-particulas
	      let p last best
      ask patch (convert (first p) min-pxcor max-pxcor) (convert (last p) min-pycor max-pycor)
      [
        ask patches in-radius 3 [ set pcolor red ]
      ]
    ]
```
Donde repeticiones es el número de veces que varía la función fitness y llamadas a la función AI:PSO y a su vez a step. Con esto hemos conseguido que a cada paso que den las partículas se modifica la función y vuelven a buscar un máximo.
La función DinamicGlobalSearch nos permite seguir buscando el máximo tras cada cambio en el mundo. Es por ello por lo que en cada iteración cambia el máximo global, ya que cambia el mundo y por lo tanto el máximo encontrado en cada momento.
```
to DinamicGlobalSearch
  if(repeticiones >= 2)[
    ask AI:particles[
      let valorPos 0
      ask patch (convert (first personal-best-pos ) min-pxcor max-pxcor) (convert (last personal-best-pos) min-pycor max-pycor)
      [
        set valorPos [val] of self
      ]
      if(valorPos != personal-best-value)
      [
        set personal-best-value  0
      ]
    ]
    let globalPos 0
    ask patch (convert (first global-best-pos ) min-pxcor max-pxcor) (convert (last global-best-pos) min-pycor max-pycor)[
      set globalPos [val] of self
    ]
    if(globalPos != global-best-value)
    [
      set global-best-value 0
    ]
  ]
end
```
### Variante No Acumulación
La variante de no Acumulación la hemos hecho de tal forma que las partículas van dejando marcadas las posiciones de sus máximos locales, por ello, cuando otra partícula llega a ese punto, esta es repelida y mandada a otro sitio aleatorio, evitando así la redundancia en máximos locales y la acumulación de partículas en un mismo punto

Empezamos basándonos en la idea de hacerlo mediante una lista tabú.
Una lista tabú funciona de tal forma que cada vez que se realiza una acción, dicha acción no puede volverse a hacer hasta pasado un tiempo.

Una de nuestras primeras ideas fue asignarle a los patches la propiedad "Num-tabu" que indicaba el tiempo en el que un patch no podia ser visitado, y además para que las partículas ignoraran el patch, le rebajábamos su valor a la mitad. Cuando el patch volvia a estar disponible (Su "Num-tabu" volvía a 0), le devolvíamos su valor normal. Esta opción fue descartada debido a que cuando terminaba el algoritmo nos daba valores raros a la finalización del mismo y no acababa de devolverle su valor original a los patches, además que la media era muy baja también.

Otra idea era hacer lo mismo de antes pero sin rebajar el valor del patch. De esta forma pudimos conseguir que el funcionamiento de activación/desactivación de los patches se ejecutara bien y no obteníamos valores raros. El inconveniente fue que no conseguimos hacer que las partículas redirigieran su trayectoria en una dirección en la que no hubiera patches tabú.

Después otra idea, que es la que tenemos actualmente en este código aunque no hace uso del algoritmo de búsqueda tabú, ha sido mediante el empleo de banderas.Hemos creado un Breed nuevo llamado Banderas, cada bandera dispone de su posición y un contador.Estas banderas funcionan de tal forma que se colocan en máximos locales y tienen un radio de influencia que abarca cierta cantidad de patches (Este radio puede ser variado por el usuario con el deslizador "radioNoAcumulativo"). Si una partícula entra en el radio de la bandera, la bandera disminuye su contador. Una vez que su contador esté por debajo de 0, en la siguiente iteración modificará la posición de la partícula de manera aleatoria y además reinicia su propio contador.

## Datos Adicionales 
* Es posible activar la variante Dinámica a la vez que Familias o Geométrico
* Debido a que no tendría sentido una mezcla entre la variación por Familias y Geométrica, estas no pueden activarse a la vez.
* No hemos implementado la mezcla entre Familias, Geometríco o Dinámico junto con No Acumulativo
* Se ha decidido que el mundo cambie 1 vez por cada paso, no hemos creado ninguna variable con deslizador para editarlo. Con esto tenemos 1 cambio de mundo por tick.
* Con respecto al modo Pirata, el método No Acumulativo no marca bien las banderas y por lo tanto no se llegan a ver.
*También cabe destacar que puede ocurrir que al activar al método No Acumulativo y hacer "Setup", las banderas no llegan a mostrarse en pantalla. Simplemente habría que presionar "Setup" otra vez y se solucionaría el problema.
 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat 3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
