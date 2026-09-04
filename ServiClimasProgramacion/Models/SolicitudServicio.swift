import Foundation

/// Contrato común para los datos de cualquier solicitud (Mantenimiento,
/// Instalación, Reparación o Compra de aire), para que una sola pantalla de
/// confirmación pueda mostrar el resumen de cualquiera de los 4 servicios
/// sin duplicar código por cada uno.
protocol SolicitudServicio {
    /// Nombre del servicio, para el título de la pantalla de confirmación.
    var tituloServicio: String { get }

    /// Pares (etiqueta, valor) que se muestran en el resumen, en orden.
    var resumen: [(titulo: String, valor: String)] { get }

    /// Fecha/hora de la cita, si el servicio agenda una visita. `nil` si no aplica
    /// (por ejemplo, Compra de aire no agenda cita).
    var fechaCita: Date? { get }
}
