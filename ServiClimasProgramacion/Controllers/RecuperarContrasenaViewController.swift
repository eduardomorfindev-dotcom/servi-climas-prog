import UIKit

/// Pantalla de "¿Olvidaste tu contraseña?": pide el correo del usuario y le
/// pide a Firebase Auth (sendPasswordReset) que mande el enlace real para
/// restablecer la contraseña. Firebase genera el enlace y la página donde
/// el usuario define la nueva contraseña; esta app no maneja esa parte.
class RecuperarContrasenaViewController: UIViewController, UITextFieldDelegate {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let iconoImageView = UIImageView()
    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let correoTextField = UITextField()

    let enviarButton = UIButton(type: .system)
    let regresarButton = UIButton(type: .system)

    /// Si se llega aquí desde el login con el correo ya escrito, se precarga.
    var correoInicial: String = ""

    private var segundosParaReenviar = 0
    private var temporizadorReenvio: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
        configurarTeclado()
    }

    deinit {
        temporizadorReenvio?.invalidate()
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
        let configuracionSimbolo = UIImage.SymbolConfiguration(pointSize: 46, weight: .medium)
        iconoImageView.image = UIImage(systemName: "lock.rotation", withConfiguration: configuracionSimbolo)
        iconoImageView.tintColor = .systemBlue
        iconoImageView.contentMode = .scaleAspectFit

        tituloLabel.text = "Recuperar contraseña"
        tituloLabel.font = UIFont(name: "AvenirNext-Bold", size: 28) ?? .boldSystemFont(ofSize: 28)
        tituloLabel.textAlignment = .center
        tituloLabel.textColor = .label

        descripcionLabel.text = "Ingresa el correo con el que te registraste. Te enviaremos un enlace para crear una nueva contraseña."
        descripcionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descripcionLabel.textAlignment = .center
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        configurarCampo(campo: correoTextField, placeholder: "Correo electrónico", tipo: .emailAddress)
        correoTextField.delegate = self
        correoTextField.text = correoInicial

        enviarButton.setTitle("Enviar enlace de recuperación", for: .normal)
        enviarButton.setTitleColor(.white, for: .normal)
        enviarButton.setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
        enviarButton.backgroundColor = .systemBlue
        enviarButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        enviarButton.layer.cornerRadius = 15
        enviarButton.addTarget(self, action: #selector(enviarAccion), for: .touchUpInside)

        regresarButton.setTitle("Regresar a iniciar sesión", for: .normal)
        regresarButton.setTitleColor(.systemBlue, for: .normal)
        regresarButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        regresarButton.addTarget(self, action: #selector(regresarAccion), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let subvistas = [
            iconoImageView, tituloLabel, descripcionLabel,
            correoTextField, enviarButton, regresarButton
        ]
        subvistas.forEach { contenidoView.addSubview($0) }
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
            iconoImageView, tituloLabel, descripcionLabel,
            correoTextField, enviarButton, regresarButton
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

            iconoImageView.topAnchor.constraint(equalTo: contenidoView.topAnchor, constant: 50),
            iconoImageView.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            iconoImageView.heightAnchor.constraint(equalToConstant: 60),

            tituloLabel.topAnchor.constraint(equalTo: iconoImageView.bottomAnchor, constant: 18),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),

            descripcionLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 10),
            descripcionLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 30),
            descripcionLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -30),

            correoTextField.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 30),
            correoTextField.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            correoTextField.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),
            correoTextField.heightAnchor.constraint(equalToConstant: 52),

            enviarButton.topAnchor.constraint(equalTo: correoTextField.bottomAnchor, constant: 22),
            enviarButton.leadingAnchor.constraint(equalTo: correoTextField.leadingAnchor),
            enviarButton.trailingAnchor.constraint(equalTo: correoTextField.trailingAnchor),
            enviarButton.heightAnchor.constraint(equalToConstant: 52),

            regresarButton.topAnchor.constraint(equalTo: enviarButton.bottomAnchor, constant: 16),
            regresarButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            regresarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -25)
        ])
    }

    private func configurarTeclado() {
        correoTextField.returnKeyType = .send
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enviarAccion()
        return true
    }

    @objc private func cerrarTeclado() {
        view.endEditing(true)
    }

    @objc private func enviarAccion() {
        guard segundosParaReenviar == 0 else { return }

        let correo = correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if correo.isEmpty {
            mostrarAlerta(titulo: "Correo requerido", mensaje: "Ingresa el correo con el que te registraste.")
            correoTextField.becomeFirstResponder()
            return
        }

        if !esCorreoValido(correo) {
            mostrarAlerta(titulo: "Correo inválido", mensaje: "Ingresa un correo electrónico con un formato válido.")
            correoTextField.becomeFirstResponder()
            return
        }

        enviarButton.isEnabled = false

        SesionManager.enviarRecuperacionContrasena(correo: correo) { [weak self] resultado in
            guard let self else { return }
            self.enviarButton.isEnabled = true

            switch resultado {
            case .success:
                self.iniciarCuentaRegresivaReenvio()
                self.mostrarAlerta(
                    titulo: "Enlace enviado",
                    mensaje: "Revisa tu correo (\(correo)) y la carpeta de spam. Sigue el enlace para crear una nueva contraseña."
                )
            case .failure(let error):
                self.mostrarAlerta(titulo: "No se pudo enviar el enlace", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    private func esCorreoValido(_ correo: String) -> Bool {
        let patron = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", patron).evaluate(with: correo)
    }

    @objc private func regresarAccion() {
        navigationController?.popViewController(animated: true)
    }

    /// Evita que el usuario pueda pedir varios enlaces seguidos en segundos.
    private func iniciarCuentaRegresivaReenvio() {
        temporizadorReenvio?.invalidate()
        segundosParaReenviar = 30
        actualizarTituloEnviar()

        temporizadorReenvio = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] temporizador in
            guard let self else { return }
            self.segundosParaReenviar -= 1
            if self.segundosParaReenviar <= 0 {
                self.segundosParaReenviar = 0
                temporizador.invalidate()
            }
            self.actualizarTituloEnviar()
        }
    }

    private func actualizarTituloEnviar() {
        if segundosParaReenviar > 0 {
            enviarButton.setTitle("Reenviar en \(segundosParaReenviar)s", for: .normal)
            enviarButton.isEnabled = false
        } else {
            enviarButton.setTitle("Enviar enlace de recuperación", for: .normal)
            enviarButton.isEnabled = true
        }
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
