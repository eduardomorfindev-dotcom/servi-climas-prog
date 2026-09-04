import Foundation

enum MetodoPago: String {
    case transferencia = "Transferencia"
    case efectivo = "Efectivo"

    var descripcion: String { rawValue }
}
