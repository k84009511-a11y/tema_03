CREATE OR REPLACE TABLE rechazados_limpios AS
SELECT
    id_transaccion,
    fecha_hora,
    id_cuenta,
    tipo,
    monto,
    moneda,
    canal,
    id_sucursal,
    sucursal,
    estado
FROM rechazados;

UPDATE rechazados_limpios
SET
    id_transaccion = TRIM(id_transaccion),
    tipo = LOWER(TRIM(tipo)),
    moneda = UPPER(TRIM(moneda)),
    canal = LOWER(TRIM(canal)),
    id_sucursal = UPPER(TRIM(id_sucursal)),
    estado = LOWER(TRIM(estado));

UPDATE rechazados_limpios SET sucursal = 'Centro' WHERE (sucursal IS NULL OR TRIM(sucursal) = '') AND id_sucursal = 'S01';
UPDATE rechazados_limpios SET sucursal = 'Palermo' WHERE (sucursal IS NULL OR TRIM(sucursal) = '') AND id_sucursal = 'S02';
UPDATE rechazados_limpios SET sucursal = 'Belgrano' WHERE (sucursal IS NULL OR TRIM(sucursal) = '') AND id_sucursal = 'S03';
UPDATE rechazados_limpios SET sucursal = 'Caballito' WHERE (sucursal IS NULL OR TRIM(sucursal) = '') AND id_sucursal = 'S04';
UPDATE rechazados_limpios SET sucursal = 'La Plata' WHERE (sucursal IS NULL OR TRIM(sucursal) = '') AND id_sucursal = 'S05';

UPDATE rechazados_limpios
SET monto = REPLACE(REPLACE(monto, '.', ''), ',', '.')
WHERE monto LIKE '%,%';

UPDATE rechazados_limpios
SET monto = REPLACE(monto, '-', '')
WHERE monto LIKE '-%';


UPDATE rechazados_limpios
SET fecha_hora = CAST(STRPTIME(fecha_hora, '%d/%m/%Y %H:%M:%S') AS VARCHAR)
WHERE fecha_hora LIKE '%/%';
