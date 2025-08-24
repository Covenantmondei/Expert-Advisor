class PriceActionStrategy : public IStrategy
{
private:
    int period;
    double stopLossPoints;
    double takeProfitPoints;
    
public:
    PriceActionStrategy(int _period, double _sl, double _tp)
    {
        period = _period;
        stopLossPoints = _sl;
        takeProfitPoints = _tp;
    }
    
    virtual bool ShouldEnterLong()
    {
        // Example: Enter long if current close is higher than previous high
        return iClose(Symbol(), PERIOD_CURRENT, 0) > iHigh(Symbol(), PERIOD_CURRENT, 1);
    }
    
    virtual bool ShouldEnterShort()
    {
        // Example: Enter short if current close is lower than previous low
        return iClose(Symbol(), PERIOD_CURRENT, 0) < iLow(Symbol(), PERIOD_CURRENT, 1);
    }
    
    virtual bool ShouldExitLong()
    {
        // Example: Exit long if current close is lower than previous low
        return iClose(Symbol(), PERIOD_CURRENT, 0) < iLow(Symbol(), PERIOD_CURRENT, 1);
    }
    
    virtual bool ShouldExitShort()
    {
        // Example: Exit short if current close is higher than previous high
        return iClose(Symbol(), PERIOD_CURRENT, 0) > iHigh(Symbol(), PERIOD_CURRENT, 1);
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
};