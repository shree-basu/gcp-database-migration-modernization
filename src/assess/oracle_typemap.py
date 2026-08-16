"""Oracle -> PostgreSQL data-type mapping for heterogeneous conversion."""
ORACLE_TO_PG = {
    "NUMBER(1)": "boolean",          # common flag convention
    "NUMBER(*,0)": "bigint",
    "NUMBER": "numeric",
    "VARCHAR2": "varchar", "NVARCHAR2": "varchar", "CHAR": "char",
    "CLOB": "text", "NCLOB": "text", "BLOB": "bytea", "RAW": "bytea",
    "DATE": "timestamp",             # Oracle DATE includes a time component
    "TIMESTAMP": "timestamp",
    "TIMESTAMP WITH TIME ZONE": "timestamptz",
    "FLOAT": "double precision", "BINARY_DOUBLE": "double precision",
}

def map_type(oracle_type: str) -> str:
    key = oracle_type.strip().upper()
    if key in ORACLE_TO_PG:
        return ORACLE_TO_PG[key]
    base = key.split("(")[0]                       # strip precision/scale
    return ORACLE_TO_PG.get(base, "text  -- REVIEW: no direct mapping")

if __name__ == "__main__":
    for t in ["NUMBER(1)", "VARCHAR2(200)", "DATE", "CLOB", "SDO_GEOMETRY"]:
        print(f"{t:24} -> {map_type(t)}")