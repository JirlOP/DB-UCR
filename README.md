
## Institución

Universidad de Costa Rica

## Integrantes

Jorge Ricardo Díaz Sagot - C12565

## EXAMEN_1 DB

### PARTE III

#### Descripcion

La tercera parte del examen es extra y opcional. Debe detallar todos los problemas de diseño que se realizaron en Ia parte l, explicar porque era un problema y el cambio detallar las modificaciones correspondiente para solucionarlo. Ademas, si este problema tenia una implicaciön en Ia implementacion indiquelo. En el caso de que no se requerian hacer cambios, explique porque se dejo la solucion dada. Suba todo el detalle en mediaci6n en un pdf. Esta parte tiene un valor måximo de 10 puntos.


#### Problemas de diseño

Los problemas que hubieron fueron por falta de análisis de cómo es un video juego. Una vez pude pensar bien en cómo es un video juego, pude hacer los cambios necesarios para que el juego fuera más fácil de jugar y más entretenido.

Problemas:

1. Tener enlazada con CUENTA tantas relacionas, hace que CUENTA sea muy dependiente de las demás clases. Además, en la especificación se mencionaba que la misma cuenta era la que se podía usar para jugar, pero en realidad con lo que se juega en un PERSONAJE, una cuenta teniendo varios personajes.
2. La entidad de EQUIPO no se definía bien, y no se veía claramente sus tipos. Si no tenía las especializaciones no veía cómo podía equipar al PEROSONAJE con un EQUIPO.
3. Lo que más me dificultaba el trabajo en diseño, era la no clara defición de la ralaciones entre EQUIPO, PERSONAJE y EQUIPO "ganado". Dado a que en el diseño no hay una relación que permitar saber las 3 cosas a la vez.
4. Además, para abarcar la restricción de que un personaje solo se puede poner un equipo que haya ganado o esté en su inventario, no se podía hacer con el diseño actual.
5. No tenía mucho sentido que PERSONA estuviera enlazado con las demás entidades, ya que su sentido no era ninguno en el juego, su valor era más el de tener datos de la PERSONA que tiene cuentas.

Esos eran los errores más grandes que había en el diseño. Una vez que los pude identificar, para tener una db con más sentido, hice los siguientes cambios:

Soluciones:

1. Separar CUENTA de PERSONAJE, para que una CUENTA pueda tener varios PERSONAJES. Además, para que no estuviera tan enlazada con las demás muchas entidades también fue un buen cambio. Teniendo hasta más sentido semánticamente que un PERSONAJE tenga ataque y defensa, y no una CUENTA.
2. Separar EQUIPO en especializaciones, para que se pudiera relacionar más fácilmente con PERSONAJE y CUENTA. Además, para que se pudiera relacionar con EQUIPO "ganado" y EQUIPO en inventario en por cada especialización, de esta manera no me molestaría en buscar en una tabla general de EQUIPO, sino que solo me quedaban tablas específicas en que buscar cada tipo de EQUIPO.
3. Añadir un inventario por cada PERSONAJE, para que se pudiera saber qué EQUIPO tiene en su inventario(EQUIPO ganado).
4. Se pudo en la relacion de inventario un atributo "equipado" para saber si el EQUIPO está equipado o no. De esta manera se puede saber si el EQUIPO está equipado o no, y si no está equipado, se puede saber si está en el inventario o no.
5. Hice que PERSONA no estuviera enlazado con las demás entidades. Para dejarla aislada proveyendo igualmente su valor de datos.


Con estas correciones se pudo hacer una db más clara y más fácil de entender. Además, se pudo implementar de manera más fácil, ya que se podía saber con más claridad qué se necesitaba para cada acción en el juego. Además proveía más fácilidad para hacer queries y para hacer cambios en el futuro al segregar las tablas en buena medida.
