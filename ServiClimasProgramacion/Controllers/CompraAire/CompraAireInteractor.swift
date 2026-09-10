import Foundation

/// Reglas de negocio y datos de catálogo de la pantalla "Comprar aire
/// acondicionado". No conoce UIKit ni nada de la pantalla — solo la lógica
/// que sería igual aunque cambiara toda la interfaz.
protocol CompraAireInteractorProtocol: AnyObject {
    var capacidadesSugeridas: [Int] { get }
    var tiposEquipo: [String] { get }

    /// Regla real de refrigeración: los minisplits de más de 1 tonelada
    /// (2, 3, ... toneladas) solo existen en 220V — 110V nada más se
    /// fabrica hasta 1 tonelada.
    func esVoltajeCompatible(conToneladas toneladas: Int, voltaje: String) -> Bool

    func construirSolicitud(
        capacidad: String,
        tipo: String,
        voltaje: String,
        metodoPago: MetodoPago,
        factura: Bool
    ) -> SolicitudCompraAire

    /// Avisa al dueño del negocio de una nueva cotización. El precio
    /// depende del tipo de cambio del dólar, así que solo se notifica a él
    /// para que lo revise antes de contactar al cliente.
    func notificarNuevaCotizacion(_ solicitud: SolicitudCompraAire)
}

final class CompraAireInteractor: CompraAireInteractorProtocol {

    /// Capacidades sugeridas, en toneladas de refrigeración: desde equipos
    /// residenciales chicos (1 tonelada) hasta equipos industriales grandes
    /// (50 toneladas).
    let capacidadesSugeridas: [Int] = Array(1...50)

    /// Tipos de equipo que vende el negocio.
    let tiposEquipo: [String] = [
        "Ventana",
        "Minisplit convencional",
        "Minisplit inverter",
        "Piso techo",
        "Paquete",
        "Manejadoras de aire"
    ]

    func esVoltajeCompatible(conToneladas toneladas: Int, voltaje: String) -> Bool {
        voltaje != "110V" || toneladas <= 1
    }

    func construirSolicitud(
        capacidad: String,
        tipo: String,
        voltaje: String,
        metodoPago: MetodoPago,
        factura: Bool
    ) -> SolicitudCompraAire {
        SolicitudCompraAire(capacidad: capacidad, tipo: tipo, voltaje: voltaje, metodoPago: metodoPago, factura: factura)
    }

    func notificarNuevaCotizacion(_ solicitud: SolicitudCompraAire) {
        NotificacionesManager.notificarInmediata(
            titulo: "Nueva cotización de equipo",
            mensaje: "\(SesionManager.nombreUsuarioActual) quiere cotizar un equipo \(solicitud.tipo) de \(solicitud.capacidad), \(solicitud.voltaje). Revisa el tipo de cambio antes de contactarlo.",
            pantalla: .admin
        )
    }
}
