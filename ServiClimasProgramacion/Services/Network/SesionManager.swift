import FirebaseAuth

/// Resultado de intentar iniciar sesión. `.segundoFactorRequerido` aparece
/// cuando la cuenta tiene activada la verificación en dos pasos: la
/// contraseña ya fue correcta, pero Firebase todavía no deja entrar hasta
/// confirmar el código de 6 dígitos de la app autenticadora (Google
/// Authenticator, Authy, etc.).
enum ResultadoInicioSesion {
    case exito
    case segundoFactorRequerido(MultiFactorResolver)
    case error(Error)
}

/// Maneja el registro, inicio y cierre de sesión usando Firebase Authentication.
/// Las cuentas y contraseñas ya no se guardan localmente: viven en Firebase.
enum SesionManager {

    static func registrar(
        nombre: String,
        correo: String,
        contrasena: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print("🆕 [SesionManager] registrar -> creando cuenta en Firebase Auth para \(correo)")

        Auth.auth().createUser(withEmail: correo, password: contrasena) { resultado, error in
            if let error {
                logError("registrar (createUser)", correo: correo, error: error)
                completion(.failure(error))
                return
            }

            print("🆕 [SesionManager] registrar -> cuenta creada (uid: \(resultado?.user.uid ?? "?")), guardando nombre de perfil")

            let cambioPerfil = resultado?.user.createProfileChangeRequest()
            cambioPerfil?.displayName = nombre
            cambioPerfil?.commitChanges { errorPerfil in
                if let errorPerfil {
                    logError("registrar (commitChanges)", correo: correo, error: errorPerfil)
                    completion(.failure(errorPerfil))
                } else {
                    print("🆕 [SesionManager] registrar -> perfil actualizado correctamente para \(correo)")
                    completion(.success(()))
                }
            }
        }
    }

    static func iniciarSesion(
        correo: String,
        contrasena: String,
        completion: @escaping (ResultadoInicioSesion) -> Void
    ) {
        Auth.auth().signIn(withEmail: correo, password: contrasena) { _, error in
            guard let error else {
                completion(.exito)
                return
            }

            let nsError = error as NSError
            if nsError.code == AuthErrorCode.secondFactorRequired.rawValue,
               let resolver = nsError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as? MultiFactorResolver {
                completion(.segundoFactorRequerido(resolver))
            } else {
                completion(.error(error))
            }
        }
    }

    static func cerrarSesion() {
        try? Auth.auth().signOut()
    }

    /// Manda el correo real de verificación de Firebase a la cuenta actual.
    static func enviarVerificacionCorreo(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let usuario = Auth.auth().currentUser else {
            print("✉️ [SesionManager] enviarVerificacionCorreo -> no hay currentUser, no se puede enviar")
            completion(.failure(errorSinSesion()))
            return
        }

        let correo = usuario.email ?? "(sin correo)"
        print("✉️ [SesionManager] enviarVerificacionCorreo -> pidiendo a Firebase que envíe el correo a \(correo) (uid: \(usuario.uid))")

        usuario.sendEmailVerification { error in
            if let error {
                logError("enviarVerificacionCorreo", correo: correo, error: error)
                completion(.failure(error))
            } else {
                print("✉️ [SesionManager] enviarVerificacionCorreo -> Firebase ACEPTÓ la solicitud para \(correo). Si no llega, revisa spam/promociones y la plantilla en Firebase Console.")
                completion(.success(()))
            }
        }
    }

    /// Log uniforme con todos los datos del error para poder diagnosticar
    /// correos que "no llegan" (casi siempre es un error silencioso de
    /// Firebase — cuota, demasiados intentos, o red — que nunca se mostró).
    private static func logError(_ operacion: String, correo: String, error: Error) {
        let nsError = error as NSError
        print("""
        ❌ [SesionManager] \(operacion) FALLÓ para \(correo)
           dominio: \(nsError.domain)
           código: \(nsError.code) (\(String(describing: AuthErrorCode(rawValue: nsError.code))))
           descripción: \(nsError.localizedDescription)
           userInfo: \(nsError.userInfo)
        """)
    }

