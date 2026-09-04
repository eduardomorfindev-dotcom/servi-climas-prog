import UIKit

/// Pantalla de éxito compartida por los 4 servicios: se llega aquí después de
/// que ConfirmarSolicitudViewController ya disparó las notificaciones
/// correspondientes.
class ConfirmacionEnviadaViewController: UIViewController {

    // MARK: - ELEMENTOS

    let iconoImageView = UIImageView()
    let tituloLabel = UILabel()
    let mensajeLabel = UILabel()
    let finalizarButton = UIButton(type: .system)

    // MARK: - VIEW DID LOAD

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
    }

    // MARK: - PANTALLA

    private func configurarPantalla() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.hidesBackButton = true
    }

    // MARK: - ELEMENTOS

    private func configurarElementos() {
        let configuracionSimbolo = UIImage.SymbolConfiguration(pointSize: 70, weight: .medium)
        iconoImageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuracionSimbolo)
        iconoImageView.tintColor = .systemGreen
        iconoImageView.contentMode = .scaleAspectFit

        tituloLabel.text = "¡Solicitud enviada!"
        tituloLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        tituloLabel.textColor = .label
        tituloLabel.textAlignment = .center
        tituloLabel.numberOfLines = 0

        mensajeLabel.text = "Hemos registrado tu solicitud correctamente. En breve nos pondremos en contacto contigo para confirmar los detalles."
        mensajeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        mensajeLabel.textColor = .secondaryLabel
        mensajeLabel.textAlignment = .center
        mensajeLabel.numberOfLines = 0

        var configuracionBoton = UIButton.Configuration.filled()
        configuracionBoton.title = "Volver a Nuestros Servicios"
        configuracionBoton.image = UIImage(systemName: "house.fill")
        configuracionBoton.imagePlacement = .leading
        configuracionBoton.imagePadding = 10
        configuracionBoton.baseBackgroundColor = .systemBlue
        configuracionBoton.baseForegroundColor = .white
        configuracionBoton.cornerStyle = .large
        configuracionBoton.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)

        finalizarButton.configuration = configuracionBoton
        finalizarButton.layer.cornerRadius = 18
        finalizarButton.layer.shadowColor = UIColor.black.cgColor
        finalizarButton.layer.shadowOpacity = 0.15
        finalizarButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        finalizarButton.layer.shadowRadius = 8
        finalizarButton.addTarget(self, action: #selector(volverAServiciosTapped), for: .touchUpInside)

        [iconoImageView, tituloLabel, mensajeLabel, finalizarButton].forEach { view.addSubview($0) }
    }

    // MARK: - LAYOUT

    private func configurarLayout() {
        let elementos = [iconoImageView, tituloLabel, mensajeLabel, finalizarButton]
        elementos.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            iconoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            iconoImageView.heightAnchor.constraint(equalToConstant: 90),
            iconoImageView.widthAnchor.constraint(equalToConstant: 90),

            tituloLabel.topAnchor.constraint(equalTo: iconoImageView.bottomAnchor, constant: 24),
            tituloLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            tituloLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            mensajeLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 12),
            mensajeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            mensajeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            finalizarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            finalizarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            finalizarButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            finalizarButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    // MARK: - ACCIÓN

    @objc private func volverAServiciosTapped() {
        guard let nav = navigationController else { return }
        if let serviciosVC = nav.viewControllers.first(where: { $0 is NuestrosServiciosViewController }) {
            nav.popToViewController(serviciosVC, animated: true)
        } else {
            nav.popToRootViewController(animated: true)
        }
    }
}
