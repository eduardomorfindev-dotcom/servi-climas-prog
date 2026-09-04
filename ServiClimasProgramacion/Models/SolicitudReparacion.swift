import Foundation

struct SolicitudReparacion: SolicitudServicio {
    let tipoAire: String
    let sintoma: String
    let comentario: String
    let metodoPago: MetodoPago
    let fechaHoraCita: Date

    var tituloServicio: String { "Reparación" }
    var fechaCita: Date? { fechaHoraCita }

    var resumen: [(titulo: String, valor: String)] {
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_MX")
        formato.dateStyle = .long
        formato.timeStyle = .short

        return [
            ("Tipo de aire", tipoAire),
            ("Síntoma", sintoma),
            ("Comentario", comentario),
            ("Método de pago", metodoPago.descripcion),
            ("Fecha y hora de la cita", formato.string(from: fechaHoraCita))
        ]
    }
}
