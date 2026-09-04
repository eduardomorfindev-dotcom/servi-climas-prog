import UIKit

/// Segundo paso real y gratuito de verificación: usa el correo de confirmación
/// nativo de Firebase Auth (sendEmailVerification), no un código simulado ni SMS.
class VerificacionViewController: UIViewController {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let tituloLabel = UILabel()
    let subtituloLabel = UILabel()
    let yaVerifiqueButton = UIButton(type: .system)
    let reenviarButton = UIButton(type: .system)
    let cerrarSesionButton = UIButton(type: .system)

    var correoUsuario: String = ""

    private var segundosParaReenviar = 0
    private var temporizadorReenvio: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
        iniciarCuentaRegresivaReenvio()
    }

    deinit {
        temporizadorReenvio?.invalidate()
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
    }

    private func configurarElementos() {
        tituloLabel.text = "Verifica tu correo"
        tituloLabel.font = UIFont(name: "AvenirNext-Bold", size: 28) ?? .boldSystemFont(ofSize: 28)
        tituloLabel.textColor = .label
        tituloLabel.textAlignment = .center

        let correoTexto = correoUsuario.isEmpty ? "tu correo" : correoUsuario
        subtituloLabel.text = "Te enviamos un correo de confirmación a:\n\(correoTexto)\n\nÁbrelo, confirma tu cuenta y regresa aquí."
        subtituloLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtituloLabel.textColor = .secondaryLabel
        subtituloLabel.textAlignment = .center
        subtituloLabel.numberOfLines = 0

        yaVerifiqueButton.setTitle("Ya verifiqué mi correo", for: .normal)
        yaVerifiqueButton.setTitleColor(.white, for: .normal)
        yaVerifiqueButton.backgroundColor = .systemBlue
        yaVerifiqueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        yaVerifiqueButton.layer.cornerRadius = 15
        yaVerifiqueButton.addTarget(self, action: #selector(yaVerifiqueAccion), for: .touchUpInside)

        reenviarButton.setTitleColor(.systemBlue, for: .normal)
        reenviarButton.setTitleColor(.tertiaryLabel, for: .disabled)
        reenviarButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        reenviarButton.addTarget(self, action: #selector(reenviarAccion), for: .touchUpInside)

        cerrarSesionButton.setTitle("Cerrar sesión", for: .normal)
        cerrarSesionButton.setTitleColor(.systemRed, for: .normal)
        cerrarSesionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        cerrarSesionButton.addTarget(self, action: #selector(cerrarSesionAccion), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let subvistas = [tituloLabel, subtituloLabel, yaVerifiqueButton, reenviarButton, cerrarSesionButton]
        subvistas.forEach { contenidoView.addSubview($0) }
    }

    private func configurarLayout() {
        let elementos = [scrollView, contenidoView, tituloLabel, subtituloLabel, yaVerifiqueButton, reenviarButton, cerrarSesionButton]
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

            tituloLabel.topAnchor.constraint(equalTo: contenidoView.topAnchor, constant: 60),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),

            subtituloLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 14),
            subtituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 30),
            subtituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -30),

            yaVerifiqueButton.topAnchor.constraint(equalTo: subtituloLabel.bottomAnchor, constant: 35),
            yaVerifiqueButton.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            yaVerifiqueButton.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),
            yaVerifiqueButton.heightAnchor.constraint(equalToConstant: 52),

            reenviarButton.topAnchor.constraint(equalTo: yaVerifiqueButton.bottomAnchor, constant: 18),
            reenviarButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),

            cerrarSesionButton.topAnchor.constraint(equalTo: reenviarButton.bottomAnchor, constant: 12),
            cerrarSesionButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            cerrarSesionButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -30)
        ])
    }

    @objc private func yaVerifiqueAccion() {
        yaVerifiqueButton.isEnabled = false

        SesionManager.recargarUsuario { [weak self] resultado in
            guard let self else { return }
            self.yaVerifiqueButton.isEnabled = true

            switch resultado {
            case .success:
                if SesionManager.correoVerificado {
                    NotificacionesManager.notificarInmediata(
                        titulo: "¡Bienvenido a Servi Climas!",
                        mensaje: "Gracias por confirmar tu cuenta, \(SesionManager.nombreUsuarioActual)."
                    )
                    if SesionManager.tieneVerificacionDosPasos {
                        self.navigationController?.setViewControllers(
                            [NuestrosServiciosViewController()],
                            animated: true
                        )
                    } else {
                        self.navigationController?.setViewControllers(
                            [ConfigurarAutenticadorViewController()],
                            animated: true
                        )
                    }
                } else {
                    self.mostrarAlerta(
                        titulo: "Todavía no verificas",
                        mensaje: "Abre el correo que te enviamos y confirma tu cuenta. Revisa también la carpeta de spam."
                    )
                }
            case .failure(let error):
                self.mostrarAlerta(titulo: "No se pudo verificar", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    @objc private func reenviarAccion() {
        guard segundosParaReenviar == 0 else { return }
        reenviarButton.isEnabled = false

        SesionManager.enviarVerificacionCorreo { [weak self] resultado in
            guard let self else { return }

            switch resultado {
            case .success:
                self.iniciarCuentaRegresivaReenvio()
                self.mostrarAlerta(
                    titulo: "Correo reenviado",
                    mensaje: "Revisa tu bandeja de entrada (y spam) por el correo de confirmación."
                )
            case .failure(let error):
                self.actualizarTituloReenviar()
                self.mostrarAlerta(titulo: "No se pudo reenviar", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    @objc private func cerrarSesionAccion() {
        SesionManager.cerrarSesion()
        navigationController?.setViewControllers([InicioViewController()], animated: true)
    }

    private func iniciarCuentaRegresivaReenvio() {
        temporizadorReenvio?.invalidate()
        segundosParaReenviar = 30
        actualizarTituloReenviar()

        temporizadorReenvio = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] temporizador in
            guard let self else { return }
            self.segundosParaReenviar -= 1
            if self.segundosParaReenviar <= 0 {
                self.segundosParaReenviar = 0
                temporizador.invalidate()
            }
            self.actualizarTituloReenviar()
        }
    }

    private func actualizarTituloReenviar() {
        if segundosParaReenviar > 0 {
            reenviarButton.setTitle("Reenviar correo (\(segundosParaReenviar)s)", for: .normal)
            reenviarButton.isEnabled = false
        } else {
            reenviarButton.setTitle("Reenviar correo", for: .normal)
            reenviarButton.isEnabled = true
        }
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
