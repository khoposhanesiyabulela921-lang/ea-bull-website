# TITAN Trading Robot Platform

A comprehensive AI-powered trading automation platform with MQL5 Expert Advisor, web portal, mobile apps, and intelligent chart analysis.

## 🎯 Features

### Core Trading System
- **TITAN EA (MQL5)**: Advanced trading robot with BUY/SELL/BOTH modes
- **Lot Size Control**: Dynamic position sizing
- **Multi-Directional Trading**: BUY only, SELL only, or both directions
- **24/7 Auto Trading**: PC and mobile support
- **Risk Management**: Take Profit, Stop Loss, Trailing Stop

### User Management
- Account registration and authentication
- License key system with expiry tracking
- Mentor program support
- User profile management

### Dashboard & Controls
- License key status and expiry dates
- Real-time bot execution controls
- MT4/MT5 broker account connection
- EA management and deployment
- Webhook URL and API key setup
- Bot performance analytics

### AI Features
- Chart image analysis
- Trend, support/resistance detection
- Chart pattern recognition
- Automated BUY/SELL signal generation
- TradingView integration

### Mobile & Apps
- iOS Progressive Web App (PWA) - Free
- Android Native App - R600
- Real-time trade monitoring
- Mobile trading configuration
- JSON-based auto-trading control

### Integrations
- MetaTrader 4/5 connectivity
- TradingView charting & signals
- WhatsApp chatbot integration
- Webhook support
- REST API with authentication

## 🏗️ Tech Stack

- **Backend**: Node.js 18+ | Express.js
- **Frontend**: React 18+
- **Mobile**: React Native + PWA
- **Database**: PostgreSQL 14+
- **Authentication**: JWT
- **AI/ML**: Python (TensorFlow/OpenCV)
- **Deployment**: Docker + docker-compose

## 📁 Project Structure

```
ea-bull-website/
├── backend/                    # Node.js/Express Backend
│   ├── src/
│   │   ├── api/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── middleware/
│   │   ├── services/
│   │   ├── utils/
│   │   └── config/
│   ├── tests/
│   ├── package.json
│   └── .env.example
├── frontend/                   # React Web Portal
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── hooks/
│   │   └── assets/
│   ├── public/
│   └── package.json
├── mobile/                     # React Native App
│   ├── src/
│   └── package.json
├── ai-service/                 # Python AI Service
│   ├── models/
│   ├── app.py
│   └── requirements.txt
├── mql5/                       # Expert Advisor
│   ├── TITAN.mq5
│   ├── TITAN_Utils.mqh
│   └── TITAN_Config.json
├── database/                   # Database Schema
│   ├── schema.sql
│   └── migrations/
├── docs/                       # Documentation
│   ├── API.md
│   ├── SETUP.md
│   └── DEPLOYMENT.md
└── docker/                     # Docker Configuration
    ├── Dockerfile.backend
    ├── Dockerfile.frontend
    ├── Dockerfile.ai
    └── docker-compose.yml
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Node.js 18+ (for local development)
- PostgreSQL 14+ (optional, included in Docker)

### Using Docker (Recommended)
```bash
cd docker
docker-compose up -d
```

Services will be available at:
- Backend API: http://localhost:3000
- Frontend: http://localhost:3001
- AI Service: http://localhost:5000
- PostgreSQL: localhost:5432

### Manual Setup

#### Backend
```bash
cd backend
npm install
cp .env.example .env
npm run db:migrate
npm run db:seed
npm run dev
```

#### Frontend
```bash
cd frontend
npm install
npm start
```

#### AI Service
```bash
cd ai-service
pip install -r requirements.txt
python app.py
```

## 📖 Documentation

- [API Documentation](./docs/API.md)
- [Setup Guide](./docs/SETUP.md)
- [Deployment Guide](./docs/DEPLOYMENT.md)

## 🔐 Security

- JWT authentication with refresh tokens
- API key validation
- HTTPS/TLS encryption
- Secure password hashing (bcrypt)
- Rate limiting (100 req/min)
- Input validation & sanitization
- CORS protection
- SQL injection prevention

## 💰 Pricing

- **Web Portal**: Free
- **iOS PWA**: Free
- **Android App**: R600

## 📞 Support

- WhatsApp: +27 71 683 3301
- Email: support@titan-trading.com
- Documentation: https://titan-docs.com

## 🤝 Contributing

Contributions are welcome. Please create a feature branch and submit a pull request.

## 📄 License

Proprietary - TITAN Trading Platform © 2026

---

**Version**: 1.0.0
**Last Updated**: 2026-06-01