// filepath: trading-ea/Experts/Include/Strategy/CandlePattern.mqh

// This file implements candlestick pattern recognition logic.
// It exports functions to analyze candlestick formations and trigger trades based on identified patterns.

class CCandlePattern {
public:
    // Function to check for a bullish engulfing pattern
    bool IsBullishEngulfing(double open1, double close1, double open2, double close2) {
        return (close1 < open1 && close2 > open2 && close2 > close1 && open2 < close1);
    }

    // Function to check for a bearish engulfing pattern
    bool IsBearishEngulfing(double open1, double close1, double open2, double close2) {
        return (close1 > open1 && close2 < open2 && close2 < close1 && open2 > close1);
    }

    // Function to check for a hammer pattern
    bool IsHammer(double open, double close, double low, double high) {
        double body = MathAbs(close - open);
        double range = high - low;
        return (body <= range * 0.3 && (high - MathMax(open, close)) >= body * 2);
    }

    // Function to check for a shooting star pattern
    bool IsShootingStar(double open, double close, double low, double high) {
        double body = MathAbs(close - open);
        double range = high - low;
        return (body <= range * 0.3 && (MathMin(open, close) - low) >= body * 2);
    }
};

class EnhancedPatternStrategy : public IStrategy
{
private:
    int trendPeriod;         // Period for trend detection
    int patternPeriod;       // Period for pattern detection
    double stopLossPoints;    
    double takeProfitPoints;
    double minBodySize;      // Minimum candle body size
    
public:
    EnhancedPatternStrategy(int _trendPeriod, int _patternPeriod, double _sl, double _tp, double _minBodySize)
    {
        trendPeriod = _trendPeriod;
        patternPeriod = _patternPeriod;
        stopLossPoints = _sl;
        takeProfitPoints = _tp;
        minBodySize = _minBodySize;
    }

    virtual bool ShouldEnterLong()
    {
        // Only enter long if we're in a downtrend (for reversal) or uptrend (for continuation)
        int currentTrend = DetectTrend();
        if(currentTrend == 0) return false; // No clear trend
        
        // Check for bullish patterns
        if(IsBullishEngulfing() || 
           IsBullishHarami() || 
           IsMorningStar() || 
           IsBullishThreeWhiteSoldiers() ||
           IsBullishPiercingLine())
        {
            return true;
        }
        return false;
    }
    
    virtual bool ShouldEnterShort()
    {
        // Only enter short if we're in an uptrend (for reversal) or downtrend (for continuation)
        int currentTrend = DetectTrend();
        if(currentTrend == 0) return false; // No clear trend
        
        // Check for bearish patterns
        if(IsBearishEngulfing() || 
           IsBearishHarami() || 
           IsEveningStar() || 
           IsBearishThreeBlackCrows() ||
           IsBearishDarkCloudCover())
        {
            return true;
        }
        return false;
    }

private:
    // Enhanced Trend Detection Methods
    int DetectTrend()
    {
        // Combine multiple trend detection methods
        int emaTrend = DetectEMATrend();
        int adxTrend = DetectADXTrend();
        int macdTrend = DetectMACDTrend();
        
        // If majority of indicators agree on trend direction
        int trendSum = emaTrend + adxTrend + macdTrend;
        if(trendSum >= 2) return 1;  // Uptrend
        if(trendSum <= -2) return -1; // Downtrend
        return 0; // No clear trend
    }
    
    int DetectEMATrend()
    {
        double ema20 = iMA(Symbol(), Period(), 20, 0, MODE_EMA, PRICE_CLOSE, 0);
        double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
        
        if(ema20 > ema50) return 1;  // Uptrend
        if(ema20 < ema50) return -1; // Downtrend
        return 0;
    }
    
    int DetectADXTrend()
    {
        double adx = iADX(Symbol(), Period(), 14, PRICE_CLOSE, MODE_MAIN, 0);
        double plusDI = iADX(Symbol(), Period(), 14, PRICE_CLOSE, MODE_PLUSDI, 0);
        double minusDI = iADX(Symbol(), Period(), 14, PRICE_CLOSE, MODE_MINUSDI, 0);
        
        if(adx > 25) // Strong trend
        {
            if(plusDI > minusDI) return 1;  // Uptrend
            if(plusDI < minusDI) return -1; // Downtrend
        }
        return 0;
    }
    
