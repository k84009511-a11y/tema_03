# Informe ETL - Banco Horizonte

## 1. Problemas encontrados en los datos
Al revisar el archivo transacciones.csv (2575 filas en total), encontramos varios errores de carga y formato:
- Filas duplicadas: 75 registros repetidos (150 filas involucradas con el mismo id_transaccion).
- Fechas con otro formato: 259 filas tenian la fecha como DD/MM/YYYY hh:mm:ss en vez de YYYY-MM-DD hh:mm:ss.
- Tipos de operacion fallados: 203 filas venian en mayusculas o con espacios adelante y atras (por ejemplo 'EXTRACCION' o ' TRANSFERENCIA').
- Montos con formato distinto: 155 filas tenian punto para los miles y coma para los decimales (por ejemplo '87.484,74').
- Sucursales vacias: 132 filas tenian el nombre de sucursal nulo, aunque si tenian cargado el id_sucursal (S01 a S05).
- Moneda en minuscula: 129 filas decian 'ars' o 'usd' en lugar de 'ARS' o 'USD'.
- Montos negativos: 106 filas tenian el signo menos adelante.

## 2. Resumen de validacion y limpieza
De las 2575 filas originales en raw_transacciones:
- Registros validos directos: 1509
- Registros rechazados para limpiar: 1066

Cantidad de rechazos registrados en motivo_rechazo:
- fecha_invalida: 241
- tipo_invalido: 197
- id_duplicado: 150
- monto_no_numerico: 145
- moneda_invalida: 121
- sucursal_vacia: 118
- monto_negativo_o_cero: 94
- id_vacio: 0
- cuenta_invalida: 0
- canal_invalido: 0
- estado_invalido: 0

Luego de corregir los formatos, sacar el signo menos de los montos negativos, completar el nombre de cada sucursal con su codigo y eliminar los duplicados, la tabla_final quedo con 2500 transacciones listas

## 3. Respuestas a las preguntas de negocio

1. Monto total aprobado por tipo de operacion en ARS:
- deposito: $ 244.315.991,27
- pago_servicio: $ 215.817.670,08
- extraccion: $ 214.557.718,96
- transferencia: $ 199.063.880,75

2. Cantidad de transacciones por canal:
- web: 646
- app: 642
- cajero: 620
- sucursal: 592

3. Cuenta con mas movimientos:
- La cuenta 10092 con un total de 15 movimientos.

4. Porcentaje de transacciones rechazadas por sucursal:
- Palermo: 9,02% (46 rechazadas de 510)
- La Plata: 8,87% (43 rechazadas de 485)
- Centro: 8,60% (43 rechazadas de 500)
- Caballito: 8,01% (41 rechazadas de 512)
- Belgrano: 7,71% (38 rechazadas de 493)

5. Transacciones por mes (primeros 6 meses):
- 2024-01: 102
- 2024-02: 99
- 2024-03: 103
- 2024-04: 107
- 2024-05: 113
- 2024-06: 101