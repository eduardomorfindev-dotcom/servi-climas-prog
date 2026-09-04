import UserNotifications

/// Envía notificaciones locales para simular el aviso al cliente y al dueño
/// del negocio.
///
/// IMPORTANTE (simulación): las notificaciones locales de iOS solo se disparan
/// en el mismo dispositivo donde se agendaron. Como esta app no tiene backend
/// ni servidor de notificaciones push, no es posible avisar de verdad al
/// celular del dueño desde el celular del cliente. Para efectos de esta
/// demostración, ambas notificaciones ("cliente" y "dueño") se programan en
/// el mismo dispositivo, una detrás de otra.
enum NotificacionesManager {

    private static func solicitarPermisoYProgramar(_ solicitud: UNNotificationRequest) {
        let centro = UNUserNotificationCenter.current()
        centro.requestAuthorization(options: [.alert, .sound, .badge]) { concedido, _ in
            guard concedido else { return }
            centro.add(solicitud)
        }
    }

    private static func construirContenido(titulo: String, mensaje: String) -> UNMutableNotificationContent {
        let contenido = UNMutableNotificationContent()
        contenido.title = titulo
        contenido.body = mensaje
        contenido.sound = .default
        return contenido
    }

    /// Notificación casi inmediata (unos segundos después de confirmar).
    static func notificarInmediata(titulo: String, mensaje: String) {
        let contenido = construirContenido(titulo: titulo, mensaje: mensaje)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let solicitud = UNNotificationRequest(identifier: UUID().uuidString, content: contenido, trigger: trigger)
        solicitarPermisoYProgramar(solicitud)
    }

    /// Notificación programada un día antes de `fechaCita`. Si faltan menos de
    /// 24 horas para la cita, se dispara de inmediato como respaldo (para que
    /// nunca se pierda el aviso).
    static func notificarUnDiaAntes(fechaCita: Date, titulo: String, mensaje: String) {
        let fechaAviso = Calendar.current.date(byAdding: .day, value: -1, to: fechaCita) ?? fechaCita

        guard fechaAviso > Date() else {
            notificarInmediata(titulo: titulo, mensaje: mensaje)
            return
        }

        let contenido = construirContenido(titulo: titulo, mensaje: mensaje)
        let componentes = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fechaAviso)
        let trigger = UNCalendarNotificationTrigger(dateMatching: componentes, repeats: false)
        let solicitud = UNNotificationRequest(identifier: UUID().uuidString, content: contenido, trigger: trigger)
        solicitarPermisoYProgramar(solicitud)
    }
}