    int DetectMACDTrend()
    {
        double macd = iMACD(Symbol(), Period(), 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
        double signal = iMACD(Symbol(), Period(), 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, 0);
        
        if(macd > signal && macd > 0) return 1;  // Uptrend
        if(macd < signal && macd < 0) return -1; // Downtrend
        return 0;
    }

    // Enhanced Candlestick Pattern Methods
    bool IsMorningStar()
    {
        double open1 = iOpen(Symbol(), Period(), 3);
        double close1 = iClose(Symbol(), Period(), 3);
        double open2 = iOpen(Symbol(), Period(), 2);
        double close2 = iClose(Symbol(), Period(), 2);
        double open3 = iOpen(Symbol(), Period(), 1);
        double close3 = iClose(Symbol(), Period(), 1);
        
        bool firstBearish = close1 < open1;
        bool smallBody = MathAbs(open2 - close2) < minBodySize * _Point;
        bool thirdBullish = close3 > open3;
        bool gapDown = MathMax(open2, close2) < MathMin(open1, close1);
        bool gapUp = MathMin(open3, close3) > MathMax(open2, close2);
        
        return firstBearish && smallBody && thirdBullish && gapDown && gapUp;
    }
    
    bool IsEveningStar()
    {
        double open1 = iOpen(Symbol(), Period(), 3);
        double close1 = iClose(Symbol(), Period(), 3);
        double open2 = iOpen(Symbol(), Period(), 2);
        double close2 = iClose(Symbol(), Period(), 2);
        double open3 = iOpen(Symbol(), Period(), 1);
        double close3 = iClose(Symbol(), Period(), 1);
        
        bool firstBullish = close1 > open1;
        bool smallBody = MathAbs(open2 - close2) < minBodySize * _Point;
        bool thirdBearish = close3 < open3;
        bool gapUp = MathMin(open2, close2) > MathMax(open1, close1);
        bool gapDown = MathMax(open3, close3) < MathMin(open2, close2);
        
        return firstBullish && smallBody && thirdBearish && gapUp && gapDown;
    }
    
    bool IsBullishHarami()
    {
        double open1 = iOpen(Symbol(), Period(), 2);
        double close1 = iClose(Symbol(), Period(), 2);
        double open2 = iOpen(Symbol(), Period(), 1);
        double close2 = iClose(Symbol(), Period(), 1);
        
        return (close1 < open1) && // First candle bearish
               (close2 > open2) && // Second candle bullish
               (open2 > close1) && // Second candle opens above first close
               (close2 < open1);   // Second candle closes below first open
    }
    
    bool IsBearishHarami()
    {
        double open1 = iOpen(Symbol(), Period(), 2);
        double close1 = iClose(Symbol(), Period(), 2);
        double open2 = iOpen(Symbol(), Period(), 1);
        double close2 = iClose(Symbol(), Period(), 1);
        
        return (close1 > open1) && // First candle bullish
               (close2 < open2) && // Second candle bearish
               (open2 < close1) && // Second candle opens below first close
               (close2 > open1);   // Second candle closes above first open
    }
    
    bool IsBullishThreeWhiteSoldiers()
    {
        for(int i = 1; i <= 3; i++)
        {
            if(iClose(Symbol(), Period(), i) <= iOpen(Symbol(), Period(), i))
                return false; // Must be bullish candles
            
            if(i > 1)
            {
                // Each candle should open within previous candle's body
                if(iOpen(Symbol(), Period(), i) < iOpen(Symbol(), Period(), i+1))
                    return false;
                    
                // Each candle should close higher than previous
                if(iClose(Symbol(), Period(), i) <= iClose(Symbol(), Period(), i+1))
                    return false;
            }
        }
        return true;
    }
    
    bool IsBearishThreeBlackCrows()
    {
        for(int i = 1; i <= 3; i++)
        {
            if(iClose(Symbol(), Period(), i) >= iOpen(Symbol(), Period(), i))
                return false; // Must be bearish candles
            
            if(i > 1)
            {
                // Each candle should open within previous candle's body
                if(iOpen(Symbol(), Period(), i) > iOpen(Symbol(), Period(), i+1))
                    return false;
                    
                // Each candle should close lower than previous
                if(iClose(Symbol(), Period(), i) >= iClose(Symbol(), Period(), i+1))
                    return false;
            }
        }
        return true;
    }
};