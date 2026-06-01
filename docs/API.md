# TITAN Trading Robot - API Documentation

## Base URL
```
http://localhost:3000/api
```

## Authentication
All requests require JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Endpoints

### Authentication

#### Sign Up
```
POST /auth/signup
Content-Type: application/json

{
  "fullName": "John Doe",
  "displayName": "johndoe",
  "email": "john@example.com",
  "phone": "+27711234567",
  "password": "SecurePassword123!",
  "confirmPassword": "SecurePassword123!"
}

Response: 201 Created
{
  "user": {
    "id": 1,
    "uuid": "uuid-here",
    "email": "john@example.com",
    "displayName": "johndoe"
  },
  "token": "jwt_token_here",
  "refreshToken": "refresh_token_here"
}
```

#### Sign In
```
POST /auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "SecurePassword123!"
}

Response: 200 OK
{
  "token": "jwt_token_here",
  "refreshToken": "refresh_token_here",
  "user": { ... }
}
```

### Licenses

#### Get User Licenses
```
GET /licenses

Response: 200 OK
{
  "licenses": [
    {
      "id": 1,
      "uuid": "uuid-here",
      "licenseKey": "TITAN-XXXXX-XXXXX",
      "productName": "TITAN",
      "isActive": true,
      "expiresAt": "2027-06-01T00:00:00Z",
      "createdAt": "2026-06-01T00:00:00Z"
    }
  ]
}
```

#### Create License
```
POST /licenses
Content-Type: application/json

{
  "productName": "TITAN"
}

Response: 201 Created
{
  "license": { ... }
}
```

### Bots

#### Create Bot Configuration
```
POST /bots
Content-Type: application/json

{
  "botName": "My TITAN Bot",
  "licenseId": 1,
  "tradeDirection": "BOTH",
  "lotSize": 0.01,
  "maxTrades": 1,
  "takeProfit": 100,
  "stopLoss": 50,
  "trailingStop": 0
}

Response: 201 Created
{
  "bot": { ... }
}
```

### Trade Webhook Payload
```json
{
  "event": "trade.opened",
  "timestamp": "2026-06-01T10:00:00Z",
  "data": {
    "tradeId": "uuid-here",
    "botId": "uuid-here",
    "symbol": "EURUSD",
    "tradeType": "BUY",
    "entryPrice": 1.0850,
    "lotSize": 0.01,
    "takeProfit": 1.0950,
    "stopLoss": 1.0800
  }
}
```