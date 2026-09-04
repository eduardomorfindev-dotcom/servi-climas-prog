import UIKit

class ReparacionViewController: UIViewController {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let regresarButton = UIButton(type: .system)
    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let tipoAireLabel = UILabel()
    let tipoAireStack = UIStackView()
    private let opcionesTipoAire = ["Piso", "Techo", "Ventana", "Inverter", "Convencional", "Tipo paquete"]
    private var botonesTipoAire: [UIButton] = []

    let sintomaLabel = UILabel()
    let sintomaStack = UIStackView()
    private let opcionesSintoma = ["No enfría", "Hace ruido", "Gotea agua", "No enciende", "Huele mal", "Otro"]
    private var botonesSintoma: [UIButton] = []

    let comentarioLabel = UILabel()
    let comentarioTextView = UITextView()
    let comentarioPlaceholder = "Describe con más detalle la falla (opcional)..."

    let pagoLabel = UILabel()
    let transferenciaButton = UIButton(type: .system)
    let efectivoButton = UIButton(type: .system)

    let fechaLabel = UILabel()
    let datePicker = UIDatePicker()

    let agendarButton = UIButton(type: .system)

    var tipoAireSeleccionado: String?
    var sintomaSeleccionado: String?
    var metodoPagoSeleccionado: MetodoPago?

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

        tituloLabel.text = "Reparación"
        tituloLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        tituloLabel.textColor = .label

        descripcionLabel.text = "Diagnóstico y solución de fallas"
        descripcionLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        tipoAireLabel.text = "¿Qué tipo de aire tienes?"
        configurarLabel(tipoAireLabel)
        botonesTipoAire = construirCuadricula(opciones: opcionesTipoAire, en: tipoAireStack, accion: #selector(seleccionarTipoAire))

        sintomaLabel.text = "¿Qué síntoma presenta?"
        configurarLabel(sintomaLabel)
        botonesSintoma = construirCuadricula(opciones: opcionesSintoma, en: sintomaStack, accion: #selector(seleccionarSintoma))

        comentarioLabel.text = "Comentario adicional"
        configurarLabel(comentarioLabel)
        comentarioTextView.font = UIFont.systemFont(ofSize: 16)
        comentarioTextView.text = comentarioPlaceholder
        comentarioTextView.textColor = .placeholderText
        comentarioTextView.backgroundColor = .secondarySystemGroupedBackground
        comentarioTextView.layer.cornerRadius = 14
        comentarioTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        comentarioTextView.delegate = self

        pagoLabel.text = "¿Cómo prefieres pagar?"
        configurarLabel(pagoLabel)
        configurarBotonGrande(transferenciaButton, titulo: "Transferencia", icono: "creditcard.fill")
        configurarBotonGrande(efectivoButton, titulo: "Efectivo", icono: "banknote.fill")
        [transferenciaButton, efectivoButton].forEach {
            $0.addTarget(self, action: #selector(seleccionarMetodoPago), for: .touchUpInside)
        }

        fechaLabel.text = "Agenda fecha y hora para la visita"
        configurarLabel(fechaLabel)
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "es_MX")
        datePicker.minimumDate = Date()

        var configuracion = UIButton.Configuration.filled()
        configuracion.title = "Continuar con la solicitud"
        configuracion.image = UIImage(systemName: "wrench.adjustable.fill")
        configuracion.imagePlacement = .leading
        configuracion.imagePadding = 12
        configuracion.baseForegroundColor = .white
        configuracion.baseBackgroundColor = .systemBlue
        configuracion.cornerStyle = .large
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        agendarButton.configuration = configuracion
        agendarButton.addTarget(self, action: #selector(agendarAccion), for: .touchUpInside)

        [
            regresarButton, tituloLabel, descripcionLabel,
            tipoAireLabel, tipoAireStack,
            sintomaLabel, sintomaStack,
            comentarioLabel, comentarioTextView,
            pagoLabel, transferenciaButton, efectivoButton,
            fechaLabel, datePicker,
            agendarButton
        ].forEach { contenidoView.addSubview($0) }

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)
    }

    private func configurarLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
    }

    private func configurarBotonGrande(_ boton: UIButton, titulo: String, icono: String) {
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

    /// Construye una cuadrícula de 2 columnas con botones tipo "chip" dentro
    /// de un UIStackView vertical, y regresa la lista de botones creados.
    private func construirCuadricula(opciones: [String], en contenedor: UIStackView, accion: Selector) -> [UIButton] {
        contenedor.axis = .vertical
        contenedor.spacing = 10
        contenedor.distribution = .fillEqually

        var botones: [UIButton] = []

        for indiceFila in stride(from: 0, to: opciones.count, by: 2) {
            let filaStack = UIStackView()
            filaStack.axis = .horizontal
            filaStack.spacing = 10
            filaStack.distribution = .fillEqually

            for indice in indiceFila..<min(indiceFila + 2, opciones.count) {
                let boton = crearBotonOpcion(titulo: opciones[indice])
                boton.addTarget(self, action: accion, for: .touchUpInside)
                filaStack.addArrangedSubview(boton)
                botones.append(boton)
            }

            contenedor.addArrangedSubview(filaStack)
        }

        return botones
    }

    private func crearBotonOpcion(titulo: String) -> UIButton {
        let boton = UIButton(type: .system)
        var configuracion = UIButton.Configuration.filled()
        configuracion.title = titulo
        configuracion.baseForegroundColor = .label
        configuracion.baseBackgroundColor = .secondarySystemGroupedBackground
        configuracion.cornerStyle = .medium
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10)
        configuracion.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            return nuevos
        }

