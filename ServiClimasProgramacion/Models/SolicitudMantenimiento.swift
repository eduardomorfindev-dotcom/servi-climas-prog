import Foundation

struct SolicitudMantenimiento: SolicitudServicio {
    let tipoEquipo: String
    let tipoMantenimiento: String
    let fecha: Date
    let hora: Date
    let comentario: String
    let metodoPago: MetodoPago

    var tituloServicio: String { "Mantenimiento" }

    var fechaCita: Date? {
        let calendario = Calendar.current
        let componentesFecha = calendario.dateComponents([.year, .month, .day], from: fecha)
        let componentesHora = calendario.dateComponents([.hour, .minute], from: hora)
        var combinados = componentesFecha
        combinados.hour = componentesHora.hour
        combinados.minute = componentesHora.minute
        return calendario.date(from: combinados)
    }

    var resumen: [(titulo: String, valor: String)] {
        let formatoFecha = DateFormatter()
        formatoFecha.locale = Locale(identifier: "es_MX")
        formatoFecha.dateStyle = .long

        let formatoHora = DateFormatter()
        formatoHora.locale = Locale(identifier: "es_MX")
        formatoHora.timeStyle = .short

        return [
            ("Servicio", tipoMantenimiento),
            ("Tipo de equipo", tipoEquipo),
            ("Fecha", formatoFecha.string(from: fecha)),
            ("Horario", formatoHora.string(from: hora)),
            ("Método de pago", metodoPago.descripcion),
            ("Comentario", comentario)
        ]
    }
}
