import Foundation

struct SolicitudInstalacion: SolicitudServicio {
    let capacidad: String
    let tipoLugar: String
    let piso: String
    let fechaHoraCita: Date
    let metodoPago: MetodoPago

    var tituloServicio: String { "Instalación" }
    var fechaCita: Date? { fechaHoraCita }

    var resumen: [(titulo: String, valor: String)] {
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_MX")
        formato.dateStyle = .long
        formato.timeStyle = .short

        return [
            ("Capacidad", capacidad),
            ("Tipo de lugar", tipoLugar),
            ("Piso", piso),
            ("Fecha y hora de la cita", formato.string(from: fechaHoraCita)),
            ("Método de pago", metodoPago.descripcion)
        ]
    }
}
