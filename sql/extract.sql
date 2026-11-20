CREATE OR REPLACE TABLE raw_transacciones AS
SELECT *
FROM READ_CSV_AUTO(?, delim=';', header=true, all_varchar=true);
