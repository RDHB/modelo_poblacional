# PROYECTO: Modelo de Población ...
[![Binder](https://mybinder.org/v2/gh/fonsp/pluto-on-binder/master?urlpath=pluto/open?url=https%3A%2F%2Fgithub.com%2FRDHB%2Fmodelo_poblacional%2Fblob%2Fmaster%2Fejercicio_1.jl)

## Descripción
Para el estudio de las poblaciones es necesario diseñar modelos matemáticos que permitan sintetizar las características y factores que influyen en el crecimiento de la población, los modelos son las herramientas que permiten representar una población y predecir su dinámica.

Para el estudio de las poblaciones existen numerosos modelos, algunos sencillos y otros más complejos que permiten realizar predicciones o estimaciones de interés, con el objetivo de realizar diferentes acciones con dicho conocimiento generado, cada uno de los cuales presentan sus propias ventajas, limitaciones y casos de uso.

El proyecto presentado consiste en la revisión de dos modelos:
* El Modelo del Crecimiento Exponencial, uno de los primeros y más sencillos.
* El Age Structure Matrix Model, que permite estudiar las poblaciones tomando en cuenta la estructura de edades de la población.

De esta manera se realizan ciertas simulaciones, donde el usuario tiene libertad para inyectar datos y utilizar los modelos de población implementados.

## Requerimientos
+ Julia (1.4, 1.5 o 1.6)
+ Instalar el paquete Pluto y correr el código: 
"using Pkg; Pkg.add("Pluto"); using Pluto; Pluto.run()"
+ En Pluto buscar el cuaderno "ejercicio_1.jl", posterioremente usar los simuladores.

También puede usar Binder dando click al enlace que se encuentra en la parte superior de este documento (aún en implementación)