        boton.configuration = configuracion
        boton.layer.cornerRadius = 12
        boton.layer.borderWidth = 1
        boton.layer.borderColor = UIColor.separator.cgColor
        boton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return boton
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
            tipoAireLabel, tipoAireStack,
            sintomaLabel, sintomaStack,
            comentarioLabel, comentarioTextView,
            pagoLabel, transferenciaButton, efectivoButton,
            fechaLabel, datePicker,
            agendarButton
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
            descripcionLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 24),
            descripcionLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -24),

            tipoAireLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 26),
            tipoAireLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            tipoAireLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            tipoAireStack.topAnchor.constraint(equalTo: tipoAireLabel.bottomAnchor, constant: 14),
            tipoAireStack.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            tipoAireStack.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            sintomaLabel.topAnchor.constraint(equalTo: tipoAireStack.bottomAnchor, constant: 26),
            sintomaLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            sintomaLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            sintomaStack.topAnchor.constraint(equalTo: sintomaLabel.bottomAnchor, constant: 14),
            sintomaStack.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            sintomaStack.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            comentarioLabel.topAnchor.constraint(equalTo: sintomaStack.bottomAnchor, constant: 26),
            comentarioLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            comentarioLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            comentarioTextView.topAnchor.constraint(equalTo: comentarioLabel.bottomAnchor, constant: 10),
            comentarioTextView.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            comentarioTextView.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            comentarioTextView.heightAnchor.constraint(equalToConstant: 100),

            pagoLabel.topAnchor.constraint(equalTo: comentarioTextView.bottomAnchor, constant: 26),
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

            fechaLabel.topAnchor.constraint(equalTo: efectivoButton.bottomAnchor, constant: 26),
            fechaLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            fechaLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            datePicker.topAnchor.constraint(equalTo: fechaLabel.bottomAnchor, constant: 12),
            datePicker.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),

            agendarButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 30),
            agendarButton.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 20),
            agendarButton.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -20),
            agendarButton.heightAnchor.constraint(equalToConstant: 56),
            agendarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -32)
        ])
    }

    @objc private func regresarAccion() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func seleccionarTipoAire(_ sender: UIButton) {
        marcarSeleccion(sender, entre: botonesTipoAire)
        if let indice = botonesTipoAire.firstIndex(of: sender) {
            tipoAireSeleccionado = opcionesTipoAire[indice]
        }
    }

    @objc private func seleccionarSintoma(_ sender: UIButton) {
        marcarSeleccion(sender, entre: botonesSintoma)
        if let indice = botonesSintoma.firstIndex(of: sender) {
            sintomaSeleccionado = opcionesSintoma[indice]
        }
    }

    @objc private func seleccionarMetodoPago(_ sender: UIButton) {
        marcarSeleccion(sender, entre: [transferenciaButton, efectivoButton])
        metodoPagoSeleccionado = (sender == transferenciaButton) ? .transferencia : .efectivo
    }

    @objc private func agendarAccion() {
        guard let tipoAire = tipoAireSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el tipo de aire acondicionado.")
            return
        }
        guard let sintoma = sintomaSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el síntoma que presenta tu equipo.")
            return
        }
        guard let metodoPago = metodoPagoSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona tu método de pago.")
            return
        }

        var comentario = comentarioTextView.text ?? ""
        if comentario == comentarioPlaceholder {
            comentario = "Sin comentarios adicionales."
        }

        let solicitud = SolicitudReparacion(
            tipoAire: tipoAire,
            sintoma: sintoma,
            comentario: comentario,
            metodoPago: metodoPago,
            fechaHoraCita: datePicker.date
        )

        let pantalla = ConfirmarSolicitudViewController(solicitud: solicitud) {
            NotificacionesManager.notificarUnDiaAntes(
                fechaCita: solicitud.fechaHoraCita,
                titulo: "Recordatorio de reparación",
                mensaje: "Mañana llega el técnico a revisar tu equipo (\(solicitud.sintoma.lowercased()))."
            )
            NotificacionesManager.notificarUnDiaAntes(
                fechaCita: solicitud.fechaHoraCita,
                titulo: "Reparación agendada",
                mensaje: "\(SesionManager.nombreUsuarioActual) tiene una reparación mañana: \(solicitud.sintoma.lowercased())."
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

extension ReparacionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == comentarioPlaceholder {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = comentarioPlaceholder
            textView.textColor = .placeholderText
        }
    }
}
