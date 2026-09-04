import UIKit

class InstalacionViewController: UIViewController {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let regresarButton = UIButton(type: .system)
    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let capacidadLabel = UILabel()
    let capacidad1Button = UIButton(type: .system)
    let capacidad2Button = UIButton(type: .system)
    let capacidad3Button = UIButton(type: .system)

    let lugarLabel = UILabel()
    let casaButton = UIButton(type: .system)
    let negocioButton = UIButton(type: .system)

    let pisoLabel = UILabel()
    let primerPisoButton = UIButton(type: .system)
    let segundoPisoButton = UIButton(type: .system)

    let fechaLabel = UILabel()
    let datePicker = UIDatePicker()

    let pagoLabel = UILabel()
    let transferenciaButton = UIButton(type: .system)
    let efectivoButton = UIButton(type: .system)

    let confirmarButton = UIButton(type: .system)

    var capacidadSeleccionada: String?
    var lugarSeleccionado: String?
    var pisoSeleccionado: String?
    var metodoPagoSeleccionado: MetodoPago?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemGroupedBackground
        scrollView.showsVerticalScrollIndicator = false
        navigationItem.title = ""
    }

    private func configurarElementos() {
        regresarButton.setTitle("Regresar", for: .normal)
        regresarButton.setTitleColor(.systemBlue, for: .normal)
        regresarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        regresarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        regresarButton.tintColor = .systemBlue
        regresarButton.addTarget(self, action: #selector(regresarAccion), for: .touchUpInside)

        tituloLabel.text = "Instalación de equipo"
        tituloLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        tituloLabel.textColor = .label
        tituloLabel.numberOfLines = 0

        descripcionLabel.text = "Cuéntanos los detalles para cotizar tu instalación."
        descripcionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        capacidadLabel.text = "¿Qué capacidad necesitas?"
        configurarLabel(capacidadLabel)
        configurarBoton(capacidad1Button, titulo: "1 tonelada", icono: "snowflake")
        configurarBoton(capacidad2Button, titulo: "2 toneladas", icono: "snowflake")
        configurarBoton(capacidad3Button, titulo: "3 toneladas", icono: "snowflake")
        [capacidad1Button, capacidad2Button, capacidad3Button].forEach {
            $0.addTarget(self, action: #selector(seleccionarCapacidad), for: .touchUpInside)
        }

        lugarLabel.text = "¿Qué tipo de lugar es?"
        configurarLabel(lugarLabel)
        configurarBoton(casaButton, titulo: "Casa habitación", icono: "house.fill")
        configurarBoton(negocioButton, titulo: "Negocio", icono: "building.2.fill")
        [casaButton, negocioButton].forEach {
            $0.addTarget(self, action: #selector(seleccionarLugar), for: .touchUpInside)
        }

        pisoLabel.text = "¿En qué piso se instalará?"
        configurarLabel(pisoLabel)
        configurarBoton(primerPisoButton, titulo: "Primer piso", icono: "1.circle.fill")
        configurarBoton(segundoPisoButton, titulo: "Segundo piso", icono: "2.circle.fill")
        [primerPisoButton, segundoPisoButton].forEach {
            $0.addTarget(self, action: #selector(seleccionarPiso), for: .touchUpInside)
        }

        fechaLabel.text = "Agenda fecha y hora para la visita"
        configurarLabel(fechaLabel)
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "es_MX")
        datePicker.minimumDate = Date()

        pagoLabel.text = "¿Cómo prefieres pagar?"
        configurarLabel(pagoLabel)
        configurarBoton(transferenciaButton, titulo: "Transferencia", icono: "creditcard.fill")
        configurarBoton(efectivoButton, titulo: "Efectivo", icono: "banknote.fill")
        [transferenciaButton, efectivoButton].forEach {
            $0.addTarget(self, action: #selector(seleccionarMetodoPago), for: .touchUpInside)
        }

        var configuracionConfirmar = UIButton.Configuration.filled()
        configuracionConfirmar.title = "Continuar con la solicitud"
        configuracionConfirmar.image = UIImage(systemName: "arrow.right")
        configuracionConfirmar.imagePlacement = .trailing
        configuracionConfirmar.imagePadding = 10
        configuracionConfirmar.baseBackgroundColor = .systemBlue
        configuracionConfirmar.baseForegroundColor = .white
        configuracionConfirmar.cornerStyle = .large
        configuracionConfirmar.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        confirmarButton.configuration = configuracionConfirmar
        confirmarButton.layer.cornerRadius = 18
        confirmarButton.addTarget(self, action: #selector(continuarAccion), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let subviews = [
            regresarButton, tituloLabel, descripcionLabel,
            capacidadLabel, capacidad1Button, capacidad2Button, capacidad3Button,
            lugarLabel, casaButton, negocioButton,
            pisoLabel, primerPisoButton, segundoPisoButton,
            fechaLabel, datePicker,
            pagoLabel, transferenciaButton, efectivoButton,
            confirmarButton
        ]
        subviews.forEach {
            contenidoView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contenidoView.translatesAutoresizingMaskIntoConstraints = false
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
        seleccionado.layer.borderColor = UIColor.systemBlue.cgColor
        seleccionado.configuration?.baseBackgroundColor = .systemBlue
        seleccionado.configuration?.baseForegroundColor = .white
    }

    private func configurarLayout() {
        let elementos = [
            scrollView, contenidoView, regresarButton, tituloLabel, descripcionLabel,
            capacidadLabel, capacidad1Button, capacidad2Button, capacidad3Button,
            lugarLabel, casaButton, negocioButton,
            pisoLabel, primerPisoButton, segundoPisoButton,
            fechaLabel, datePicker,
            pagoLabel, transferenciaButton, efectivoButton,
            confirmarButton
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

            capacidadLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 28),
            capacidadLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            capacidadLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            capacidad1Button.topAnchor.constraint(equalTo: capacidadLabel.bottomAnchor, constant: 14),
            capacidad1Button.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            capacidad1Button.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            capacidad1Button.heightAnchor.constraint(equalToConstant: 58),

            capacidad2Button.topAnchor.constraint(equalTo: capacidad1Button.bottomAnchor, constant: 10),
            capacidad2Button.leadingAnchor.constraint(equalTo: capacidad1Button.leadingAnchor),
            capacidad2Button.trailingAnchor.constraint(equalTo: capacidad1Button.trailingAnchor),
            capacidad2Button.heightAnchor.constraint(equalToConstant: 58),

            capacidad3Button.topAnchor.constraint(equalTo: capacidad2Button.bottomAnchor, constant: 10),
            capacidad3Button.leadingAnchor.constraint(equalTo: capacidad1Button.leadingAnchor),
            capacidad3Button.trailingAnchor.constraint(equalTo: capacidad1Button.trailingAnchor),
            capacidad3Button.heightAnchor.constraint(equalToConstant: 58),

            lugarLabel.topAnchor.constraint(equalTo: capacidad3Button.bottomAnchor, constant: 28),
            lugarLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            lugarLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            casaButton.topAnchor.constraint(equalTo: lugarLabel.bottomAnchor, constant: 14),
            casaButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            casaButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            casaButton.heightAnchor.constraint(equalToConstant: 58),

            negocioButton.topAnchor.constraint(equalTo: casaButton.bottomAnchor, constant: 10),
            negocioButton.leadingAnchor.constraint(equalTo: casaButton.leadingAnchor),
            negocioButton.trailingAnchor.constraint(equalTo: casaButton.trailingAnchor),
            negocioButton.heightAnchor.constraint(equalToConstant: 58),

            pisoLabel.topAnchor.constraint(equalTo: negocioButton.bottomAnchor, constant: 28),
            pisoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            pisoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            primerPisoButton.topAnchor.constraint(equalTo: pisoLabel.bottomAnchor, constant: 14),
            primerPisoButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            primerPisoButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            primerPisoButton.heightAnchor.constraint(equalToConstant: 58),

            segundoPisoButton.topAnchor.constraint(equalTo: primerPisoButton.bottomAnchor, constant: 10),
            segundoPisoButton.leadingAnchor.constraint(equalTo: primerPisoButton.leadingAnchor),
            segundoPisoButton.trailingAnchor.constraint(equalTo: primerPisoButton.trailingAnchor),
            segundoPisoButton.heightAnchor.constraint(equalToConstant: 58),

            fechaLabel.topAnchor.constraint(equalTo: segundoPisoButton.bottomAnchor, constant: 28),
            fechaLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            fechaLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            datePicker.topAnchor.constraint(equalTo: fechaLabel.bottomAnchor, constant: 12),
            datePicker.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),

            pagoLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 28),
            pagoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            pagoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            transferenciaButton.topAnchor.constraint(equalTo: pagoLabel.bottomAnchor, constant: 14),
            transferenciaButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            transferenciaButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            transferenciaButton.heightAnchor.constraint(equalToConstant: 58),

            efectivoButton.topAnchor.constraint(equalTo: transferenciaButton.bottomAnchor, constant: 10),
            efectivoButton.leadingAnchor.constraint(equalTo: transferenciaButton.leadingAnchor),
            efectivoButton.trailingAnchor.constraint(equalTo: transferenciaButton.trailingAnchor),
            efectivoButton.heightAnchor.constraint(equalToConstant: 58),

            confirmarButton.topAnchor.constraint(equalTo: efectivoButton.bottomAnchor, constant: 32),
            confirmarButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            confirmarButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            confirmarButton.heightAnchor.constraint(equalToConstant: 58),
            confirmarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -32)
        ])
    }

    @objc private func regresarAccion() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func seleccionarCapacidad(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [capacidad1Button, capacidad2Button, capacidad3Button])
        if sender == capacidad1Button {
            capacidadSeleccionada = "1 tonelada"
        } else if sender == capacidad2Button {
            capacidadSeleccionada = "2 toneladas"
        } else {
            capacidadSeleccionada = "3 toneladas"
        }
    }

    @objc private func seleccionarLugar(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [casaButton, negocioButton])
        lugarSeleccionado = (sender == casaButton) ? "Casa habitación" : "Negocio"
    }

    @objc private func seleccionarPiso(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [primerPisoButton, segundoPisoButton])
        pisoSeleccionado = (sender == primerPisoButton) ? "Primer piso" : "Segundo piso"
    }

    @objc private func seleccionarMetodoPago(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [transferenciaButton, efectivoButton])
        metodoPagoSeleccionado = (sender == transferenciaButton) ? .transferencia : .efectivo
    }

    @objc private func continuarAccion() {
        guard let capacidad = capacidadSeleccionada else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona la capacidad del equipo.")
            return
        }
        guard let lugar = lugarSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el tipo de lugar.")
            return
        }
        guard let piso = pisoSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el piso de la instalación.")
            return
        }
        guard let metodoPago = metodoPagoSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona tu método de pago.")
            return
        }

        let solicitud = SolicitudInstalacion(
            capacidad: capacidad,
            tipoLugar: lugar,
            piso: piso,
            fechaHoraCita: datePicker.date,
            metodoPago: metodoPago
        )

        let pantalla = ConfirmarSolicitudViewController(solicitud: solicitud) {
            NotificacionesManager.notificarUnDiaAntes(
                fechaCita: solicitud.fechaHoraCita,
                titulo: "Recordatorio de instalación",
                mensaje: "Mañana es tu instalación de \(solicitud.capacidad). ¡Te esperamos!"
            )
            NotificacionesManager.notificarUnDiaAntes(
                fechaCita: solicitud.fechaHoraCita,
                titulo: "Instalación agendada",
                mensaje: "\(SesionManager.nombreUsuarioActual) tiene una instalación (\(solicitud.capacidad)) mañana."
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
