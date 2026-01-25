import os
from psycopg2 import pool
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

# Connection pool
_pool = None

def get_pool():
    """Get or create database connection pool"""
    global _pool
    if _pool is None:
        _pool = pool.ThreadedConnectionPool(
            minconn=1,
            maxconn=10,
            dsn=DATABASE_URL
        )
    return _pool

def get_connection():
    """Get a connection from the pool"""
    return get_pool().getconn()

def release_connection(conn):
    """Release a connection back to the pool"""
    get_pool().putconn(conn)

def close_pool():
    """Close database connection pool"""
    global _pool
    if _pool:
        _pool.closeall()
        _pool = None
