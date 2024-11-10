# Análisis de la evolución del caudal en la Rambla del Poyo (29 de noviembre de 2024)

En este repositorio puedes encontrar el código fuente y una breve explicación de las gráficas resultantes de los análisis realizados. El artículo donde se desarrollan estos análisis y las conclusiones obtenidas lo puedes encontrar en:

[La crecida de la Rambla del Poyo: El peligro de ignorar el crecimiento exponencial](https://pablohaya.com/2024/11/10/la-crecida-de-la-rambla-del-poyo-el-peligro-de-ignorar-el-crecimiento-exponencial/)

Las dos gráficas siguientes son el resultado de un análisis de cómo ha influido el crecimiento exponencial del caudal en la Rambla del Poyo durante el 29 de octubre de 2024. Los datos corresponden a los registros cinco minutales del caudal en la estación de aforo de la Rambla del Poyo recolectador por el [Sistema de Automático de Información Hidrológica](https://saih.chj.es) de la [Confederación Hidrológica del Jucar](https://www.chj.es) (CHJ). Estos datos fueron solicitados por [Antonio Delgado](https://x.com/adelgado) y compartidos el repositorio de [Datadista](https://github.com/datadista/datasets/tree/master/dana-valencia)

La primera gráfica muestra en escala logarítmica la evolución del caudal desde las 11:00 hasta las 18:55, que fue la última hora a la que se recibieron datos al arrasar el rio los instrumentos de medida. La escala logarítmica facilita el impacto del análisis del crecimiento exponencial del caudal, ya que el incremento del eje de las Y es exponencial, en vez de lineal. Cada marca se calcula multiplicando por $10$ la anterior. Así, la primera marca empieza en $1$ y la segunda salta a $10$, luego pasa $100$, finalmente a $1000$. 

Esta gráfica hay que interpretarla fijándonos cuando el caudal pasa de un marca a otra. Por ejemplo, cuando el caudal se encuentra entre $10\ m^3/s$ y $100\ m^3/s$, y pasa a estar entre $100\ m^3/s$ y $1000\ m^3/s$, durante este proceso terminamos multiplicando por $10$ o más el caudal. 

En la figura se resaltan dos momentos importantes. Al principio, cuando el caudal pasa por tres marcas, desde $1\ m^3/s$ hasta más de $100\ m^3/s$. Esta subida en tan poco tiempo fue enorme. Se multiplica el caudal por $100$ en $30$ minutos aproximadamente. La segunda es la franja entre las 16:00 y las 18:00 donde el caudal vuelve a crecer de manera exponencial ---el caudal sigue creciendo exponencialmente después de las 18:00 pero ya con muy poca capacidad de reacción---. Dentro de este intervalo, la Rambla del Poyo multiplicó por $28$ su caudal en dos horas ---paso de estar entre $10\ m^3/s$ y $100\ m^3/s$ a estar entre $100\ m^3/s$ y $1000\ m^3/s$---. 

![Figura 1](outputs/caudal_escala_logaritmica.jpg)

La siguiente figura complementa la anterior. Aquí cada punto representa el incremento de caudal entre ese punto y el caudal que había 30 minutos antes. Por ejemplo, a las 17:00 había un caudal de $71.7\ m^3/s$ mientras que a las 16:30 el caudal era de $37.2\ m^3/s$, el incremento a las 17:00 es de $71.7/37.2 = 1.9$. La gráfica muestra el ascenso de estos incrementos desde las 16:30 hasta las 17:45, en el que alcanza el máximo, momento en el cual el rio iba a más de cuatro veces la medición que tuvo a las 17:15. A partir de este momento, aunque se desaceleran los incremento, el crecimiento del caudal sigue siendo exponencial multiplicándose entre por $1.5$ y por $3$ cada $30$ minutos.  

![Figura 2](outputs/incrementos_de_caudal.jpg)

## ¿Por qué es necesaria la escala logarítmica?

La [escala logarítimica es muy útil](https://www.youtube.com/watch?v=W_BZb_va6jY) cuando queremos visualizar valores que son muy dispares. Comparemos la [imagen que compartió la CHJ](https://x.com/CHJucar/status/1853407411064730011), cuya escala es lineal, con la Figura 1. 
   
 ![Figura 3](https://pbs.twimg.com/media/GbipM4oW0AA0OF2?format=jpg&name=large)

Si nos fijamos en la Figura 3 en el intervalo entre las 16:00 y las 18:00, y lo comparamos con el tramo final, parece que en esas dos horas no hay un crecimiento importante, sino que es a partir de las 18:00 cuando se dispara el crecimiento. En cambio, si se emplea una escala logarítmica para el eje de las Y, como en la Figura 1, se observa más claramente que entre las 16:00 y las 18:00 hay un pronunciado crecimiento del caudal. Con la escala logarítimica podemos observar fenómenos de crecimiento exponencial pueden pasar desapercibidos si representamos en escala lineal. 

En cualquier caso, la gráfica de la Figura 3, o similares como la que compartió Antonio Delgado en [la red social X](https://x.com/adelgado/status/1853840968736182772/photo/1), que dicho sea de paso está mejor diseñada, siguen siendo muy útiles. La diferencia es donde pone se quiere poner el foco para escoger una u otra representación.

## Licencia

La documentación y gráficas de este sitio web, y cualquier versión del mismo que puedas encontrarte en otros formatos, es gratuito y se licencia bajo los términos y condiciones de [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.es). Puedes descargarte, compartir y adaptar los materiales de este sitio web siempre que mantengas la atribución al autor y los distribuyas con la misma licencia.

El código se rige por la licencia de código abierto [MIT](LICENSE).