## StrapperLog Class

### Overview
A class representing a log entry from the Strapper database.

### Properties

| Property    | Type             | Description                                       |
| ----------- | ---------------- | ------------------------------------------------- |
| `Id`        | int              | The ID of the log message in its table.           |
| `Level`     | StrapperLogLevel | The log level that was set for the message.       |
| `Message`   | string           | The body of the log entry.                        |
| `Timestamp` | datetime         | The date and time that the log entry was entered. |