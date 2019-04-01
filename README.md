# unilog

![Swift](https://img.shields.io/badge/Swift-5.0-brightgreen.svg)

Swift unified logging made simple.

## Features
- Simplifies the Apple unified logging system
- Ready to be use without the need to set anything up
- Swift like formating, no need for a `NSString` or `printf` format string
- Fallbacks automatically to `NSLog` if running on `El Capitan` (10.11) or early
- Can be customized to log in debug mode just like in release mode
- All parameters are public by default, the way information should be in a log; parameters can be redacted individually
- Private data will remain private and cannot be shown at all, even when flipping the `private_data` flag on
- Simple and small codebase, under 150 LOC

## Instalation
Init a Swift package and add the unilog dependency:
`.package(url: "https://github.com/sivu22/unilog.git", from: "2.0.0")`

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

Sensitive data can be redacted by using the `.mPrivate` access modifier. This achieves the same as the `{private}` modifier of the `os_log` function, with the difference that data cannot be recuperated at a later point, so it's private "forever".
```swift
Log.message("User \(username) with password \(password, modifier: .mPrivate) successfully logged in.")
```
If not specified, the `.mPublic` modifier is used, meaning the above line is identical to:
```swift
Log.message("User \(username, modifier: .mPublic) with password \(password, modifier: .mPrivate) successfully logged in.")
```

Logging this way will use the app bundle identifier as the log subsystem and `App` as the log category. These parameters can be changed at once or individual and at any time during the app's lifetime by calling:
```swift
Log.setCategory(to: "Network", forSubsystem: "com.turtlescompany.scanner")
```

When working in debug mode, it's useful to have the full, public log available. The modifier `.mPrivateRelease` equals to `.mPrivate` in Release mode and to `.mPublic` in Debug mode. Therefore, to have the plaintext user password in Debug mode:
```swift
Log.message("User \(username) with password \(password, modifier: .mPrivateRelease) successfully logged in.")
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

## Contact
Cristian Sava, cristianzsava@gmail.com

## License
unilog is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
