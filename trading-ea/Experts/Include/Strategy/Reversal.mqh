// filepath: trading-ea/Experts/Include/Strategy/Reversal.mqh

// Reversal Strategy Logic

// Function to detect reversal patterns
bool IsReversalPattern(double currentPrice, double previousHigh, double previousLow) {
    // Logic to identify a reversal pattern based on price action
    // Placeholder for actual implementation
    return false; // Change this based on actual logic
}

// Function to manage trades based on reversal signals
void ManageReversalTrades() {
    // Logic to manage trades when a reversal pattern is detected
    // Placeholder for actual implementation
}

class ReversalStrategy : public IStrategy
{
private:
    int lookbackPeriod;      // Period to look back for trend
    double stopLossPoints;    // SL in points
    double takeProfitPoints; // TP in points
    double candleSize;       // Minimum candle size in points
    
public:
    ReversalStrategy(int _lookback, double _sl, double _tp, double _candleSize)
    {
        lookbackPeriod = _lookback;
        stopLossPoints = _sl;
        takeProfitPoints = _tp;
        candleSize = _candleSize;
    }
    
    virtual bool ShouldEnterLong()
    {
        // Check if we're in a downtrend
        if (!IsDownTrend()) return false;
        
        // Check for bullish reversal pattern
        return (IsBullishEngulfing() || IsBullishHammer());
    }
    
    virtual bool ShouldEnterShort()
    {
        // Check if we're in an uptrend
        if (!IsUpTrend()) return false;
        
        // Check for bearish reversal pattern
        return (IsBearishEngulfing() || IsBearishHammer());
    }
    
    virtual bool ShouldExitLong()
    {
        return IsBearishEngulfing() || IsBearishHammer();
    }
    
    virtual bool ShouldExitShort()
    {
        return IsBullishEngulfing() || IsBullishHammer();
    }
    
    virtual double GetStopLoss(ENUM_ORDER_TYPE order_type, double open_price)
    {
        if(order_type == ORDER_TYPE_BUY)
            return open_price - stopLossPoints * _Point;
        return open_price + stopLossPoints * _Point;
    }
    
    virtual double GetTakeProfit(ENUM_ORDER_TYPE order_type, double open_price)
    {
        if(order_type == ORDER_TYPE_BUY)
            return open_price + takeProfitPoints * _Point;
        return open_price - takeProfitPoints * _Point;
    }
    
private:
    bool IsUpTrend()
    {
        double sum = 0;
        for(int i = 1; i <= lookbackPeriod; i++)
        {
            sum += iClose(Symbol(), PERIOD_CURRENT, i) - iOpen(Symbol(), PERIOD_CURRENT, i);
        }
        return sum > 0;
    }
    
    bool IsDownTrend()
    {
        double sum = 0;
        for(int i = 1; i <= lookbackPeriod; i++)
        {
            sum += iClose(Symbol(), PERIOD_CURRENT, i) - iOpen(Symbol(), PERIOD_CURRENT, i);
        }
        return sum < 0;
    }
    
    bool IsBullishEngulfing()
    {
        double currentOpen = iOpen(Symbol(), PERIOD_CURRENT, 1);
        double currentClose = iClose(Symbol(), PERIOD_CURRENT, 1);
        double previousOpen = iOpen(Symbol(), PERIOD_CURRENT, 2);
        double previousClose = iClose(Symbol(), PERIOD_CURRENT, 2);
        
        // Check candle size
        if(MathAbs(currentClose - currentOpen) < candleSize * _Point) return false;
        
        // Bullish engulfing pattern
        return (previousClose < previousOpen) &&                    // Previous candle is bearish
               (currentClose > currentOpen) &&                      // Current candle is bullish
               (currentOpen < previousClose) &&                     // Current opens below previous close
               (currentClose > previousOpen);                       // Current closes above previous open
    }
    
    bool IsBearishEngulfing()
    {
        double currentOpen = iOpen(Symbol(), PERIOD_CURRENT, 1);
        double currentClose = iClose(Symbol(), PERIOD_CURRENT, 1);
        double previousOpen = iOpen(Symbol(), PERIOD_CURRENT, 2);
        double previousClose = iClose(Symbol(), PERIOD_CURRENT, 2);
        
        // Check candle size
        if(MathAbs(currentClose - currentOpen) < candleSize * _Point) return false;
        
        // Bearish engulfing pattern
        return (previousClose > previousOpen) &&                    // Previous candle is bullish
               (currentClose < currentOpen) &&                      // Current candle is bearish
               (currentOpen > previousClose) &&                     // Current opens above previous close
               (currentClose < previousOpen);                       // Current closes below previous open
    }
    
    bool IsBullishHammer()
    {
        double open = iOpen(Symbol(), PERIOD_CURRENT, 1);
        double high = iHigh(Symbol(), PERIOD_CURRENT, 1);
        double low = iLow(Symbol(), PERIOD_CURRENT, 1);
        double close = iClose(Symbol(), PERIOD_CURRENT, 1);
        
        double bodySize = MathAbs(close - open);
        double upperWick = high - MathMax(open, close);
        double lowerWick = MathMin(open, close) - low;
        
        // Check minimum size
        if(bodySize < candleSize * _Point) return false;
        
        // Hammer properties:
        // 1. Lower wick should be at least 2x the body
        // 2. Upper wick should be small or non-existent
        // 3. Body should be in upper half of the candle
        return (lowerWick > bodySize * 2) &&
               (upperWick < bodySize * 0.5) &&
               (close > open);
    }
    
    bool IsBearishHammer()
    {
        double open = iOpen(Symbol(), PERIOD_CURRENT, 1);
        double high = iHigh(Symbol(), PERIOD_CURRENT, 1);
        double low = iLow(Symbol(), PERIOD_CURRENT, 1);
        double close = iClose(Symbol(), PERIOD_CURRENT, 1);
        
        double bodySize = MathAbs(close - open);
        double upperWick = high - MathMax(open, close);
        double lowerWick = MathMin(open, close) - low;
        
        // Check minimum size
        if(bodySize < candleSize * _Point) return false;
        
        // Inverted Hammer properties:
        // 1. Upper wick should be at least 2x the body
        // 2. Lower wick should be small or non-existent
        // 3. Body should be in lower half of the candle
        return (upperWick > bodySize * 2) &&
               (lowerWick < bodySize * 0.5) &&
               (close < open);
    }
};