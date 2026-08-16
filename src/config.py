"""Central config: load DB connection settings from environment."""
import os
from dataclasses import dataclass
from dotenv import load_dotenv

load_dotenv()

@dataclass
class DbConfig:
    host: str; port: int; dbname: str
    user: str; password: str; sslmode: str

    def dsn(self) -> str:
        return (f"host={self.host} port={self.port} dbname={self.dbname} "
                f"user={self.user} password={self.password} sslmode={self.sslmode}")

def _cfg(prefix: str) -> DbConfig:
    return DbConfig(
        host=os.getenv(f"{prefix}_HOST", "localhost"),
        port=int(os.getenv(f"{prefix}_PORT", "5432")),
        dbname=os.getenv(f"{prefix}_DB", "postgres"),
        user=os.getenv(f"{prefix}_USER", "postgres"),
        password=os.getenv(f"{prefix}_PASSWORD", ""),
        sslmode=os.getenv(f"{prefix}_SSLMODE", "prefer"),
    )

SOURCE = _cfg("SRC")
TARGET = _cfg("TGT")