# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

JTAC Toolkit is a weapon catalog application for Joint Terminal Attack Controllers. It consists of a FastAPI backend with PostgreSQL and a React/Vite frontend.

## Commands

### Backend (from `backend/` directory)
```bash
# Create virtual environment
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run server
python main.py
# or
uvicorn main:app --reload
```

### Frontend (from `frontend/` directory)
```bash
npm install
npm run dev      # Development server (port 5173)
npm run build    # Production build
npm run lint     # ESLint
npm run preview  # Preview production build
```

## Architecture

### Backend Structure
- **main.py**: FastAPI app entry point with CORS configuration and router registration
- **database.py**: asyncpg connection pool management (PostgreSQL)
- **models.py**: Pydantic models for request/response validation
- **routes/**: API route handlers
  - `weapons.py`: Main endpoint with filtering by type, aircraft, guidance, target, and search
  - `aircraft.py`, `guidance.py`, `targets.py`: CRUD for reference data

### Database Schema (PostgreSQL)
Core tables: `weapons`, `aircraft`, `guidance_types`, `targets`
Junction tables: `weapon_aircraft`, `weapon_guidance`, `weapon_target`

Weapons have many-to-many relationships with aircraft, guidance types, and targets.

### Frontend Structure
- React 19 with Vite
- Tailwind CSS for styling
- Components: `Layout.jsx`, `Home.jsx`, `WeaponCard.jsx`, `FilterBar.jsx`

### API Endpoints
- `GET /api/weapons` - List weapons with optional filters (weapon_type, aircraft_id, guidance_id, target_id, search)
- `GET /api/weapons/{id}` - Single weapon with related data
- `GET /api/aircraft`, `GET /api/guidance`, `GET /api/targets` - Reference data
- `GET /api/health` - Health check

## Configuration

Backend requires `.env` file (see `.env.example`):
- `DATABASE_URL`: PostgreSQL connection string
- `HOST`, `PORT`: Server binding (defaults: 0.0.0.0:8000)
- `FRONTEND_URL`: CORS allowed origin (defaults: http://localhost:5173)
