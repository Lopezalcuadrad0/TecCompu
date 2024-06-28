### README
# TecCompu
## Versión Inicial

**Fecha de finalización**: 27 de junio

### Descripción

En la versión inicial del proyecto, se asumió que la máquina siempre tiene latas disponibles, por lo que no se consideró la gestión del inventario.

### Estados y Funcionalidad

- **Inicio**: Inicializa la máquina, resetea la salida de monedas y espera la inserción de una moneda.
- **Waiting**: Acumula el dinero ingresado y decide si debe dispensar una lata o devolver cambio.
- **Cambio**: Devuelve el cambio adecuado si el dinero acumulado es mayor a 2€.
- **darLata**: Dispensa una lata de bebida, reinicia el total de dinero y regresa al estado inicial.
- **Resetting**: Devuelve todo el dinero acumulado cuando se activa el RESET y luego vuelve al estado inicial.

### Testbench

Se han añadido varios escenarios de prueba para verificar el correcto funcionamiento de la máquina expendedora bajo diferentes combinaciones de monedas y billetes.

Para más detalles sobre la implementación y simulación, consulta el GitBook: [Versión Inicial](https://lopezalcuadrado.gitbook.io/teccompu/trabajo-sin-ampliar)

