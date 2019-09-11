// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "do-not-disturb",
	platforms: [
		.macOS(.v10_10)
	],
	targets: [
		.target(
			name: "do-not-disturb"
		)
	]
)
