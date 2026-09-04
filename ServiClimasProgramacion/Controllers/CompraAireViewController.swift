import UIKit

class CompraAireViewController: UIViewController {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let regresarButton = UIButton(type: .system)
    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let capacidadLabel = UILabel()
    let capacidad1Button = UIButton(type: .system)
    let capacidad15Button = UIButton(type: .system)
    let capacidad2Button = UIButton(type: .system)

    let tipoLabel = UILabel()
    let normalButton = UIButton(type: .system)
    let inverterButton = UIButton(type: .system)

    let voltajeLabel = UILabel()
    let voltaje110Button = UIButton(type: .system)
    let voltaje220Button = UIButton(type: .system)

    let pagoLabel = UILabel()
    let efectivoButton = UIButton(type: .system)
    let transferenciaButton = UIButton(type: .system)

    let facturaLabel = UILabel()
    let facturaSiButton = UIButton(type: .system)
    let facturaNoButton = UIButton(type: .system)

    let solicitarButton = UIButton(type: .system)

    var capacidadSeleccionada: String?
    var tipoSeleccionado: String?
    var voltajeSeleccionado: String?
    var metodoPagoSeleccionado: MetodoPago?
    var facturaSeleccionada: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemGroupedBackground
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        contenidoView.backgroundColor = .clear
        navigationItem.title = ""
    }

    private func configurarElementos() {
        regresarButton.setTitle("Regresar", for: .normal)
        regresarButton.setTitleColor(.systemBlue, for: .normal)
        regresarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        regresarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        regresarButton.tintColor = .systemBlue
        regresarButton.addTarget(self, action: #selector(regresarAccion), for: .touchUpInside)

        tituloLabel.text = "Comprar aire acondicionado"
        tituloLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        tituloLabel.textColor = .label
        tituloLabel.numberOfLines = 0

        descripcionLabel.text = "Cuéntanos qué equipo buscas y te contactamos con el precio actualizado."
        descripcionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        capacidadLabel.text = "¿Qué capacidad necesitas?"
        configurarLabel(capacidadLabel)
        configurarBoton(capacidad1Button, titulo: "1 tonelada", icono: "snowflake")
        configurarBoton(capacidad15Button, titulo: "1 tonelada y media", icono: "snowflake")
        configurarBoton(capacidad2Button, titulo: "2 toneladas", icono: "snowflake")
        [capacidad1Button, capacidad15Button, capacidad2Button].forEach {
            $0.addTarget(self, action: #selector(seleccionarCapacidad), for: .touchUpInside)
        }

        tipoLabel.text = "¿Qué tipo de equipo?"
        configurarLabel(tipoLabel)
        configurarBoton(normalButton, titulo: "Normal", icono: "wind")
        configurarBoton(inverterButton, titulo: "Inverter", icono: "bolt.fill")
        [normalButton, inverterButton].forEach {
            $0.addTarget(self, action: #selector(seleccionarTipo), for: .touchUpInside)
        }

        voltajeLabel.text = "¿Qué voltaje maneja tu instalación?"
        configurarLabel(voltajeLabel)
        configurarBoton(voltaje110Button, titulo: "110V", icono: "powerplug.fill")
        configurarBoton(voltaje220Button, titulo: "220V", icono: "powerplug.fill")
        [voltaje110Button, voltaje220Button].forEach {
            $0.addTarget(self, action: #selector(seleccionarVoltaje), for: .touchUpInside)
        }

        pagoLabel.text = "¿Cómo prefieres pagar?"
        configurarLabel(pagoLabel)
        configurarBoton(efectivoButton, titulo: "Efectivo", icono: "banknote.fill")
        configurarBoton(transferenciaButton, titulo: "Transferencia", icono: "creditcard.fill")
        [efectivoButton, transferenciaButton].forEach {
            $0.addTarget(self, action: #selector(seleccionarMetodoPago), for: .touchUpInside)
        }

        facturaLabel.text = "¿Necesitas factura?"
        configurarLabel(facturaLabel)
        configurarBoton(facturaSiButton, titulo: "Sí", icono: "doc.text.fill")
        configurarBoton(facturaNoButton, titulo: "No", icono: "xmark.circle")
        [facturaSiButton, facturaNoButton].forEach {
            $0.addTarget(self, action: #selector(seleccionarFactura), for: .touchUpInside)
        }

        var configuracionSolicitar = UIButton.Configuration.filled()
        configuracionSolicitar.title = "Solicitar cotización"
        configuracionSolicitar.image = UIImage(systemName: "cart.fill")
        configuracionSolicitar.imagePlacement = .leading
        configuracionSolicitar.imagePadding = 12
        configuracionSolicitar.baseForegroundColor = .white
        configuracionSolicitar.baseBackgroundColor = .systemIndigo
        configuracionSolicitar.cornerStyle = .large
        configuracionSolicitar.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        solicitarButton.configuration = configuracionSolicitar
        solicitarButton.addTarget(self, action: #selector(solicitarAccion), for: .touchUpInside)

        [
            regresarButton, tituloLabel, descripcionLabel,
            capacidadLabel, capacidad1Button, capacidad15Button, capacidad2Button,
            tipoLabel, normalButton, inverterButton,
            voltajeLabel, voltaje110Button, voltaje220Button,
            pagoLabel, efectivoButton, transferenciaButton,
            facturaLabel, facturaSiButton, facturaNoButton,
            solicitarButton
        ].forEach { contenidoView.addSubview($0) }

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)
    }

    private func configurarLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
    }

    private func configurarBoton(_ boton: UIButton, titulo: String, icono: String) {
        var configuracion = UIButton.Configuration.filled()
        configuracion.title = titulo
        configuracion.image = UIImage(systemName: icono)
        configuracion.imagePlacement = .leading
        configuracion.imagePadding = 12
        configuracion.baseForegroundColor = .label
        configuracion.baseBackgroundColor = .secondarySystemGroupedBackground
        configuracion.cornerStyle = .large
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 18, bottom: 15, trailing: 18)

        boton.configuration = configuracion
        boton.layer.cornerRadius = 16
        boton.layer.borderWidth = 1
        boton.layer.borderColor = UIColor.separator.cgColor
    }

    private func marcarSeleccion(_ seleccionado: UIButton, entre botones: [UIButton]) {
        botones.forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.separator.cgColor
            $0.configuration?.baseBackgroundColor = .secondarySystemGroupedBackground
            $0.configuration?.baseForegroundColor = .label
        }
        seleccionado.layer.borderWidth = 2
        seleccionado.layer.borderColor = UIColor.systemIndigo.cgColor
        seleccionado.configuration?.baseBackgroundColor = .systemIndigo
        seleccionado.configuration?.baseForegroundColor = .white
    }

    private func configurarLayout() {
        let elementos = [
            scrollView, contenidoView, regresarButton, tituloLabel, descripcionLabel,
            capacidadLabel, capacidad1Button, capacidad15Button, capacidad2Button,
            tipoLabel, normalButton, inverterButton,
            voltajeLabel, voltaje110Button, voltaje220Button,
            pagoLabel, efectivoButton, transferenciaButton,
            facturaLabel, facturaSiButton, facturaNoButton,
            solicitarButton
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

            regresarButton.topAnchor.constraint(equalTo: contenidoView.topAnchor, constant: 16),
            regresarButton.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 24),

            tituloLabel.topAnchor.constraint(equalTo: regresarButton.bottomAnchor, constant: 16),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 24),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -24),

            descripcionLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 8),
            descripcionLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            descripcionLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            capacidadLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 26),
            capacidadLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            capacidadLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            capacidad1Button.topAnchor.constraint(equalTo: capacidadLabel.bottomAnchor, constant: 14),
            capacidad1Button.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            capacidad1Button.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            capacidad1Button.heightAnchor.constraint(equalToConstant: 58),

            capacidad15Button.topAnchor.constraint(equalTo: capacidad1Button.bottomAnchor, constant: 10),
            capacidad15Button.leadingAnchor.constraint(equalTo: capacidad1Button.leadingAnchor),
            capacidad15Button.trailingAnchor.constraint(equalTo: capacidad1Button.trailingAnchor),
            capacidad15Button.heightAnchor.constraint(equalToConstant: 58),

            capacidad2Button.topAnchor.constraint(equalTo: capacidad15Button.bottomAnchor, constant: 10),
            capacidad2Button.leadingAnchor.constraint(equalTo: capacidad1Button.leadingAnchor),
            capacidad2Button.trailingAnchor.constraint(equalTo: capacidad1Button.trailingAnchor),
            capacidad2Button.heightAnchor.constraint(equalToConstant: 58),

            tipoLabel.topAnchor.constraint(equalTo: capacidad2Button.bottomAnchor, constant: 26),
            tipoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            tipoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            normalButton.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 14),
            normalButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            normalButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            normalButton.heightAnchor.constraint(equalToConstant: 58),

            inverterButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: 10),
            inverterButton.leadingAnchor.constraint(equalTo: normalButton.leadingAnchor),
            inverterButton.trailingAnchor.constraint(equalTo: normalButton.trailingAnchor),
            inverterButton.heightAnchor.constraint(equalToConstant: 58),

            voltajeLabel.topAnchor.constraint(equalTo: inverterButton.bottomAnchor, constant: 26),
            voltajeLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            voltajeLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            voltaje110Button.topAnchor.constraint(equalTo: voltajeLabel.bottomAnchor, constant: 14),
            voltaje110Button.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            voltaje110Button.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            voltaje110Button.heightAnchor.constraint(equalToConstant: 58),

            voltaje220Button.topAnchor.constraint(equalTo: voltaje110Button.bottomAnchor, constant: 10),
            voltaje220Button.leadingAnchor.constraint(equalTo: voltaje110Button.leadingAnchor),
            voltaje220Button.trailingAnchor.constraint(equalTo: voltaje110Button.trailingAnchor),
            voltaje220Button.heightAnchor.constraint(equalToConstant: 58),

            pagoLabel.topAnchor.constraint(equalTo: voltaje220Button.bottomAnchor, constant: 26),
            pagoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            pagoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            efectivoButton.topAnchor.constraint(equalTo: pagoLabel.bottomAnchor, constant: 14),
            efectivoButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            efectivoButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            efectivoButton.heightAnchor.constraint(equalToConstant: 58),

            transferenciaButton.topAnchor.constraint(equalTo: efectivoButton.bottomAnchor, constant: 10),
            transferenciaButton.leadingAnchor.constraint(equalTo: efectivoButton.leadingAnchor),
            transferenciaButton.trailingAnchor.constraint(equalTo: efectivoButton.trailingAnchor),
            transferenciaButton.heightAnchor.constraint(equalToConstant: 58),

            facturaLabel.topAnchor.constraint(equalTo: transferenciaButton.bottomAnchor, constant: 26),
            facturaLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            facturaLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            facturaSiButton.topAnchor.constraint(equalTo: facturaLabel.bottomAnchor, constant: 14),
            facturaSiButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            facturaSiButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            facturaSiButton.heightAnchor.constraint(equalToConstant: 58),

            facturaNoButton.topAnchor.constraint(equalTo: facturaSiButton.bottomAnchor, constant: 10),
            facturaNoButton.leadingAnchor.constraint(equalTo: facturaSiButton.leadingAnchor),
            facturaNoButton.trailingAnchor.constraint(equalTo: facturaSiButton.trailingAnchor),
            facturaNoButton.heightAnchor.constraint(equalToConstant: 58),

            solicitarButton.topAnchor.constraint(equalTo: facturaNoButton.bottomAnchor, constant: 32),
            solicitarButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            solicitarButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            solicitarButton.heightAnchor.constraint(equalToConstant: 56),
            solicitarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -32)
        ])
    }

    @objc private func regresarAccion() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func seleccionarCapacidad(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [capacidad1Button, capacidad15Button, capacidad2Button])
        if sender == capacidad1Button {
            capacidadSeleccionada = "1 tonelada"
        } else if sender == capacidad15Button {
            capacidadSeleccionada = "1 tonelada y media"
        } else {
            capacidadSeleccionada = "2 toneladas"
        }
    }

    @objc private func seleccionarTipo(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [normalButton, inverterButton])
        tipoSeleccionado = (sender == normalButton) ? "Normal" : "Inverter"
    }

    @objc private func seleccionarVoltaje(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [voltaje110Button, voltaje220Button])
        voltajeSeleccionado = (sender == voltaje110Button) ? "110V" : "220V"
    }

    @objc private func seleccionarMetodoPago(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [efectivoButton, transferenciaButton])
        metodoPagoSeleccionado = (sender == efectivoButton) ? .efectivo : .transferencia
    }

    @objc private func seleccionarFactura(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [facturaSiButton, facturaNoButton])
        facturaSeleccionada = (sender == facturaSiButton)
    }

    @objc private func solicitarAccion() {
        guard let capacidad = capacidadSeleccionada else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona la capacidad del equipo.")
            return
        }
        guard let tipo = tipoSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el tipo de equipo.")
            return
        }
        guard let voltaje = voltajeSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el voltaje.")
            return
        }
        guard let metodoPago = metodoPagoSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona tu método de pago.")
            return
        }
        guard let factura = facturaSeleccionada else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Indica si necesitas factura.")
            return
        }

        let solicitud = SolicitudCompraAire(
            capacidad: capacidad,
            tipo: tipo,
            voltaje: voltaje,
            metodoPago: metodoPago,
            factura: factura
        )

        let pantalla = ConfirmarSolicitudViewController(solicitud: solicitud) {
            // Solo notifica al dueño: el precio depende del tipo de cambio del
            // dólar y hay que revisarlo antes de contactar al cliente.
            NotificacionesManager.notificarInmediata(
                titulo: "Nueva cotización de equipo",
                mensaje: "\(SesionManager.nombreUsuarioActual) quiere cotizar un equipo \(solicitud.tipo) de \(solicitud.capacidad), \(solicitud.voltaje). Revisa el tipo de cambio antes de contactarlo."
            )
        }

        navigationController?.pushViewController(pantalla, animated: true)
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
