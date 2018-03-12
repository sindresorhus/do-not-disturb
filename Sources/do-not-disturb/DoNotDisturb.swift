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
		set("dndStart", value: 0 as CFPropertyList)
		set("dndEnd", value: 1440 as CFPropertyList)
		set("doNotDisturb", value: true as CFPropertyList)
		commitChanges()

		// For some reason `doNotDisturb` does not take the first time around
		// TODO: Figure out why
		sleep(for: 0.4)
		set("doNotDisturb", value: true as CFPropertyList)
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
