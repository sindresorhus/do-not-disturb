// swift-tools-version:5.5
import PackageDescription

let package = Package(
	name: "DoNotDisturb",
	platforms: [
		.macOS(.v10_10)
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
