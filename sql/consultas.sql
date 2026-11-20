SELECT
    tipo,
    ROUND(SUM(monto), 2) AS monto_total_ars
FROM tabla_final
WHERE estado = 'aprobada'
  AND moneda = 'ARS'
GROUP BY tipo
ORDER BY monto_total_ars DESC;

SELECT
    canal,
    COUNT(*) AS cantidad_transacciones
FROM tabla_final
GROUP BY canal
ORDER BY cantidad_transacciones DESC;

SELECT
    id_cuenta,
    COUNT(*) AS total_movimientos
FROM tabla_final
GROUP BY id_cuenta
ORDER BY total_movimientos DESC
LIMIT 1;

SELECT
    sucursal,
    COUNT(*) AS total_transacciones,
    SUM(CASE WHEN estado = 'rechazada' THEN 1 ELSE 0 END) AS rechazadas,
    ROUND(SUM(CASE WHEN estado = 'rechazada' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_rechazo
FROM tabla_final
GROUP BY sucursal
ORDER BY porcentaje_rechazo DESC;

SELECT
    STRFTIME(fecha, '%Y-%m') AS mes,
    COUNT(*) AS cantidad_transacciones
FROM tabla_final
GROUP BY mes
ORDER BY mes ASC
LIMIT 6;
