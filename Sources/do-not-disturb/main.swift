import Cocoa

switch CLI.arguments.first {
case "on":
	DoNotDisturb.isEnabled = true
case "off":
	DoNotDisturb.isEnabled = false
case "toggle":
	DoNotDisturb.isEnabled.toggle()
case "status":
	print(DoNotDisturb.isEnabled ? "on" : "off")
default:
	print("Unsupported command", to: .standardError)
	exit(1)
}
