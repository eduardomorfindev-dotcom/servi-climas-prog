import UIKit

class RegistroViewController: UIViewController, UITextFieldDelegate {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let logoImageView = UIImageView(
        image: UIImage(named: "servi")
    )

    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let nombreTextField = UITextField()
    let telefonoTextField = UITextField()
    let correoTextField = UITextField()
    let direccionTextField = UITextField()
    let contraseñaTextField = UITextField()
    let confirmarContraseñaTextField = UITextField()

    let crearCuentaButton = UIButton(type: .system)
    let regresarButton = UIButton(type: .system)

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
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = false

        tituloLabel.text = "Crear cuenta"
        tituloLabel.font = UIFont(name: "AvenirNext-Bold", size: 30) ?? .boldSystemFont(ofSize: 30)
        tituloLabel.textAlignment = .center
        tituloLabel.textColor = .label

        descripcionLabel.text = "Regístrate para utilizar los servicios de Servi Climas"
        descripcionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descripcionLabel.textAlignment = .center
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        configurarCampo(campo: nombreTextField, placeholder: "Nombre completo", tipo: .default)
        configurarCampo(campo: telefonoTextField, placeholder: "Teléfono", tipo: .phonePad)
        configurarCampo(campo: correoTextField, placeholder: "Correo electrónico", tipo: .emailAddress)
        configurarCampo(campo: direccionTextField, placeholder: "Dirección en Manzanillo", tipo: .default)
        configurarCampo(campo: contraseñaTextField, placeholder: "Contraseña", tipo: .default)
        configurarCampo(campo: confirmarContraseñaTextField, placeholder: "Confirmar contraseña", tipo: .default)

        nombreTextField.delegate = self
        telefonoTextField.delegate = self
        correoTextField.delegate = self
        direccionTextField.delegate = self
        contraseñaTextField.delegate = self
        confirmarContraseñaTextField.delegate = self

        contraseñaTextField.textContentType = .newPassword
        confirmarContraseñaTextField.textContentType = .newPassword
        contraseñaTextField.agregarBotonOjito()
        confirmarContraseñaTextField.agregarBotonOjito()

        crearCuentaButton.setTitle("Crear cuenta", for: .normal)
        crearCuentaButton.setTitleColor(.white, for: .normal)
        crearCuentaButton.backgroundColor = .systemBlue
        crearCuentaButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        crearCuentaButton.layer.cornerRadius = 15
        crearCuentaButton.addTarget(self, action: #selector(crearCuentaAccion), for: .touchUpInside)

        regresarButton.setTitle("Ya tengo una cuenta", for: .normal)
        regresarButton.setTitleColor(.systemBlue, for: .normal)
        regresarButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        regresarButton.addTarget(self, action: #selector(regresarLogin), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let subviews = [
            logoImageView, tituloLabel, descripcionLabel,
            nombreTextField, telefonoTextField, correoTextField, direccionTextField,
            contraseñaTextField, confirmarContraseñaTextField,
            crearCuentaButton, regresarButton
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
            nombreTextField, telefonoTextField, correoTextField, direccionTextField,
            contraseñaTextField, confirmarContraseñaTextField,
            crearCuentaButton, regresarButton
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

            logoImageView.topAnchor.constraint(equalTo: contenidoView.topAnchor, constant: 25),
            logoImageView.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 90),

            tituloLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),

            descripcionLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 7),
            descripcionLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 30),
            descripcionLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -30),

            nombreTextField.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 25),
            nombreTextField.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            nombreTextField.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),
            nombreTextField.heightAnchor.constraint(equalToConstant: 52),

            telefonoTextField.topAnchor.constraint(equalTo: nombreTextField.bottomAnchor, constant: 12),
            telefonoTextField.leadingAnchor.constraint(equalTo: nombreTextField.leadingAnchor),
            telefonoTextField.trailingAnchor.constraint(equalTo: nombreTextField.trailingAnchor),
            telefonoTextField.heightAnchor.constraint(equalToConstant: 52),

            correoTextField.topAnchor.constraint(equalTo: telefonoTextField.bottomAnchor, constant: 12),
            correoTextField.leadingAnchor.constraint(equalTo: nombreTextField.leadingAnchor),
            correoTextField.trailingAnchor.constraint(equalTo: nombreTextField.trailingAnchor),
            correoTextField.heightAnchor.constraint(equalToConstant: 52),

            direccionTextField.topAnchor.constraint(equalTo: correoTextField.bottomAnchor, constant: 12),
            direccionTextField.leadingAnchor.constraint(equalTo: nombreTextField.leadingAnchor),
            direccionTextField.trailingAnchor.constraint(equalTo: nombreTextField.trailingAnchor),
            direccionTextField.heightAnchor.constraint(equalToConstant: 52),

            contraseñaTextField.topAnchor.constraint(equalTo: direccionTextField.bottomAnchor, constant: 12),
            contraseñaTextField.leadingAnchor.constraint(equalTo: nombreTextField.leadingAnchor),
            contraseñaTextField.trailingAnchor.constraint(equalTo: nombreTextField.trailingAnchor),
            contraseñaTextField.heightAnchor.constraint(equalToConstant: 52),

            confirmarContraseñaTextField.topAnchor.constraint(equalTo: contraseñaTextField.bottomAnchor, constant: 12),
            confirmarContraseñaTextField.leadingAnchor.constraint(equalTo: nombreTextField.leadingAnchor),
            confirmarContraseñaTextField.trailingAnchor.constraint(equalTo: nombreTextField.trailingAnchor),
            confirmarContraseñaTextField.heightAnchor.constraint(equalToConstant: 52),

            crearCuentaButton.topAnchor.constraint(equalTo: confirmarContraseñaTextField.bottomAnchor, constant: 22),
            crearCuentaButton.leadingAnchor.constraint(equalTo: nombreTextField.leadingAnchor),
            crearCuentaButton.trailingAnchor.constraint(equalTo: nombreTextField.trailingAnchor),
            crearCuentaButton.heightAnchor.constraint(equalToConstant: 52),

            regresarButton.topAnchor.constraint(equalTo: crearCuentaButton.bottomAnchor, constant: 15),
            regresarButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            regresarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -25)
        ])
    }

    private func configurarTeclado() {
        nombreTextField.returnKeyType = .next
        telefonoTextField.returnKeyType = .next
        correoTextField.returnKeyType = .next
        direccionTextField.returnKeyType = .next
        contraseñaTextField.returnKeyType = .next
        confirmarContraseñaTextField.returnKeyType = .done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nombreTextField {
            telefonoTextField.becomeFirstResponder()
        } else if textField == telefonoTextField {
            correoTextField.becomeFirstResponder()
        } else if textField == correoTextField {
            direccionTextField.becomeFirstResponder()
        } else if textField == direccionTextField {
            contraseñaTextField.becomeFirstResponder()
        } else if textField == contraseñaTextField {
            confirmarContraseñaTextField.becomeFirstResponder()
        } else if textField == confirmarContraseñaTextField {
            textField.resignFirstResponder()
            crearCuentaAccion()
        }
        return true
    }

    @objc private func cerrarTeclado() {
        view.endEditing(true)
    }

    @objc private func crearCuentaAccion() {
        let nombre = nombreTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let telefono = telefonoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let correo = correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let direccion = direccionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let contraseña = contraseñaTextField.text ?? ""
        let confirmarContraseña = confirmarContraseñaTextField.text ?? ""

        if nombre.isEmpty {
            mostrarAlerta(titulo: "Nombre requerido", mensaje: "Ingresa tu nombre completo.")
            nombreTextField.becomeFirstResponder()
            return
        }

        if telefono.isEmpty {
            mostrarAlerta(titulo: "Teléfono requerido", mensaje: "Ingresa tu número de teléfono.")
            telefonoTextField.becomeFirstResponder()
            return
        }

        if telefono.filter(\.isNumber).count < 10 {
            mostrarAlerta(titulo: "Teléfono inválido", mensaje: "Ingresa un número de teléfono a 10 dígitos.")
            telefonoTextField.becomeFirstResponder()
            return
        }

        if correo.isEmpty {
            mostrarAlerta(titulo: "Correo requerido", mensaje: "Ingresa tu correo electrónico.")
            correoTextField.becomeFirstResponder()
            return
        }

        if !esCorreoValido(correo) {
            mostrarAlerta(titulo: "Correo inválido", mensaje: "Ingresa un correo electrónico con un formato válido.")
            correoTextField.becomeFirstResponder()
            return
        }

        if direccion.isEmpty {
            mostrarAlerta(titulo: "Dirección requerida", mensaje: "Ingresa tu dirección en Manzanillo.")
            direccionTextField.becomeFirstResponder()
            return
        }

        if contraseña.isEmpty {
            mostrarAlerta(titulo: "Contraseña requerida", mensaje: "Ingresa una contraseña.")
            contraseñaTextField.becomeFirstResponder()
            return
        }

        if contraseña.count < 6 {
            mostrarAlerta(titulo: "Contraseña muy corta", mensaje: "La contraseña debe tener al menos 6 caracteres.")
            contraseñaTextField.becomeFirstResponder()
            return
        }

        if contraseña != confirmarContraseña {
            mostrarAlerta(titulo: "Las contraseñas no coinciden", mensaje: "Verifica que ambas contraseñas sean iguales.")
            confirmarContraseñaTextField.becomeFirstResponder()
            return
        }

        crearCuentaButton.isEnabled = false

        SesionManager.registrar(nombre: nombre, correo: correo, contrasena: contraseña) { [weak self] resultado in
            guard let self else { return }
            self.crearCuentaButton.isEnabled = true

            switch resultado {
            case .success:
                BaseDatosManager.guardarUsuario(nombre: nombre, correo: correo, telefono: telefono, direccion: direccion)

                SesionManager.enviarVerificacionCorreo { resultadoCorreo in
                    if case .failure(let error) = resultadoCorreo {
                        self.mostrarAlerta(
                            titulo: "No se pudo enviar el correo de verificación",
                            mensaje: SesionManager.mensajeError(error)
                        )
                    }
                }

                let verificacionVC = VerificacionViewController()
                verificacionVC.correoUsuario = correo
                self.navigationController?.pushViewController(verificacionVC, animated: true)
            case .failure(let error):
                self.mostrarAlerta(titulo: "No se pudo crear la cuenta", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    private func esCorreoValido(_ correo: String) -> Bool {
        let patron = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", patron).evaluate(with: correo)
    }

    @objc private func regresarLogin() {
        navigationController?.popViewController(animated: true)
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
