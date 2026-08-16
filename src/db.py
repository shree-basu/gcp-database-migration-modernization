"""Thin DB helper: context-managed connections and query helpers."""
from contextlib import contextmanager
import psycopg2, psycopg2.extras
from .config import DbConfig

@contextmanager
def connect(cfg: DbConfig):
    conn = psycopg2.connect(cfg.dsn())
    try:
        yield conn
    finally:
        conn.close()

def query_all(cfg, sql, params=None):
    with connect(cfg) as conn, conn.cursor(
            cursor_factory=psycopg2.extras.RealDictCursor) as cur:
        cur.execute(sql, params or ())
        return cur.fetchall()

def query_scalar(cfg, sql, params=None):
    with connect(cfg) as conn, conn.cursor() as cur:
        cur.execute(sql, params or ())
        row = cur.fetchone()
        return row[0] if row else None