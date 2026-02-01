# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

JTAC Toolkit is a weapon catalog application for Joint Terminal Attack Controllers. It provides reference data for weapons including danger close distances, warhead specifications, guidance types, and target effectiveness ratings. The stack is FastAPI (Python) with PostgreSQL and a React/Vite frontend.

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
```
backend/
├── main.py          # FastAPI app with CORS and router registration
├── database.py      # psycopg2 connection pool (synchronous)
├── models.py        # Pydantic models (Weapon, Target, WeaponTargetPairing)
├── requirements.txt # Python dependencies
├── .env.example     # Environment variable template
└── routes/
    ├── weapon.py    # /api/weapons endpoints with filtering
    └── target.py    # /api/targets endpoints
```

### Database Schema (PostgreSQL)

**Tables:**
- `weapon_type` - Main weapon type category
- `weapon_subtype` - Weapon subtype category (GP, JDAM, LJDAM, DMLGB, LGB, SDB, HELLFIRE, CBU, FW, RW)
- `weapon` - Weapons with name, type, danger close distances, warhead specs, guidance type
- `target` - Target types (personnel, vehicles, structures, etc.)
- `weapon_subtype_target` - Junction table pairing targets to weapon subtypes
- `weapon_target` - Junction table pairing targets to specific weapons

**ENUMs:**
- `target_category_enum`: PERSONNEL, VEHICLE, STRUCTURE, FORTIFICATION, OTHER

### Frontend Structure
```
frontend/src/
├── App.jsx
├── main.jsx
└── components/
    ├── Layout.jsx      # Page wrapper with header
    ├── Home.jsx        # Main page, fetches and displays weapons
    ├── WeaponCard.jsx  # Weapon display card with all details
    └── FilterBar.jsx   # Filter UI
```

**Tech:** React 19, Vite, Tailwind CSS, Axios, React Router

### API Endpoints

**Weapons:**
- `GET /api/weapons` - List all weapons with optional filters:
  - `weapon_type` - Filter by type (BOMB, MISSILE, ROCKET, GUN)
  - `guidance_type` - Filter by guidance (LGB, GPS, INS, etc.)
  - `target_id` - Filter by compatible target
  - `search` - Search by weapon name
- `GET /api/weapons/{id}` - Single weapon with target pairings

**Targets:**
- `GET /api/targets` - List all targets
- `GET /api/targets/{id}` - Single target

**Other:**
- `GET /api/health` - Health check
- `GET /` - API info with docs link

## Configuration

Backend requires `.env` file in `backend/` directory (see `.env.example`):
```
DATABASE_URL=postgresql://username:password@localhost:5432/database_name
HOST=0.0.0.0
PORT=8000
FRONTEND_URL=http://localhost:5173
```

## Database Setup

Run the SQL files in `database/` directory:
1. `schema.sql` - Creates tables and indexes
2. `seed_data.sql` - Populates initial weapon and target data
