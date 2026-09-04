import Foundation

/// Define quién puede entrar al panel de administración.
/// Cambia este correo por el que usa el dueño del negocio para iniciar sesión en la app.
enum AdminConfig {
    static let correoAdmin = "eduardo.morfin.dev@gmail.com"

    static func esAdmin(correo: String?) -> Bool {
        guard let correo else { return false }
        return correo.lowercased() == correoAdmin.lowercased()
    }
}
