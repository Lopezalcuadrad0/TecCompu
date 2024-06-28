### README
# TecCompu

## Versión Ampliada

**Fecha de finalización**: 29 de junio

### Descripción

En la versión ampliada del proyecto, se ha añadido un sistema de contabilización del inventario restante en la máquina expendedora. Este sistema activa la señal `EMPTY` cuando se agotan las latas disponibles. Inicialmente, la máquina se carga con 3 latas, y la señal `EMPTY` se resetea al introducir 3 nuevas latas mediante una señal de reabastecimiento (`RESTOCK`).

### Estados y Funcionalidad

- **Inicio**: Inicializa la máquina, resetea la salida de monedas y la señal `EMPTY`.
- **Waiting**: Acumula el dinero ingresado y decide si debe dispensar una lata o devolver cambio.
- **Cambio**: Devuelve el cambio adecuado si el dinero acumulado es mayor a 2€.
- **darLata**: Dispensa una lata de bebida, decrece el inventario de latas y activa la señal `EMPTY` si no hay latas disponibles.
- **Resetting**: Devuelve todo el dinero acumulado cuando se activa el RESET y luego vuelve al estado inicial.
- **Vacio**: Gestiona la condición en la que la máquina se queda sin latas y devuelve cualquier moneda que se inserte mientras está vacío. Permanece en este estado hasta que se active la señal `RESTOCK`.

### Testbench

Se han añadido varios escenarios de prueba para verificar el correcto funcionamiento de la máquina expendedora bajo diferentes combinaciones de monedas y billetes, así como la gestión del inventario y la funcionalidad de reabastecimiento.

Para más detalles sobre la implementación y simulación, consulta el GitBook: [Versión Ampliada](https://lopezalcuadrado.gitbook.io/teccompu/amplicion)

