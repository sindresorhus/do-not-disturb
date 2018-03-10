import Cocoa

extension Bool {
	mutating func toggle() {
		self = !self
	}
}

struct CLI {
	final class StandardErrorTextStream: TextOutputStream {
		func write(_ string: String) {
			FileHandle.standardError.write(string.data(using: .utf8)!)
		}
	}

	static let stdout = FileHandle.standardOutput
	static let stderr = FileHandle.standardError

	private static var _stderr = StandardErrorTextStream()
	static func printErr<T>(_ item: T) {
		Swift.print(item, to: &_stderr)
	}

	static let arguments = Array(CommandLine.arguments.dropFirst(1))
}

struct DoNotDisturb {
	private static func commitChanges() {
		CFPreferencesSynchronize("com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		DistributedNotificationCenter.default().postNotificationName(NSNotification.Name("com.apple.notificationcenterui.dndprefs_changed"), object: nil, deliverImmediately: true)
	}

	private static func enable() {
		CFPreferencesSetValue("dndStart" as CFString, 0 as CFPropertyList, "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		CFPreferencesSetValue("dndEnd" as CFString, 1440 as CFPropertyList, "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		CFPreferencesSetValue("doNotDisturb" as CFString, true as CFPropertyList, "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		commitChanges()
	}

	private static func disable() {
		CFPreferencesSetValue("dndStart" as CFString, nil, "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		CFPreferencesSetValue("dndEnd" as CFString, nil, "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		CFPreferencesSetValue("doNotDisturb" as CFString, false as CFPropertyList, "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		commitChanges()
	}

	static var isEnabled: Bool {
		get {
			return CFPreferencesGetAppBooleanValue("doNotDisturb" as CFString, "com.apple.notificationcenterui" as CFString, nil)
		}
		set {
			if newValue {
				enable()
			} else {
				disable()
			}
		}
	}
}

switch CLI.arguments.first {
case "on"?:
	DoNotDisturb.isEnabled = true
case "off"?:
	DoNotDisturb.isEnabled = false
case "toggle"?:
	DoNotDisturb.isEnabled.toggle()
case "status"?:
	print(DoNotDisturb.isEnabled ? "on" : "off")
default:
	print("Unsupported command")
	exit(1)
}
