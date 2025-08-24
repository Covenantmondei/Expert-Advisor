class IStrategy
{
public:
   virtual bool ShouldEnterLong() = 0;
   virtual bool ShouldEnterShort() = 0;
   virtual bool ShouldExitLong() = 0;
   virtual bool ShouldExitShort() = 0;
   virtual double GetStopLoss(ENUM_ORDER_TYPE order_type, double open_price) = 0;
   virtual double GetTakeProfit(ENUM_ORDER_TYPE order_type, double open_price) = 0;
};