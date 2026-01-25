from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os
from dotenv import load_dotenv
from contextlib import asynccontextmanager
from database import close_pool
from routes import weapons, aircraft, guidance, targets

load_dotenv()

@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    close_pool()

app = FastAPI(
    title="JTAC Toolkit API",
    description="API for JTAC Weapon Catalog",
    version="1.0.0",
    lifespan=lifespan
)

# CORS configuration
frontend_url = os.getenv("FRONTEND_URL", "http://localhost:5173")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[frontend_url, "http://localhost:5173", "http://127.0.0.1:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(weapons.router)
app.include_router(aircraft.router)
app.include_router(guidance.router)
app.include_router(targets.router)

@app.get("/")
def root():
    return {
        "message": "JTAC Toolkit API",
        "docs": "/docs",
        "version": "1.0.0"
    }

@app.get("/api/health")
def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host=host, port=port)
