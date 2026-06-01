//+------------------------------------------------------------------+
//|                                                       TITAN.mq5   |
//|                                  Trading Robot - Multi-Directional|
//|                              Support: BUY, SELL, BOTH Directions |
//+------------------------------------------------------------------+

#property copyright "TITAN Trading Platform"
#property link      "https://titan-trading.com"
#property version   "1.0"
#property strict
#property description "TITAN EA - Advanced Trading Robot with Lot Control"

//--- Input Parameters
input double   LotSize              = 0.01;           // Lot Size
input int      NumberOfTrades       = 1;              // Number of Trades
input int      TakeProfit           = 100;            // Take Profit (pips)
input int      StopLoss             = 50;             // Stop Loss (pips)
input int      TrailingStop         = 0;              // Trailing Stop (0 = disabled)
input ENUM_ACCOUNT_TRADE_MODE TradeMode = ACCOUNT_TRADE_MODE_FULL;
input bool     EnableLogging        = true;           // Enable Logging

// Trade Direction Enum
enum TRADE_DIRECTION {
    TRADE_BUY_ONLY = 0,     // BUY Only
    TRADE_SELL_ONLY = 1,    // SELL Only
    TRADE_BOTH = 2          // Both BUY and SELL
};

input TRADE_DIRECTION TradeDirection = TRADE_BOTH;

//--- Global Variables
int            OnInitError          = 0;
CTrade         trade;
CPositionInfo  positionInfo;
CSymbolInfo    symbolInfo;
int            TradesOpened         = 0;
bool           RobotActive          = true;
bool           WebhookReceived      = false;
string         WebhookCommand       = "";

//--- Constants
const string   CONFIG_FILE          = "titan_config.json";
const string   LOG_FILE             = "titan_log.txt";

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("TITAN EA v1.0 - Initializing...");
    
    // Validate inputs
    if (LotSize <= 0 || LotSize > 100) {
        Print("ERROR: Invalid Lot Size. Must be between 0.01 and 100");
        return INIT_PARAMETERS_INCORRECT;
    }
    
    if (NumberOfTrades <= 0 || NumberOfTrades > 10) {
        Print("ERROR: Invalid Number of Trades. Must be between 1 and 10");
        return INIT_PARAMETERS_INCORRECT;
    }
    
    if (TakeProfit < 0 || StopLoss < 0) {
        Print("ERROR: Take Profit and Stop Loss must be positive values");
        return INIT_PARAMETERS_INCORRECT;
    }
    
    // Initialize trade object
    trade.SetExpertMagicNumber(123456);
    trade.SetDeviationInPoints(10);
    
    Print("TITAN EA initialized successfully");
    Print("Trade Direction: ", GetTradeDirectionText(TradeDirection));
    Print("Lot Size: ", LotSize);
    Print("Max Trades: ", NumberOfTrades);
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    Print("TITAN EA - Deinitializing... Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    // Check if robot is active
    if (!RobotActive) {
        return;
    }
    
    // Validate symbol
    if (!symbolInfo.Name(_Symbol)) {
        Print("ERROR: Cannot get symbol info for ", _Symbol);
        return;
    }
    
    // Get current price
    double bid = symbolInfo.Bid();
    double ask = symbolInfo.Ask();
    
    // Update trailing stops
    if (TrailingStop > 0) {
        UpdateTrailingStops();
    }
    
    // Check for trading signals
    CheckTradingSignals(bid, ask);
}

//+------------------------------------------------------------------+
//| Check Trading Signals and Execute Trades                         |
//+------------------------------------------------------------------+
void CheckTradingSignals(double bid, double ask) {
    // Count existing positions
    int openTrades = CountOpenPositions();
    
    if (openTrades >= NumberOfTrades) {
        return; // Already at max trades
    }
    
    // Generate simple trading signal (can be replaced with complex logic)
    // This is a placeholder for actual trading signals
    
    int signal = GenerateSignal();
    
    if (signal == 1 && (TradeDirection == TRADE_BUY_ONLY || TradeDirection == TRADE_BOTH)) {
        OpenBuyTrade(ask);
    }
    
    if (signal == -1 && (TradeDirection == TRADE_SELL_ONLY || TradeDirection == TRADE_BOTH)) {
        OpenSellTrade(bid);
    }
}

