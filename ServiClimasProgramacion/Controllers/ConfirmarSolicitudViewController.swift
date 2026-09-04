import UIKit

/// Pantalla de confirmación compartida por los 4 servicios (Mantenimiento,
/// Instalación, Reparación, Compra de aire). Muestra el resumen genérico de
/// `solicitud.resumen` y, al confirmar, ejecuta `alConfirmar` — cada pantalla
/// de origen decide ahí qué notificaciones disparar.
class ConfirmarSolicitudViewController: UIViewController {

    // MARK: - DATOS RECIBIDOS

    private let solicitud: SolicitudServicio
    private let alConfirmar: () -> Void

    // MARK: - ELEMENTOS

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()
    let resumenStackView = UIStackView()

    let confirmarButton = UIButton(type: .system)
    let regresarButton = UIButton(type: .system)

    // MARK: - CONSTRUCTOR

    init(solicitud: SolicitudServicio, alConfirmar: @escaping () -> Void) {
        self.solicitud = solicitud
        self.alConfirmar = alConfirmar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no está implementado")
    }

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
        navigationItem.title = "Confirmar solicitud"

        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true

        contenidoView.backgroundColor = .clear
    }

    // MARK: - ELEMENTOS

    private func configurarElementos() {
        tituloLabel.text = "Confirma tu solicitud de \(solicitud.tituloServicio.lowercased())"
        tituloLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        tituloLabel.textColor = .label
        tituloLabel.numberOfLines = 0

        descripcionLabel.text = "Revisa los datos de tu servicio antes de confirmar."
        descripcionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        resumenStackView.axis = .vertical
        resumenStackView.spacing = 18
        resumenStackView.alignment = .fill

        for dato in solicitud.resumen {
            resumenStackView.addArrangedSubview(construirFila(titulo: dato.titulo, valor: dato.valor))
        }

        var configuracion = UIButton.Configuration.filled()
        configuracion.title = "Confirmar solicitud"
        configuracion.image = UIImage(systemName: "checkmark.circle.fill")
        configuracion.imagePlacement = .leading
        configuracion.imagePadding = 10
        configuracion.baseBackgroundColor = .systemBlue
        configuracion.baseForegroundColor = .white
        configuracion.cornerStyle = .large
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)

        confirmarButton.configuration = configuracion
        confirmarButton.layer.cornerRadius = 18
        confirmarButton.layer.shadowColor = UIColor.black.cgColor
        confirmarButton.layer.shadowOpacity = 0.15
        confirmarButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        confirmarButton.layer.shadowRadius = 8
        confirmarButton.addTarget(self, action: #selector(confirmarSolicitud), for: .touchUpInside)

        regresarButton.setTitle("Regresar", for: .normal)
        regresarButton.setTitleColor(.systemBlue, for: .normal)
        regresarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        regresarButton.addTarget(self, action: #selector(regresar), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let elementos = [tituloLabel, descripcionLabel, resumenStackView, confirmarButton, regresarButton]
        elementos.forEach { contenidoView.addSubview($0) }
    }

    private func construirFila(titulo: String, valor: String) -> UIView {
        let contenedor = UIView()

        let tituloLabel = UILabel()
        tituloLabel.text = titulo
        tituloLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        tituloLabel.textColor = .secondaryLabel

        let valorLabel = UILabel()
        valorLabel.text = valor
        valorLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        valorLabel.textColor = .label
        valorLabel.numberOfLines = 0

        [tituloLabel, valorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contenedor.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tituloLabel.topAnchor.constraint(equalTo: contenedor.topAnchor),
            tituloLabel.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor),
            tituloLabel.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor),

            valorLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4),
            valorLabel.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor),
            valorLabel.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor),
            valorLabel.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor)
        ])

        return contenedor
    }

    // MARK: - LAYOUT

    private func configurarLayout() {
        let elementos = [scrollView, contenidoView, tituloLabel, descripcionLabel, resumenStackView, confirmarButton, regresarButton]
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
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 24),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -24),

            descripcionLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 8),
            descripcionLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            descripcionLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            resumenStackView.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 30),
            resumenStackView.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            resumenStackView.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            confirmarButton.topAnchor.constraint(equalTo: resumenStackView.bottomAnchor, constant: 34),
            confirmarButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            confirmarButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            confirmarButton.heightAnchor.constraint(equalToConstant: 58),

            regresarButton.topAnchor.constraint(equalTo: confirmarButton.bottomAnchor, constant: 14),
            regresarButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            regresarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -32)
        ])
    }

    // MARK: - ACCIONES

    @objc private func confirmarSolicitud() {
        confirmarButton.isEnabled = false

        BaseDatosManager.guardarSolicitud(
            servicio: solicitud.tituloServicio,
            resumen: solicitud.resumen,
            fechaCita: solicitud.fechaCita
        ) { [weak self] resultado in
            guard let self else { return }
            self.confirmarButton.isEnabled = true

            switch resultado {
            case .success:
                self.alConfirmar()
                self.navigationController?.pushViewController(ConfirmacionEnviadaViewController(), animated: true)
            case .failure(let error):
                self.mostrarAlerta(
                    titulo: "No se pudo enviar",
                    mensaje: BaseDatosManager.mensajeError(error)
                )
            }
        }
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

    @objc private func regresar() {
        navigationController?.popViewController(animated: true)
    }
}
