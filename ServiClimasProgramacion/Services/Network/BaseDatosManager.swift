import FirebaseFirestore
import FirebaseAuth

/// Guarda en Firestore el perfil del cliente y cada solicitud de servicio que confirma.
enum BaseDatosManager {

    /// Guarda el perfil del cliente (nombre, correo, teléfono, dirección) en la
    /// colección "usuarios", usando el uid de Firebase Auth como id del documento.
    static func guardarUsuario(nombre: String, correo: String, telefono: String, direccion: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let datos: [String: Any] = [
            "nombre": nombre,
            "correo": correo,
            "telefono": telefono,
            "direccion": direccion,
            "fechaRegistro": Timestamp(date: Date())
        ]

        Firestore.firestore().collection("usuarios").document(uid).setData(datos)
    }

    /// Guarda una solicitud de servicio en la colección "solicitudes", completando
    /// los datos de contacto (teléfono, dirección) desde el perfil guardado del
    /// cliente para que el panel de administración pueda mostrarlos sin cruces manuales.
    static func guardarSolicitud(
        servicio: String,
        resumen: [(titulo: String, valor: String)],
        fechaCita: Date?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(
                domain: "BaseDatosManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No hay una sesión activa."]
            )))
            return
        }

        Firestore.firestore().collection("usuarios").document(uid).getDocument { documento, _ in
            var datos: [String: Any] = [
                "servicio": servicio,
                "fecha": Timestamp(date: Date()),
                "correoUsuario": Auth.auth().currentUser?.email ?? "",
                "nombreUsuario": Auth.auth().currentUser?.displayName ?? "",
                "telefonoUsuario": documento?.get("telefono") as? String ?? "",
                "direccionUsuario": documento?.get("direccion") as? String ?? ""
            ]

            if let fechaCita {
                datos["fechaCita"] = Timestamp(date: fechaCita)
            }

            for dato in resumen {
                datos[dato.titulo] = dato.valor
            }

            Firestore.firestore().collection("solicitudes").addDocument(data: datos) { error in
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    /// Traduce los errores más comunes de Firestore a mensajes en español.
    /// Usa los códigos numéricos de FIRFirestoreErrorCode (estables desde hace
    /// años en el SDK) en vez del enum tipado para no depender de una versión
    /// exacta del SDK.
    static func mensajeError(_ error: Error) -> String {
        let nsError = error as NSError

        switch nsError.code {
        case 7: // permissionDenied
            return "No tienes permiso para guardar esta solicitud. Cierra sesión y vuelve a iniciar sesión; si el problema sigue, es que las reglas de seguridad de Firestore no están publicadas."
        case 16: // unauthenticated
            return "Tu sesión expiró. Cierra sesión y vuelve a iniciar sesión."
        case 14, 4: // unavailable, deadlineExceeded
            return "Hubo un problema de conexión a internet. Verifica tu internet e intenta de nuevo."
        case -1: // sin sesión activa (ver guardarSolicitud)
            return nsError.localizedDescription
        default:
            return "No se pudo guardar tu solicitud (\(nsError.localizedDescription)). Intenta de nuevo."
        }
    }
}
