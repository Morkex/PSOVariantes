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
 
