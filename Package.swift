// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "DeclarativeCore",
	defaultLocalization: "en",
	products: [
		.library(
			name: "DeclarativeCore",
			targets: ["DeclarativeCore"]
		),
	],
	targets: [
		.target(name: "DeclarativeCore"),
	]
)