    /// Refresca los datos de la cuenta actual para saber si ya se confirmó el correo.
    static func recargarUsuario(completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().currentUser?.reload { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    /// Manda el correo real de recuperación de contraseña de Firebase Auth
    /// (Auth.auth().sendPasswordReset). Firebase se encarga de generar el
    /// enlace seguro y de la página donde el usuario define su nueva contraseña.
    static func enviarRecuperacionContrasena(correo: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: correo) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Verificación en dos pasos (TOTP / Firebase Multi-Factor Auth)
    //
    // TOTP = código de 6 dígitos que cambia cada 30 segundos, generado por una
    // app autenticadora (Google Authenticator, Microsoft Authenticator, Authy,
    // o hasta Contraseñas/Llavero de iOS). A diferencia del SMS, esto NO manda
    // ningún mensaje — es puramente criptográfico — así que no tiene costo y
    // no debería requerir el plan de pago "Blaze" de Firebase. Solo hay que
    // activar "Multi-factor authentication" en Firebase Console → Authentication
    // → Sign-in method y elegir "Authenticator apps (TOTP)".

    /// true si la cuenta actual ya tiene la verificación en dos pasos activada.
    static var tieneVerificacionDosPasos: Bool {
        !(Auth.auth().currentUser?.multiFactor.enrolledFactors.isEmpty ?? true)
    }

    /// Paso 1 para ACTIVAR la verificación en dos pasos por primera vez: le pide
    /// a Firebase una clave secreta nueva. Con ella se genera el código QR que
    /// el usuario escanea desde su app autenticadora (o la escribe a mano).
    static func generarSecretoDosPasos(completion: @escaping (Result<TOTPSecret, Error>) -> Void) {
        guard let usuario = Auth.auth().currentUser else {
            completion(.failure(errorSinSesion()))
            return
        }

        usuario.multiFactor.getSessionWithCompletion { session, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let session else {
                completion(.failure(self.errorSinSesion()))
                return
            }

            TOTPMultiFactorGenerator.generateSecret(with: session) { secreto, error in
                if let error {
                    completion(.failure(error))
                } else if let secreto {
                    completion(.success(secreto))
                }
            }
        }
    }

    /// Paso 2 para activar la verificación en dos pasos: confirma con el
    /// código de 6 dígitos que la app autenticadora ya está generando bien,
    /// y deja activada la verificación en dos pasos para la cuenta.
    static func confirmarInscripcionDosPasos(
        secreto: TOTPSecret,
        codigo: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let asercion = TOTPMultiFactorGenerator.assertionForEnrollment(with: secreto, oneTimePassword: codigo)

        Auth.auth().currentUser?.multiFactor.enroll(with: asercion, displayName: "App autenticadora") { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    /// Durante el LOGIN: cuando `iniciarSesion` regresa `.segundoFactorRequerido`,
    /// termina el inicio de sesión con el código de 6 dígitos que el usuario lee
    /// en ese momento desde su app autenticadora.
    static func confirmarSegundoFactor(
        resolver: MultiFactorResolver,
        codigo: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let pista = resolver.hints.first(where: { $0.factorID == PhoneMultiFactorInfo.TOTPMultiFactorID }) else {
            completion(.failure(NSError(
                domain: "SesionManager",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Esta cuenta no tiene una app autenticadora inscrita."]
            )))
            return
        }

        let asercion = TOTPMultiFactorGenerator.assertionForSignIn(withEnrollmentID: pista.uid, oneTimePassword: codigo)

        resolver.resolveSignIn(with: asercion) { _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    private static func errorSinSesion() -> Error {
        NSError(
            domain: "SesionManager",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "No hay una sesión activa."]
        )
    }

    static var correoVerificado: Bool {
        Auth.auth().currentUser?.isEmailVerified ?? false
    }

    static var nombreUsuarioActual: String {
        Auth.auth().currentUser?.displayName ?? "Usuario"
    }

    /// Traduce los errores más comunes de Firebase Auth a mensajes en español.
    static func mensajeError(_ error: Error) -> String {
        guard let codigo = AuthErrorCode(rawValue: (error as NSError).code) else {
            return "Ocurrió un problema. Intenta de nuevo."
        }

        switch codigo {
        case .emailAlreadyInUse:
            return "Ya existe una cuenta registrada con ese correo."
        case .invalidEmail:
            return "El correo electrónico no es válido."
        case .weakPassword:
            return "La contraseña es demasiado débil."
        case .wrongPassword, .invalidCredential:
            return "El correo o la contraseña son incorrectos."
        case .userNotFound:
            return "No existe una cuenta con ese correo."
        case .networkError:
            return "Hubo un problema de conexión a internet. Intenta de nuevo."
        case .tooManyRequests:
            return "Hiciste demasiados intentos. Espera unos minutos y vuelve a intentarlo."
        case .invalidVerificationCode:
            return "El código no es correcto. Revisa que tu app autenticadora tenga la hora bien sincronizada e intenta de nuevo."
        case .sessionExpired:
            return "El código expiró. Espera a que tu app autenticadora genere uno nuevo e inténtalo de nuevo."
        case .secondFactorAlreadyEnrolled:
            return "Ya tienes la verificación en dos pasos activada en esta cuenta."
        case .maximumSecondFactorCountExceeded:
            return "Ya tienes el máximo de segundos factores permitidos en esta cuenta."
        default:
            return "Ocurrió un problema. Intenta de nuevo."
        }
    }
}
