import duckdb
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "datos"
SQL_DIR = BASE_DIR / "sql"
DB_PATH = BASE_DIR / "banco.duckdb"


def read_sql(filename: str):
    path = SQL_DIR / filename
    return path.read_text(encoding="utf-8")


def count(con, table):
    return con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]


def main():
    try:
        con = duckdb.connect(str(DB_PATH))
        print("-------- Conexion establecida con DuckDB --------")

        con.execute(
            read_sql("extract.sql"),
            [str(DATA_DIR / "transacciones.csv")]
        )
        print("Filas extraidas:", count(con, "raw_transacciones"))

        print("-------- Validando losh datos --------")
        con.execute(read_sql("validations.sql"))
        print("Registros validos:", count(con, "validos"))
        print("Registros rechazados:", count(con, "rechazados"))

        print("-------- Limpiando los rechazados --------")
        con.execute(read_sql("limpieza.sql"))
        print("Rechazados limpios:", count(con, "rechazados_limpios"))

        print("-------- Armando la tabla final --------")
        con.execute(read_sql("tabla_final.sql"))
        print("Total en tabla_final:", count(con, "tabla_final"))

        print("-------- Ejecutando consultas de negocio --------")
        mensajes = [
            "Monto total en ARS por tipo",
            "Cantidad de transacciones por canal",
            "Cuenta con mayor cantidad de movimientos",
            "Porcentaje de rechazo por sucursal",
            "Transacciones primeros 6 meses",
        ]
        consultas = [
            c.strip()
            for c in read_sql("consultas.sql").split(";")
            if "SELECT" in c.upper()
        ]

        for mensaje, consulta in zip(mensajes, consultas):
            print("\n" + mensaje)
            for fila in con.execute(consulta).fetchall():
                print(fila)
            print("---")

        con.close()
        print("-------- Proceso terminado profe --------")
    except Exception as e:
        print("Error en la ejecucion del ETL:", str(e))


if __name__ == "__main__":
    main()