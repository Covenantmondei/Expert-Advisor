// Breakout.mqh
// This file defines the breakout strategy logic.

#ifndef __BREAKOUT_MQH__
#define __BREAKOUT_MQH__

class BreakoutStrategy : public IStrategy
{
private:
    int lookbackPeriod;      // Period to look back for high/low
    double stopLossPoints;    // SL in points
    double takeProfitPoints; // TP in points
    double breakoutThreshold; // Minimum breakout size in points
    
public:
    BreakoutStrategy(int _lookback, double _sl, double _tp, double _threshold)
    {
        lookbackPeriod = _lookback;
        stopLossPoints = _sl;
        takeProfitPoints = _tp;
        breakoutThreshold = _threshold;
    }
    
    virtual bool ShouldEnterLong()
    {
        double currentClose = iClose(Symbol(), PERIOD_CURRENT, 0);
        double previousHigh = FindPreviousHigh();
        
        // Enter long if price breaks above previous high by threshold amount
        return (currentClose > previousHigh + breakoutThreshold * _Point);
    }
    
    virtual bool ShouldEnterShort()
    {
        double currentClose = iClose(Symbol(), PERIOD_CURRENT, 0);
        double previousLow = FindPreviousLow();
        
        // Enter short if price breaks below previous low by threshold amount
        return (currentClose < previousLow - breakoutThreshold * _Point);
    }
    
    virtual bool ShouldExitLong()
    {
        double currentClose = iClose(Symbol(), PERIOD_CURRENT, 0);
        double currentLow = iLow(Symbol(), PERIOD_CURRENT, 0);
        
        // Exit if price drops below recent low
        return (currentClose < FindPreviousLow());
    }
    
    virtual bool ShouldExitShort()
    {
        double currentClose = iClose(Symbol(), PERIOD_CURRENT, 0);
        double currentHigh = iHigh(Symbol(), PERIOD_CURRENT, 0);
        
        // Exit if price rises above recent high
        return (currentClose > FindPreviousHigh());
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
    double FindPreviousHigh()
    {
        double highestPrice = iHigh(Symbol(), PERIOD_CURRENT, 1);
        for(int i = 2; i <= lookbackPeriod; i++)
        {
            double high = iHigh(Symbol(), PERIOD_CURRENT, i);
            if(high > highestPrice) highestPrice = high;
        }
        return highestPrice;
    }
    
    double FindPreviousLow()
    {
        double lowestPrice = iLow(Symbol(), PERIOD_CURRENT, 1);
        for(int i = 2; i <= lookbackPeriod; i++)
        {
            double low = iLow(Symbol(), PERIOD_CURRENT, i);
            if(low < lowestPrice) lowestPrice = low;
        }
        return lowestPrice;
    }
};

#endif // __BREAKOUT_MQH__