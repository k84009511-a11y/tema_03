CREATE OR REPLACE TABLE tabla_final AS
SELECT DISTINCT
    id_transaccion,
    CAST(fecha_hora AS DATE) AS fecha,
    CAST(id_cuenta AS INTEGER) AS id_cuenta,
    tipo,
    CAST(monto AS DOUBLE) AS monto,
    moneda,
    canal,
    id_sucursal,
    sucursal,
    estado
FROM (
    SELECT * FROM validos
    UNION ALL
    SELECT * FROM rechazados_limpios
);
