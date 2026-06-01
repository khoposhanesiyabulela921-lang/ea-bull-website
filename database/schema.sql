-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    display_name VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    is_mentor BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- License Keys Table
CREATE TABLE IF NOT EXISTS licenses (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    license_key VARCHAR(255) UNIQUE NOT NULL,
    product_name VARCHAR(100) DEFAULT 'TITAN',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bot Configurations Table
CREATE TABLE IF NOT EXISTS bots (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    license_id INTEGER NOT NULL REFERENCES licenses(id) ON DELETE CASCADE,
    bot_name VARCHAR(255) NOT NULL,
    bot_type VARCHAR(50) DEFAULT 'TITAN',
    trade_direction VARCHAR(20) NOT NULL, -- BUY_ONLY, SELL_ONLY, BOTH
    lot_size DECIMAL(10, 2) NOT NULL,
    max_trades INTEGER DEFAULT 1,
    take_profit INTEGER DEFAULT 100,
    stop_loss INTEGER DEFAULT 50,
    trailing_stop INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT FALSE,
    is_running BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- MT4/MT5 Accounts Table
CREATE TABLE IF NOT EXISTS broker_accounts (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_number VARCHAR(20) NOT NULL,
    broker_name VARCHAR(100),
    broker_type VARCHAR(10), -- MT4 or MT5
    login_username VARCHAR(255),
    encrypted_password VARCHAR(255),
    server VARCHAR(255),
    is_connected BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trades Table
CREATE TABLE IF NOT EXISTS trades (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    bot_id INTEGER NOT NULL REFERENCES bots(id) ON DELETE CASCADE,
    broker_account_id INTEGER NOT NULL REFERENCES broker_accounts(id) ON DELETE CASCADE,
    ticket_number VARCHAR(50),
    symbol VARCHAR(20),
    trade_type VARCHAR(10), -- BUY or SELL
    entry_price DECIMAL(15, 5),
    exit_price DECIMAL(15, 5),
    lot_size DECIMAL(10, 2),
    take_profit DECIMAL(15, 5),
    stop_loss DECIMAL(15, 5),
    status VARCHAR(20), -- OPEN, CLOSED, PENDING
    profit_loss DECIMAL(15, 2),
    opened_at TIMESTAMP,
    closed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Webhooks Table
CREATE TABLE IF NOT EXISTS webhooks (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    webhook_url VARCHAR(2048) NOT NULL,
    api_key VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- API Keys Table
CREATE TABLE IF NOT EXISTS api_keys (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    api_key VARCHAR(255) UNIQUE NOT NULL,
    api_secret VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    last_used_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chart Analysis Table
CREATE TABLE IF NOT EXISTS chart_analyses (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    image_url VARCHAR(2048),
    symbol VARCHAR(20),
    trend VARCHAR(50),
    support_levels TEXT,
    resistance_levels TEXT,
    chart_patterns TEXT,
    signals TEXT,
    ai_confidence DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_uuid ON users(uuid);
CREATE INDEX idx_licenses_user_id ON licenses(user_id);
CREATE INDEX idx_licenses_key ON licenses(license_key);
CREATE INDEX idx_bots_user_id ON bots(user_id);
CREATE INDEX idx_trades_bot_id ON trades(bot_id);
CREATE INDEX idx_broker_accounts_user_id ON broker_accounts(user_id);
CREATE INDEX idx_api_keys_user_id ON api_keys(user_id);
CREATE INDEX idx_webhooks_user_id ON webhooks(user_id);
CREATE INDEX idx_chart_analyses_user_id ON chart_analyses(user_id);