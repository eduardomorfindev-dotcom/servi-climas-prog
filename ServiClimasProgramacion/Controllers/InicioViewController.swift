import UIKit
import FirebaseAuth

class InicioViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    let contenidoView = UIView()
    
    let logoImageView = UIImageView(
        image: UIImage(named: "servi")
    )

    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let correoTextField = UITextField()
    let contraseñaTextField = UITextField()

    let iniciarSesionButton = UIButton(type: .system)
    let olvideContrasenaButton = UIButton(type: .system)
    let registrarseButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
        configurarTeclado()
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemBackground

        let gesto = UITapGestureRecognizer(
            target: self,
            action: #selector(cerrarTeclado)
        )
        gesto.cancelsTouchesInView = false
        view.addGestureRecognizer(gesto)
    }

    private func configurarElementos() {
        // LOGO
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = false

        // TÍTULO
        tituloLabel.text = "Servi Climas"
        tituloLabel.font = UIFont(name: "AvenirNext-Bold", size: 32) ?? .boldSystemFont(ofSize: 32)
        tituloLabel.textAlignment = .center
        tituloLabel.textColor = .label

        // DESCRIPCIÓN
        descripcionLabel.text = "Inicia sesión para gestionar tus servicios y citas"
        descripcionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descripcionLabel.textAlignment = .center
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        // CAMPOS
        configurarCampo(campo: correoTextField, placeholder: "Correo electrónico", tipo: .emailAddress)
        configurarCampo(campo: contraseñaTextField, placeholder: "Contraseña", tipo: .default)

        correoTextField.delegate = self
        contraseñaTextField.delegate = self

        contraseñaTextField.textContentType = .password
        contraseñaTextField.agregarBotonOjito()

        // BOTÓN INICIAR SESIÓN
        iniciarSesionButton.setTitle("Iniciar sesión", for: .normal)
        iniciarSesionButton.setTitleColor(.white, for: .normal)
        iniciarSesionButton.backgroundColor = .systemBlue
        iniciarSesionButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        iniciarSesionButton.layer.cornerRadius = 15
        iniciarSesionButton.addTarget(self, action: #selector(iniciarSesionAccion), for: .touchUpInside)

        // BOTÓN OLVIDÉ MI CONTRASEÑA
        olvideContrasenaButton.setTitle("¿Olvidaste tu contraseña?", for: .normal)
        olvideContrasenaButton.setTitleColor(.secondaryLabel, for: .normal)
        olvideContrasenaButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        olvideContrasenaButton.addTarget(self, action: #selector(olvideContrasenaAccion), for: .touchUpInside)

        // BOTÓN REGISTRARSE
        registrarseButton.setTitle("¿No tienes cuenta? Regístrate", for: .normal)
        registrarseButton.setTitleColor(.systemBlue, for: .normal)
        registrarseButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        registrarseButton.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)

        // SCROLL
        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let subviews = [
            logoImageView, tituloLabel, descripcionLabel,
            correoTextField, contraseñaTextField,
            iniciarSesionButton, olvideContrasenaButton, registrarseButton
        ]
        subviews.forEach { contenidoView.addSubview($0) }
    }

    private func configurarCampo(
        campo: UITextField,
        placeholder: String,
        tipo: UIKeyboardType
    ) {
        campo.placeholder = placeholder
        campo.borderStyle = .none
        campo.backgroundColor = .secondarySystemBackground
        campo.layer.cornerRadius = 14
        campo.layer.borderWidth = 1
        campo.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        campo.font = .systemFont(ofSize: 16)
        campo.keyboardType = tipo
        campo.autocapitalizationType = .none
        campo.autocorrectionType = .no

        campo.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        campo.leftViewMode = .always
    }

    private func configurarLayout() {
        let elementos = [
            scrollView, contenidoView,
            logoImageView, tituloLabel, descripcionLabel,
            correoTextField, contraseñaTextField,
            iniciarSesionButton, olvideContrasenaButton, registrarseButton
        ]

        elementos.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contenidoView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contenidoView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contenidoView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contenidoView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contenidoView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            logoImageView.topAnchor.constraint(equalTo: contenidoView.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            tituloLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),

            descripcionLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 8),
            descripcionLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 30),
            descripcionLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -30),

            correoTextField.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 35),
            correoTextField.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            correoTextField.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),
            correoTextField.heightAnchor.constraint(equalToConstant: 52),

            contraseñaTextField.topAnchor.constraint(equalTo: correoTextField.bottomAnchor, constant: 12),
            contraseñaTextField.leadingAnchor.constraint(equalTo: correoTextField.leadingAnchor),
            contraseñaTextField.trailingAnchor.constraint(equalTo: correoTextField.trailingAnchor),
            contraseñaTextField.heightAnchor.constraint(equalToConstant: 52),

            iniciarSesionButton.topAnchor.constraint(equalTo: contraseñaTextField.bottomAnchor, constant: 25),
            iniciarSesionButton.leadingAnchor.constraint(equalTo: correoTextField.leadingAnchor),
            iniciarSesionButton.trailingAnchor.constraint(equalTo: correoTextField.trailingAnchor),
            iniciarSesionButton.heightAnchor.constraint(equalToConstant: 52),

            olvideContrasenaButton.topAnchor.constraint(equalTo: iniciarSesionButton.bottomAnchor, constant: 14),
            olvideContrasenaButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),

            registrarseButton.topAnchor.constraint(equalTo: olvideContrasenaButton.bottomAnchor, constant: 12),
            registrarseButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            registrarseButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -30)
        ])
    }

    private func configurarTeclado() {
        correoTextField.returnKeyType = .next
        contraseñaTextField.returnKeyType = .done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == correoTextField {
            contraseñaTextField.becomeFirstResponder()
        } else if textField == contraseñaTextField {
            textField.resignFirstResponder()
            iniciarSesionAccion()
        }
        return true
    }

    @objc private func cerrarTeclado() {
        view.endEditing(true)
    }

    @objc private func iniciarSesionAccion() {
        let correo = correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let contraseña = contraseñaTextField.text ?? ""

        if correo.isEmpty || contraseña.isEmpty {
            mostrarAlerta(titulo: "Campos vacíos", mensaje: "Ingresa tu correo y contraseña para continuar.")
            return
        }

        iniciarSesionButton.isEnabled = false

        SesionManager.iniciarSesion(correo: correo, contrasena: contraseña) { [weak self] resultado in
            guard let self else { return }
            self.iniciarSesionButton.isEnabled = true

            switch resultado {
            case .exito:
                SesionManager.recargarUsuario { _ in
                    if SesionManager.correoVerificado {
                        self.navigationController?.pushViewController(NuestrosServiciosViewController(), animated: true)
                    } else {
                        let verificacionVC = VerificacionViewController()
                        verificacionVC.correoUsuario = correo
                        self.navigationController?.pushViewController(verificacionVC, animated: true)
                    }
                }
            case .segundoFactorRequerido(let resolver):
                self.iniciarVerificacionDosPasos(resolver: resolver)
            case .error(let error):
                self.mostrarAlerta(titulo: "Datos incorrectos", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    /// La contraseña ya fue correcta, pero la cuenta tiene activada la
    /// verificación en dos pasos: muestra la pantalla para escribir el código
    /// de la app autenticadora antes de dejar entrar de verdad. A diferencia
    /// del SMS, aquí no hay nada que "enviar" primero — el código ya lo está
    /// generando la app del usuario.
    private func iniciarVerificacionDosPasos(resolver: MultiFactorResolver) {
        let pantalla = CodigoAutenticadorViewController(
            confirmarCodigo: { codigo, completion in
                SesionManager.confirmarSegundoFactor(resolver: resolver, codigo: codigo, completion: completion)
            },
            alExito: { [weak self] in
                self?.navigationController?.pushViewController(NuestrosServiciosViewController(), animated: true)
            }
        )
        navigationController?.pushViewController(pantalla, animated: true)
    }

    @objc private func irARegistro() {
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }

    @objc private func olvideContrasenaAccion() {
        let recuperarVC = RecuperarContrasenaViewController()
        recuperarVC.correoInicial = correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        navigationController?.pushViewController(recuperarVC, animated: true)
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
