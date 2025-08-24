// Common.mqh
// This file contains common utility functions used across the EA.
// It exports functions for tasks like data conversion and validation.

double NormalizeDoubleValue(double value, int digits) {
    return NormalizeDouble(value, digits);
}

bool IsValidLotSize(double lotSize) {
    return (lotSize > 0 && lotSize <= AccountFreeMarginCheck(Symbol(), OP_BUY, lotSize));
}

int GetDigits() {
    return (int)MarketInfo(Symbol(), MODE_DIGITS);
}

string FormatDateTime(datetime dt) {
    return TimeToString(dt, TIME_DATE | TIME_MINUTES);
}