# TITAN Trading Robot - Setup Guide

## Prerequisites
- Docker & Docker Compose
- Node.js 18+ (for local development)
- Git
- MetaTrader 4/5 account

## Quick Start with Docker

### 1. Clone Repository
```bash
git clone https://github.com/khoposhanesiyabulela921-lang/ea-bull-website.git
cd ea-bull-website
```

### 2. Setup Environment
```bash
cp backend/.env.example backend/.env
```

### 3. Start Services
```bash
cd docker
docker-compose up -d
```

Services available at:
- Frontend: http://localhost:3001
- Backend API: http://localhost:3000
- AI Service: http://localhost:5000

### 4. Initialize Database
```bash
docker exec titan_backend npm run db:migrate
```

## Manual Setup

### Backend
```bash
cd backend
npm install
cp .env.example .env
npm run dev
```

### AI Service
```bash
cd ai-service
pip install -r requirements.txt
python app.py
```

## MQL5 EA Installation

1. Download `TITAN.mq5`
2. Open MetaTrader → File → Open Data Folder
3. Navigate to MQL5/Experts
4. Copy TITAN.mq5 there
5. Restart MetaTrader
6. Attach EA to chart and configure parameters

## Support

WhatsApp: +27 71 683 3301
Email: support@titan-trading.com