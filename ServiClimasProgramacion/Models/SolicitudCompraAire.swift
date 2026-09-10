import Foundation

/// Entity del módulo VIPER "Comprar aire acondicionado" (ver
/// Controllers/CompraAire/): los datos puros de la cotización, sin ninguna
/// dependencia de UIKit ni de las demás capas (View, Presenter, Interactor,
/// Router).
struct SolicitudCompraAire: SolicitudServicio {
    let capacidad: String
    let tipo: String
    let voltaje: String
    let metodoPago: MetodoPago
    let factura: Bool

    var tituloServicio: String { "Compra de aire acondicionado" }

    /// No agenda cita: es una cotización, no una visita.
    var fechaCita: Date? { nil }

    var resumen: [(titulo: String, valor: String)] {
        [
            ("Capacidad", capacidad),
            ("Tipo", tipo),
            ("Voltaje", voltaje),
            ("Método de pago", metodoPago.descripcion),
            ("Factura", factura ? "Sí" : "No")
        ]
    }
}
