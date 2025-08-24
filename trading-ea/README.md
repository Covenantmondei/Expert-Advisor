# Trading EA

## Overview
This project is an Expert Advisor (EA) developed in MQL5 that allows for flexible input of different trading strategies based on price-based logic. The EA integrates various logic blocks such as breakout, reversal, and candlestick patterns to facilitate automated trading.

## Project Structure
```
trading-ea
├── Experts
│   ├── ea.mq5
│   └── Include
│       ├── Strategy
│       │   ├── Breakout.mqh
│       │   ├── Reversal.mqh
│       │   └── CandlePattern.mqh
│       ├── Trade
│       │   ├── TradeManager.mqh
│       │   └── OrderManager.mqh
│       └── Utils
│           ├── Logger.mqh
│           └── Common.mqh
├── Libraries
│   └── CustomIndicators.mqh
└── README.md
```

## Setup Instructions
1. Copy the `trading-ea` folder to your MQL5 `Experts` directory.
2. Open the `ea.mq5` file in your MetaEditor.
3. Compile the EA to ensure there are no errors.
4. Attach the EA to a chart in the MetaTrader platform.

## Usage Guidelines
- The EA can be configured to use different strategies by modifying the parameters in the `ea.mq5` file.
- Each strategy module (Breakout, Reversal, CandlePattern) can be enabled or disabled as needed.

## Strategies Implemented
- **Breakout Strategy**: Identifies breakout conditions and executes trades based on those conditions.
- **Reversal Strategy**: Detects reversal patterns and manages trades accordingly.
- **Candlestick Pattern Strategy**: Analyzes candlestick formations and triggers trades based on identified patterns.

## Logging and Debugging
- The EA includes logging functionality to help with debugging. Check the logs for messages and errors during execution.

## Custom Indicators
- The EA can utilize custom indicators defined in `Libraries/CustomIndicators.mqh` to enhance trading decisions.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.