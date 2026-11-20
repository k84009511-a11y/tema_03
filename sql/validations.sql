CREATE OR REPLACE TABLE rechazados AS
SELECT
    *,
    CASE
        WHEN id_transaccion IS NULL OR TRIM(id_transaccion) = '' THEN 'id_vacio'
        WHEN id_transaccion IN (
            SELECT id_transaccion
            FROM raw_transacciones
            GROUP BY id_transaccion
            HAVING COUNT(*) > 1
        ) THEN 'id_duplicado'
        WHEN TRY_CAST(fecha_hora AS TIMESTAMP) IS NULL THEN 'fecha_invalida'
        WHEN id_cuenta IS NULL OR TRY_CAST(id_cuenta AS INTEGER) IS NULL THEN 'cuenta_invalida'
        WHEN tipo IS NULL OR tipo NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio') THEN 'tipo_invalido'
        WHEN monto IS NULL OR TRY_CAST(monto AS DOUBLE) IS NULL THEN 'monto_no_numerico'
        WHEN TRY_CAST(monto AS DOUBLE) <= 0 THEN 'monto_negativo_o_cero'
        WHEN moneda IS NULL OR moneda NOT IN ('ARS', 'USD') THEN 'moneda_invalida'
        WHEN canal IS NULL OR canal NOT IN ('cajero', 'app', 'sucursal', 'web') THEN 'canal_invalido'
        WHEN sucursal IS NULL OR TRIM(sucursal) = '' THEN 'sucursal_vacia'
        WHEN estado IS NULL OR estado NOT IN ('aprobada', 'rechazada') THEN 'estado_invalido'
    END AS motivo_rechazo
FROM raw_transacciones
WHERE
    id_transaccion IS NULL
    OR TRIM(id_transaccion) = ''
    OR id_transaccion IN (
        SELECT id_transaccion
        FROM raw_transacciones
        GROUP BY id_transaccion
        HAVING COUNT(*) > 1
    )
    OR TRY_CAST(fecha_hora AS TIMESTAMP) IS NULL
    OR id_cuenta IS NULL
    OR TRY_CAST(id_cuenta AS INTEGER) IS NULL
    OR tipo IS NULL
    OR tipo NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
    OR monto IS NULL
    OR TRY_CAST(monto AS DOUBLE) IS NULL
    OR TRY_CAST(monto AS DOUBLE) <= 0
    OR moneda IS NULL
    OR moneda NOT IN ('ARS', 'USD')
    OR canal IS NULL
    OR canal NOT IN ('cajero', 'app', 'sucursal', 'web')
    OR sucursal IS NULL
    OR TRIM(sucursal) = ''
    OR estado IS NULL
    OR estado NOT IN ('aprobada', 'rechazada');


CREATE OR REPLACE TABLE validos AS
SELECT *
FROM raw_transacciones
WHERE
    id_transaccion IS NOT NULL
    AND TRIM(id_transaccion) <> ''
    AND id_transaccion NOT IN (
        SELECT id_transaccion
        FROM raw_transacciones
        GROUP BY id_transaccion
        HAVING COUNT(*) > 1
    )
    AND TRY_CAST(fecha_hora AS TIMESTAMP) IS NOT NULL
    AND id_cuenta IS NOT NULL
    AND TRY_CAST(id_cuenta AS INTEGER) IS NOT NULL
    AND tipo IS NOT NULL
    AND tipo IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
    AND monto IS NOT NULL
    AND TRY_CAST(monto AS DOUBLE) IS NOT NULL
    AND TRY_CAST(monto AS DOUBLE) > 0
    AND moneda IS NOT NULL
    AND moneda IN ('ARS', 'USD')
    AND canal IS NOT NULL
    AND canal IN ('cajero', 'app', 'sucursal', 'web')
    AND sucursal IS NOT NULL
    AND TRIM(sucursal) <> ''
    AND estado IS NOT NULL
    AND estado IN ('aprobada', 'rechazada');
