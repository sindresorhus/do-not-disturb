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
	private static let appId = "com.apple.notificationcenterui" as CFString

	private static func set(_ key: String, value: CFPropertyList?) {
		CFPreferencesSetValue(key as CFString, value, appId, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
	}

	private static func commitChanges() {
		CFPreferencesSynchronize(appId, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		DistributedNotificationCenter.default().postNotificationName(NSNotification.Name("com.apple.notificationcenterui.dndprefs_changed"), object: nil, deliverImmediately: true)
	}

	private static func enable() {
		set("dndStart", value: 0 as CFPropertyList)
		set("dndEnd", value: 1440 as CFPropertyList)
		set("doNotDisturb", value: true as CFPropertyList)
		commitChanges()
	}

	private static func disable() {
		set("dndStart", value: nil)
		set("dndEnd", value: nil)
		set("doNotDisturb", value: false as CFPropertyList)
		commitChanges()
	}

	static var isEnabled: Bool {
		get {
			return CFPreferencesGetAppBooleanValue("doNotDisturb" as CFString, appId, nil)
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
