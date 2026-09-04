import UIKit
import FirebaseAuth
import CoreImage.CIFilterBuiltins

/// Se muestra una sola vez, justo después de verificar el correo, para
/// activar la verificación en dos pasos con una app autenticadora (Google
/// Authenticator, Microsoft Authenticator, Authy, o el Llavero de iOS).
/// Es "omitible" a propósito: hasta que "Multi-factor authentication" esté
/// activado en Firebase Console, este paso fallaría y dejaría a cualquiera
/// sin poder entrar a la app.
class ConfigurarAutenticadorViewController: UIViewController, UITextFieldDelegate {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()
    let qrImageView = UIImageView()
    let cargandoIndicador = UIActivityIndicatorView(style: .medium)
    let secretoLabel = UILabel()
    let codigoTextField = UITextField()
    let activarButton = UIButton(type: .system)
    let omitirButton = UIButton(type: .system)

    private var secretoActual: TOTPSecret?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
        configurarTeclado()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard secretoActual == nil else { return }
        generarSecreto()
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true

        let gesto = UITapGestureRecognizer(target: self, action: #selector(cerrarTeclado))
        gesto.cancelsTouchesInView = false
        view.addGestureRecognizer(gesto)
    }

    private func configurarElementos() {
        tituloLabel.text = "Activa la verificación en dos pasos"
        tituloLabel.font = UIFont(name: "AvenirNext-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
        tituloLabel.textAlignment = .center
        tituloLabel.textColor = .label
        tituloLabel.numberOfLines = 0

        descripcionLabel.text = "Escanea este código con una app autenticadora (Google Authenticator, Microsoft Authenticator, Authy) y escribe el código de 6 dígitos que te muestre."
        descripcionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descripcionLabel.textAlignment = .center
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        qrImageView.contentMode = .scaleAspectFit
        qrImageView.backgroundColor = .secondarySystemBackground
        qrImageView.layer.cornerRadius = 14
        qrImageView.clipsToBounds = true

        cargandoIndicador.hidesWhenStopped = true

        secretoLabel.font = .monospacedSystemFont(ofSize: 14, weight: .medium)
        secretoLabel.textColor = .secondaryLabel
        secretoLabel.textAlignment = .center
        secretoLabel.numberOfLines = 0

        codigoTextField.placeholder = "Código de 6 dígitos"
        codigoTextField.borderStyle = .none
        codigoTextField.backgroundColor = .secondarySystemBackground
        codigoTextField.layer.cornerRadius = 14
        codigoTextField.layer.borderWidth = 1
        codigoTextField.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        codigoTextField.font = .systemFont(ofSize: 22, weight: .semibold)
        codigoTextField.textAlignment = .center
        codigoTextField.keyboardType = .numberPad
        codigoTextField.delegate = self

        activarButton.setTitle("Activar verificación en dos pasos", for: .normal)
        activarButton.setTitleColor(.white, for: .normal)
        activarButton.setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
        activarButton.backgroundColor = .systemBlue
        activarButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        activarButton.layer.cornerRadius = 15
        activarButton.addTarget(self, action: #selector(activarAccion), for: .touchUpInside)

        omitirButton.setTitle("Configurar más tarde", for: .normal)
        omitirButton.setTitleColor(.secondaryLabel, for: .normal)
        omitirButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        omitirButton.addTarget(self, action: #selector(omitirAccion), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let subvistas = [
            tituloLabel, descripcionLabel, qrImageView, cargandoIndicador,
            secretoLabel, codigoTextField, activarButton, omitirButton
        ]
        subvistas.forEach { contenidoView.addSubview($0) }
    }

    private func configurarLayout() {
        let elementos = [
            scrollView, contenidoView,
            tituloLabel, descripcionLabel, qrImageView, cargandoIndicador,
            secretoLabel, codigoTextField, activarButton, omitirButton
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

            tituloLabel.topAnchor.constraint(equalTo: contenidoView.topAnchor, constant: 30),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),

            descripcionLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 10),
            descripcionLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 30),
            descripcionLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -30),

            qrImageView.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 24),
            qrImageView.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 200),
            qrImageView.heightAnchor.constraint(equalToConstant: 200),

            cargandoIndicador.centerXAnchor.constraint(equalTo: qrImageView.centerXAnchor),
            cargandoIndicador.centerYAnchor.constraint(equalTo: qrImageView.centerYAnchor),

            secretoLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 14),
            secretoLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 30),
            secretoLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -30),

            codigoTextField.topAnchor.constraint(equalTo: secretoLabel.bottomAnchor, constant: 22),
            codigoTextField.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 50),
            codigoTextField.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -50),
            codigoTextField.heightAnchor.constraint(equalToConstant: 56),

            activarButton.topAnchor.constraint(equalTo: codigoTextField.bottomAnchor, constant: 20),
            activarButton.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            activarButton.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),
            activarButton.heightAnchor.constraint(equalToConstant: 52),

            omitirButton.topAnchor.constraint(equalTo: activarButton.bottomAnchor, constant: 16),
            omitirButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            omitirButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -25)
        ])
    }

    private func configurarTeclado() {
        codigoTextField.returnKeyType = .done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activarAccion()
        return true
    }

    @objc private func cerrarTeclado() {
        view.endEditing(true)
    }

    private func generarSecreto() {
        cargandoIndicador.startAnimating()
        activarButton.isEnabled = false

        SesionManager.generarSecretoDosPasos { [weak self] resultado in
            guard let self else { return }
            self.cargandoIndicador.stopAnimating()
            self.activarButton.isEnabled = true

            switch resultado {
            case .success(let secreto):
                self.secretoActual = secreto
                let correo = Auth.auth().currentUser?.email ?? "usuario"
                let urlQR = secreto.generateQRCodeURL(withAccountName: correo, issuer: "Servi Climas")
                self.qrImageView.image = self.imagenQR(desde: urlQR)
                self.secretoLabel.text = "¿No puedes escanear? Escribe esta clave a mano:\n\(secreto.sharedSecretKey())"
            case .failure(let error):
                self.mostrarAlerta(titulo: "No se pudo generar el código", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    private func imagenQR(desde texto: String) -> UIImage? {
        let filtro = CIFilter.qrCodeGenerator()
        filtro.message = Data(texto.utf8)

        guard let salida = filtro.outputImage else { return nil }
        let transformada = salida.transformed(by: CGAffineTransform(scaleX: 8, y: 8))

        let contexto = CIContext()
        guard let cgImagen = contexto.createCGImage(transformada, from: transformada.extent) else { return nil }
        return UIImage(cgImage: cgImagen)
    }

    @objc private func activarAccion() {
        guard let secreto = secretoActual else { return }

        let codigo = codigoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if codigo.count < 6 {
            mostrarAlerta(titulo: "Código incompleto", mensaje: "Escribe los 6 dígitos que muestra tu app autenticadora.")
            return
        }

        activarButton.isEnabled = false

        SesionManager.confirmarInscripcionDosPasos(secreto: secreto, codigo: codigo) { [weak self] resultado in
            guard let self else { return }
            self.activarButton.isEnabled = true

            switch resultado {
            case .success:
                self.irAlDashboard()
            case .failure(let error):
                self.mostrarAlerta(titulo: "No se pudo activar", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    @objc private func omitirAccion() {
        irAlDashboard()
    }

    private func irAlDashboard() {
        navigationController?.setViewControllers([NuestrosServiciosViewController()], animated: true)
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
