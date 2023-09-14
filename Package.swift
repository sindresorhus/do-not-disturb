// swift-tools-version:5.9
import PackageDescription

let package = Package(
	name: "DoNotDisturb",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.executable(
			name: "do-not-disturb",
			targets: [
				"DoNotDisturb"
			]
		)
	],
	targets: [
		.executableTarget(
			name: "DoNotDisturb"
		)
	]
)
