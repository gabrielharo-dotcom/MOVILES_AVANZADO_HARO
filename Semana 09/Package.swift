// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BoletaModelo",
    platforms: [.macOS(.v13)],
    products: [.library(name: "BoletaModelo", targets: ["BoletaModelo"])],
    targets: [
        .target(name: "BoletaModelo", path: "BoletaPago/BoletaPago/Modelo"),
        .testTarget(name: "BoletaModeloTests", dependencies: ["BoletaModelo"], path: "Pruebas")
    ]
)
