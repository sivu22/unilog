# unilog
Swift unified logging made simple.

## Features
- Simplifies the Apple unified logging system
- Ready to be use without the need to set anything up
- Swift like formating, no need for a `NSString` or `printf` format string
- Fallbacks automatically to `NSLog` if running on `El Capitan` (10.11) or early
- Can be customized to log in debug mode just like in release mode
- All parameters are public by default, the way information should be in a log; parameters can be redacted individually
- Private data will remain private and cannot be shown at all, even when flipping the `private_data` flag on
- Simple and small codebase, under 200 LOC

## Instalation
Init a Swift package and add the unilog dependency:
`.package(url: "https://github.com/sivu22/unilog.git", from: "1.0.1")`

Add the Swift package to your workspace, click to add Embedded Binaries and select `unilog.framework`.

Import it and we're ready to log:
```swift
import unilog
```

## Usage
Log data by using the default app log:
```swift
Log.message("\(imageName) of type \(uti) and resolution \(width, height) has been loaded")
```

Sensitive data can be redacted by using the `{<}` and `{>}` dedicated delimitors. This achieves the same as the `{private}` scope modifier of the `os_log` function, with the difference that data cannot be recuperated at a later point, so it's private "forever".
```swift
Log.message("User \(username) with password {<}\(password){>} successfully logged in.")
```

Logging this way will use the app bundle identifier as the log subsystem and `App` as the log category. These parameters can be changed at once or individual and at any time during the app's lifetime by calling:
```swift
Log.setCategory(to: "Network", forSubsystem: "com.turtlescompany.scanner")
```

When working in debug mode, all private scope modifiers are ignored, therefore everything is being logged. To obtain the same log that the release build will generate, enable the private scope modifier in debug mode:
```swift
Log.allowPrivateInDebugMode(true)
```

For more complex apps, with multiple subsystems, one log category won't suffice. In that case, instantiate multiple logs as desired:
```swift
let logN = Log(category: "Network")
let logDB = Log(category: "DB")
...
logDB.error("User not found! \(error)")
...
logN.info("Connection to \(server.ip:server.port) established")
```

## Log levels
unilog provides equivalents to all os_log levels with the exception of Fault. It is important to understand the difference between these levels and where are the logs stored in each case. For more information, take a loot at the [Apple documentation.](https://developer.apple.com/documentation/os/logging)

| unilog   | os_log   |
| ---------| ---------|
| info     | Info     |
| debug    | Debug    |
| message  | Default  |
| error    | Error    |

## Disclaimer
Even if extremely unlikely, a private blob of data could contain a certain sequence of characters that would make parts of it public when logged. This can be hopefully addressed with the arrival of Swift 5.

## Contact
Cristian Sava, cristianzsava@gmail.com

## License
unilog is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
