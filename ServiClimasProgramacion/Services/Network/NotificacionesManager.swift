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

    /// A qué pantalla llevar al usuario cuando toca la notificación. `nil`
    /// significa que la notificación es solo informativa (no navega a nada).
    enum Pantalla: String {
        case misSolicitudes
        case admin
    }

    /// Clave usada en `userInfo` para guardar el destino; la lee
    /// `AppDelegate` cuando el usuario toca la notificación.
    static let clavePantalla = "pantalla"

    private static func solicitarPermisoYProgramar(_ solicitud: UNNotificationRequest) {
        let centro = UNUserNotificationCenter.current()
        centro.requestAuthorization(options: [.alert, .sound, .badge]) { concedido, _ in
            guard concedido else { return }
            centro.add(solicitud)
        }
    }

    private static func construirContenido(titulo: String, mensaje: String, pantalla: Pantalla?) -> UNMutableNotificationContent {
        let contenido = UNMutableNotificationContent()
        contenido.title = titulo
        contenido.body = mensaje
        contenido.sound = .default
        if let pantalla {
            contenido.userInfo = [clavePantalla: pantalla.rawValue]
        }
        return contenido
    }

    /// Notificación casi inmediata (unos segundos después de confirmar).
    /// `pantalla` indica a dónde navegar si el usuario la toca (opcional).
    static func notificarInmediata(titulo: String, mensaje: String, pantalla: Pantalla? = nil) {
        let contenido = construirContenido(titulo: titulo, mensaje: mensaje, pantalla: pantalla)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let solicitud = UNNotificationRequest(identifier: UUID().uuidString, content: contenido, trigger: trigger)
        solicitarPermisoYProgramar(solicitud)
    }

    /// Notificación programada un día antes de `fechaCita`. Si faltan menos de
    /// 24 horas para la cita, se dispara de inmediato como respaldo (para que
    /// nunca se pierda el aviso). `pantalla` indica a dónde navegar si el
    /// usuario la toca (opcional).
    static func notificarUnDiaAntes(fechaCita: Date, titulo: String, mensaje: String, pantalla: Pantalla? = nil) {
        let fechaAviso = Calendar.current.date(byAdding: .day, value: -1, to: fechaCita) ?? fechaCita

        guard fechaAviso > Date() else {
            notificarInmediata(titulo: titulo, mensaje: mensaje, pantalla: pantalla)
            return
        }

        let contenido = construirContenido(titulo: titulo, mensaje: mensaje, pantalla: pantalla)
        let componentes = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fechaAviso)
        let trigger = UNCalendarNotificationTrigger(dateMatching: componentes, repeats: false)
        let solicitud = UNNotificationRequest(identifier: UUID().uuidString, content: contenido, trigger: trigger)
        solicitarPermisoYProgramar(solicitud)
    }
}
