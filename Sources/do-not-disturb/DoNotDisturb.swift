import Cocoa

public struct DoNotDisturb {
	private static let appId = "com.apple.notificationcenterui" as CFString

	private static func set(_ key: String, value: CFPropertyList?) {
		CFPreferencesSetValue(key as CFString, value, appId, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
	}

	private static func commitChanges() {
		CFPreferencesSynchronize(appId, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		DistributedNotificationCenter.default().postNotificationName(NSNotification.Name("com.apple.notificationcenterui.dndprefs_changed"), object: nil, deliverImmediately: true)
	}

	private static func enable() {
		set("doNotDisturb", value: true as CFPropertyList)
    set("doNotDisturbDate", value: Date() as CFPropertyList)
		commitChanges()
	}

	private static func disable() {
		set("doNotDisturbDate", value: nil)
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
