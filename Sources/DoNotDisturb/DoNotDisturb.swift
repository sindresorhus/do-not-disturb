import Cocoa

public struct DoNotDisturb {
	private static let appId = "com.apple.notificationcenterui" as CFString

	private static func set(_ key: String, value: CFPropertyList?) {
		CFPreferencesSetValue(key as CFString, value, appId, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
	}

	private static func commitChanges() {
		CFPreferencesSynchronize(appId, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
		DistributedNotificationCenter.default().postNotificationName(Notification.Name("com.apple.notificationcenterui.dndprefs_changed"), object: nil, deliverImmediately: true)
	}

	private static func restartNotificationCenter() {
		NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.notificationcenterui").first?.forceTerminate()
	}

	private static func enable() {
		guard !isEnabled else {
			return
		}

		set("doNotDisturb", value: true as CFPropertyList)
		set("doNotDisturbDate", value: Date() as CFPropertyList)
		commitChanges()
		restartNotificationCenter()
	}

	private static func disable() {
		guard isEnabled else {
			return
		}

		set("doNotDisturb", value: false as CFPropertyList)
		set("doNotDisturbDate", value: nil)
		commitChanges()
		restartNotificationCenter()
		restoreMenubarIcon()
	}

	private static func restoreMenubarIcon() {
		set("dndStart", value: 0 as CFPropertyList)
		set("dndEnd", value: 1440 as CFPropertyList)

		// We need to sleep for a little bit, otherwise it doesn't take effect.
		// It works with 0.3, but not with 0.2, so we're using 0.4 just to be sure.
		sleep(for: 0.4)

		set("dndStart", value: nil)
		set("dndEnd", value: nil)
		commitChanges()
	}

	static var isEnabled: Bool {
		get {
			CFPreferencesGetAppBooleanValue("doNotDisturb" as CFString, appId, nil)
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