//+------------------------------------------------------------------+
//| Open BUY Trade                                                    |
//+------------------------------------------------------------------+
void OpenBuyTrade(double ask) {
    double tp = NormalizeDouble(ask + (TakeProfit * _Point), _Digits);
    double sl = NormalizeDouble(ask - (StopLoss * _Point), _Digits);
    
    if (trade.Buy(LotSize, _Symbol, ask, sl, tp, "TITAN BUY")) {
        TradesOpened++;
        if (EnableLogging) {
            Log("BUY Trade opened - Lot: " + DoubleToString(LotSize, 2) + 
                " | TP: " + DoubleToString(tp, _Digits) + 
                " | SL: " + DoubleToString(sl, _Digits));
        }
    } else {
        Print("ERROR: Failed to open BUY trade - Error: ", GetLastError());
    }
}

//+------------------------------------------------------------------+
//| Open SELL Trade                                                   |
//+------------------------------------------------------------------+
void OpenSellTrade(double bid) {
    double tp = NormalizeDouble(bid - (TakeProfit * _Point), _Digits);
    double sl = NormalizeDouble(bid + (StopLoss * _Point), _Digits);
    
    if (trade.Sell(LotSize, _Symbol, bid, sl, tp, "TITAN SELL")) {
        TradesOpened++;
        if (EnableLogging) {
            Log("SELL Trade opened - Lot: " + DoubleToString(LotSize, 2) + 
                " | TP: " + DoubleToString(tp, _Digits) + 
                " | SL: " + DoubleToString(sl, _Digits));
        }
    } else {
        Print("ERROR: Failed to open SELL trade - Error: ", GetLastError());
    }
}

//+------------------------------------------------------------------+
//| Count Open Positions                                              |
//+------------------------------------------------------------------+
int CountOpenPositions() {
    int count = 0;
    
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (positionInfo.SelectByIndex(i)) {
            if (positionInfo.Symbol() == _Symbol && 
                positionInfo.Magic() == trade.GetMagicNumber()) {
                count++;
            }
        }
    }
    
    return count;
}

//+------------------------------------------------------------------+
//| Generate Trading Signal (Placeholder)                            |
//+------------------------------------------------------------------+
int GenerateSignal() {
    // Placeholder for signal generation
    // Replace with actual trading logic
    return 0;
}

//+------------------------------------------------------------------+
//| Update Trailing Stops                                             |
//+------------------------------------------------------------------+
void UpdateTrailingStops() {
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (positionInfo.SelectByIndex(i)) {
            if (positionInfo.Symbol() != _Symbol) continue;
            if (positionInfo.Magic() != trade.GetMagicNumber()) continue;
            
            double currentPrice = (positionInfo.PositionType() == POSITION_TYPE_BUY) ? 
                                 SymbolInfoDouble(_Symbol, SYMBOL_BID) : 
                                 SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            
            double currentSL = positionInfo.StopLoss();
            double newSL = currentPrice - (TrailingStop * _Point);
            
            if (positionInfo.PositionType() == POSITION_TYPE_BUY && 
                newSL > currentSL) {
                trade.PositionModify(positionInfo.Ticket(), newSL, positionInfo.TakeProfit());
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Helper: Get Trade Direction Text                                 |
//+------------------------------------------------------------------+
string GetTradeDirectionText(TRADE_DIRECTION dir) {
    switch(dir) {
        case TRADE_BUY_ONLY:  return "BUY Only";
        case TRADE_SELL_ONLY: return "SELL Only";
        case TRADE_BOTH:      return "BOTH Directions";
        default:              return "Unknown";
    }
}

//+------------------------------------------------------------------+
//| Logging Function                                                  |
//+------------------------------------------------------------------+
void Log(string message) {
    Print("[TITAN] " + message);
    // Optional: Log to file
    // FileWrite(FileOpen(LOG_FILE, FILE_WRITE|FILE_CSV), TimeLocal(), message);
}

//+------------------------------------------------------------------+
//| OnStart - For testing in Strategy Tester                          |
//+------------------------------------------------------------------+
void OnStart() {
    Print("TITAN EA - Strategy Tester Mode");
}