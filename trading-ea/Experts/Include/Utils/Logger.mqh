// Logger.mqh

#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

// Function to log messages
void LogMessage(string message) {
    Print("LOG: ", message);
}

// Function to log errors
void LogError(string error) {
    Print("ERROR: ", error);
}

#endif // __LOGGER_MQH__