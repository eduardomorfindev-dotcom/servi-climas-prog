import UIKit

class MantenimientoViewController: UIViewController {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let regresarButton = UIButton(type: .system)
    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let tipoEquipoLabel = UILabel()

    let convencionalButton = UIButton(type: .system)
    let inverterButton = UIButton(type: .system)
    let otroEquipoButton = UIButton(type: .system)

    let mantenimientoLabel = UILabel()

    let preventivoButton = UIButton(type: .system)
    let correctivoButton = UIButton(type: .system)

    let pagoLabel = UILabel()
    let transferenciaButton = UIButton(type: .system)
    let efectivoButton = UIButton(type: .system)

    let fechaLabel = UILabel()
    let fechaPicker = UIDatePicker()

    let horarioLabel = UILabel()
    let horarioPicker = UIDatePicker()

    let comentarioLabel = UILabel()
    let comentarioTextView = UITextView()

    let continuarButton = UIButton(type: .system)

    var equipoSeleccionado = "No seleccionado"
    var mantenimientoSeleccionado = "No seleccionado"
    var metodoPagoSeleccionado: MetodoPago?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = ""

        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true

        contenidoView.backgroundColor = .clear
    }

    private func configurarElementos() {
        regresarButton.setTitle("Regresar", for: .normal)
        regresarButton.setTitleColor(.systemBlue, for: .normal)
        regresarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        regresarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        regresarButton.tintColor = .systemBlue
        regresarButton.addTarget(self, action: #selector(regresarAccion), for: .touchUpInside)

        tituloLabel.text = "Solicitar mantenimiento"
        tituloLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        tituloLabel.textColor = .label
        tituloLabel.numberOfLines = 0

        descripcionLabel.text = "Cuéntanos un poco sobre tu equipo para ofrecerte el servicio adecuado."
        descripcionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 0

        tipoEquipoLabel.text = "¿Qué tipo de equipo tienes?"
        configurarLabel(tipoEquipoLabel)

        configurarBoton(convencionalButton, titulo: "Aire acondicionado convencional", icono: "snowflake")
        configurarBoton(inverterButton, titulo: "Aire acondicionado inverter", icono: "snowflake")
        configurarBoton(otroEquipoButton, titulo: "Otro equipo", icono: "questionmark.circle.fill")

        convencionalButton.addTarget(self, action: #selector(seleccionarEquipo), for: .touchUpInside)
        inverterButton.addTarget(self, action: #selector(seleccionarEquipo), for: .touchUpInside)
        otroEquipoButton.addTarget(self, action: #selector(seleccionarEquipo), for: .touchUpInside)

        mantenimientoLabel.text = "¿Qué mantenimiento necesitas?"
        configurarLabel(mantenimientoLabel)

        configurarBoton(preventivoButton, titulo: "Mantenimiento preventivo", icono: "checkmark.shield.fill")
        configurarBoton(correctivoButton, titulo: "Mantenimiento correctivo", icono: "wrench.and.screwdriver.fill")

        var configuracionCorrectivo = correctivoButton.configuration ?? UIButton.Configuration.filled()
        configuracionCorrectivo.title = "Mantenimiento correctivo"
        configuracionCorrectivo.subtitle = "Se sugiere cuando el aire tiene 2 años de funcionamiento"
        configuracionCorrectivo.image = UIImage(systemName: "wrench.and.screwdriver.fill")
        configuracionCorrectivo.imagePlacement = .leading
        configuracionCorrectivo.imagePadding = 12
        configuracionCorrectivo.baseForegroundColor = .label
        configuracionCorrectivo.baseBackgroundColor = .secondarySystemGroupedBackground
        configuracionCorrectivo.cornerStyle = .large
        correctivoButton.configuration = configuracionCorrectivo

        preventivoButton.addTarget(self, action: #selector(seleccionarMantenimiento), for: .touchUpInside)
        correctivoButton.addTarget(self, action: #selector(seleccionarMantenimiento), for: .touchUpInside)

        pagoLabel.text = "¿Cómo prefieres pagar?"
        configurarLabel(pagoLabel)

        configurarBoton(transferenciaButton, titulo: "Transferencia", icono: "creditcard.fill")
        configurarBoton(efectivoButton, titulo: "Efectivo", icono: "banknote.fill")
        transferenciaButton.addTarget(self, action: #selector(seleccionarMetodoPago), for: .touchUpInside)
        efectivoButton.addTarget(self, action: #selector(seleccionarMetodoPago), for: .touchUpInside)

        fechaLabel.text = "¿Qué día agendamos su servicio?"
        configurarLabel(fechaLabel)

        fechaPicker.datePickerMode = .date
        fechaPicker.preferredDatePickerStyle = .compact
        fechaPicker.minimumDate = Date()

        horarioLabel.text = "¿Qué horario prefiere?"
        configurarLabel(horarioLabel)

        horarioPicker.datePickerMode = .time
        horarioPicker.preferredDatePickerStyle = .compact

        comentarioLabel.text = "¿Algún comentario que quieras agregar?"
        configurarLabel(comentarioLabel)

        comentarioTextView.font = UIFont.systemFont(ofSize: 16)
        comentarioTextView.backgroundColor = .secondarySystemGroupedBackground
        comentarioTextView.layer.cornerRadius = 16
        comentarioTextView.layer.borderWidth = 1
        comentarioTextView.layer.borderColor = UIColor.separator.cgColor
        comentarioTextView.text = "Escribe aquí algún comentario sobre tu equipo o el servicio que necesitas..."
        comentarioTextView.textColor = .secondaryLabel
        comentarioTextView.textContainerInset = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 12)

        var configuracionContinuar = UIButton.Configuration.filled()
        configuracionContinuar.title = "Continuar"
        configuracionContinuar.image = UIImage(systemName: "arrow.right")
        configuracionContinuar.imagePlacement = .trailing
        configuracionContinuar.imagePadding = 10
        configuracionContinuar.baseBackgroundColor = .systemBlue
        configuracionContinuar.baseForegroundColor = .white
        configuracionContinuar.cornerStyle = .large
        configuracionContinuar.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)

        continuarButton.configuration = configuracionContinuar
        continuarButton.layer.cornerRadius = 18
        continuarButton.layer.shadowColor = UIColor.black.cgColor
        continuarButton.layer.shadowOpacity = 0.18
        continuarButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        continuarButton.layer.shadowRadius = 8

        continuarButton.addTarget(self, action: #selector(continuarAccion), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let elementos = [
            regresarButton, tituloLabel, descripcionLabel, tipoEquipoLabel,
            convencionalButton, inverterButton, otroEquipoButton,
            mantenimientoLabel, preventivoButton, correctivoButton,
            pagoLabel, transferenciaButton, efectivoButton,
            fechaLabel, fechaPicker, horarioLabel, horarioPicker,
            comentarioLabel, comentarioTextView, continuarButton
        ]

        elementos.forEach { contenidoView.addSubview($0) }
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
        boton.layer.shadowColor = UIColor.black.cgColor
        boton.layer.shadowOpacity = 0.06
        boton.layer.shadowOffset = CGSize(width: 0, height: 3)
        boton.layer.shadowRadius = 5
        boton.clipsToBounds = false
    }

    private func configurarLayout() {
        let elementos = [
            scrollView, contenidoView, regresarButton, tituloLabel, descripcionLabel,
            tipoEquipoLabel, convencionalButton, inverterButton, otroEquipoButton,
            mantenimientoLabel, preventivoButton, correctivoButton,
            pagoLabel, transferenciaButton, efectivoButton,
            fechaLabel, fechaPicker, horarioLabel, horarioPicker,
            comentarioLabel, comentarioTextView, continuarButton
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

            tipoEquipoLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 30),
            tipoEquipoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            tipoEquipoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            convencionalButton.topAnchor.constraint(equalTo: tipoEquipoLabel.bottomAnchor, constant: 14),
            convencionalButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            convencionalButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            convencionalButton.heightAnchor.constraint(equalToConstant: 60),

            inverterButton.topAnchor.constraint(equalTo: convencionalButton.bottomAnchor, constant: 10),
            inverterButton.leadingAnchor.constraint(equalTo: convencionalButton.leadingAnchor),
            inverterButton.trailingAnchor.constraint(equalTo: convencionalButton.trailingAnchor),
            inverterButton.heightAnchor.constraint(equalToConstant: 60),

            otroEquipoButton.topAnchor.constraint(equalTo: inverterButton.bottomAnchor, constant: 10),
            otroEquipoButton.leadingAnchor.constraint(equalTo: convencionalButton.leadingAnchor),
            otroEquipoButton.trailingAnchor.constraint(equalTo: convencionalButton.trailingAnchor),
            otroEquipoButton.heightAnchor.constraint(equalToConstant: 60),

            mantenimientoLabel.topAnchor.constraint(equalTo: otroEquipoButton.bottomAnchor, constant: 30),
            mantenimientoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            mantenimientoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            preventivoButton.topAnchor.constraint(equalTo: mantenimientoLabel.bottomAnchor, constant: 14),
            preventivoButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            preventivoButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            preventivoButton.heightAnchor.constraint(equalToConstant: 62),

            correctivoButton.topAnchor.constraint(equalTo: preventivoButton.bottomAnchor, constant: 10),
            correctivoButton.leadingAnchor.constraint(equalTo: preventivoButton.leadingAnchor),
            correctivoButton.trailingAnchor.constraint(equalTo: preventivoButton.trailingAnchor),
            correctivoButton.heightAnchor.constraint(equalToConstant: 82),

            pagoLabel.topAnchor.constraint(equalTo: correctivoButton.bottomAnchor, constant: 30),
            pagoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            pagoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            transferenciaButton.topAnchor.constraint(equalTo: pagoLabel.bottomAnchor, constant: 14),
            transferenciaButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            transferenciaButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            transferenciaButton.heightAnchor.constraint(equalToConstant: 60),

            efectivoButton.topAnchor.constraint(equalTo: transferenciaButton.bottomAnchor, constant: 10),
            efectivoButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            efectivoButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            efectivoButton.heightAnchor.constraint(equalToConstant: 60),

            fechaLabel.topAnchor.constraint(equalTo: efectivoButton.bottomAnchor, constant: 30),
            fechaLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            fechaLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            fechaPicker.topAnchor.constraint(equalTo: fechaLabel.bottomAnchor, constant: 10),
            fechaPicker.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),

            horarioLabel.topAnchor.constraint(equalTo: fechaPicker.bottomAnchor, constant: 25),
            horarioLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            horarioLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            horarioPicker.topAnchor.constraint(equalTo: horarioLabel.bottomAnchor, constant: 10),
            horarioPicker.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),

            comentarioLabel.topAnchor.constraint(equalTo: horarioPicker.bottomAnchor, constant: 25),
            comentarioLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            comentarioLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            comentarioTextView.topAnchor.constraint(equalTo: comentarioLabel.bottomAnchor, constant: 10),
            comentarioTextView.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            comentarioTextView.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            comentarioTextView.heightAnchor.constraint(equalToConstant: 120),

            continuarButton.topAnchor.constraint(equalTo: comentarioTextView.bottomAnchor, constant: 25),
            continuarButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            continuarButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            continuarButton.heightAnchor.constraint(equalToConstant: 60),
            continuarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -30)
        ])
    }

    @objc private func seleccionarEquipo(_ sender: UIButton) {
        let botones = [convencionalButton, inverterButton, otroEquipoButton]
        botones.forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.separator.cgColor
            $0.configuration?.baseBackgroundColor = .secondarySystemGroupedBackground
            $0.configuration?.baseForegroundColor = .label
        }

        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        sender.configuration?.baseBackgroundColor = .systemBlue
        sender.configuration?.baseForegroundColor = .white

        if sender == convencionalButton {
            equipoSeleccionado = "Aire acondicionado convencional"
        } else if sender == inverterButton {
            equipoSeleccionado = "Aire acondicionado inverter"
        } else if sender == otroEquipoButton {
            equipoSeleccionado = "Otro equipo"
        }
    }

    @objc private func seleccionarMantenimiento(_ sender: UIButton) {
        let botones = [preventivoButton, correctivoButton]
        botones.forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.separator.cgColor
            $0.configuration?.baseBackgroundColor = .secondarySystemGroupedBackground
            $0.configuration?.baseForegroundColor = .label
        }

        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        sender.configuration?.baseBackgroundColor = .systemBlue
        sender.configuration?.baseForegroundColor = .white

        if sender == preventivoButton {
            mantenimientoSeleccionado = "Mantenimiento preventivo"
        } else if sender == correctivoButton {
            mantenimientoSeleccionado = "Mantenimiento correctivo"
        }
    }

    @objc private func seleccionarMetodoPago(_ sender: UIButton) {
        let botones = [transferenciaButton, efectivoButton]
        botones.forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.separator.cgColor
            $0.configuration?.baseBackgroundColor = .secondarySystemGroupedBackground
            $0.configuration?.baseForegroundColor = .label
        }

        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        sender.configuration?.baseBackgroundColor = .systemBlue
        sender.configuration?.baseForegroundColor = .white

        metodoPagoSeleccionado = (sender == transferenciaButton) ? .transferencia : .efectivo
    }

    @objc private func regresarAccion() {
        if let navigationVC = self.navigationController {
            navigationVC.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func continuarAccion() {
        if equipoSeleccionado == "No seleccionado" {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el tipo de equipo que tienes.")
            return
        }

        if mantenimientoSeleccionado == "No seleccionado" {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el tipo de mantenimiento que necesitas.")
            return
        }

        guard let metodoPago = metodoPagoSeleccionado else {
            mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona tu método de pago.")
            return
        }

        var comentario = comentarioTextView.text ?? ""
        if comentario == "Escribe aquí algún comentario sobre tu equipo o el servicio que necesitas..." {
            comentario = "Sin comentarios adicionales."
        }

        let solicitud = SolicitudMantenimiento(
            tipoEquipo: equipoSeleccionado,
            tipoMantenimiento: mantenimientoSeleccionado,
            fecha: fechaPicker.date,
            hora: horarioPicker.date,
            comentario: comentario,
            metodoPago: metodoPago
        )

        let formatoFecha = DateFormatter()
        formatoFecha.locale = Locale(identifier: "es_MX")
        formatoFecha.dateStyle = .long
        let fechaTexto = formatoFecha.string(from: solicitud.fecha)

        let pantalla = ConfirmarSolicitudViewController(solicitud: solicitud) {
            NotificacionesManager.notificarInmediata(
                titulo: "Solicitud recibida",
                mensaje: "Tu solicitud de \(solicitud.tipoMantenimiento.lowercased()) fue registrada. Te contactaremos pronto."
            )
            NotificacionesManager.notificarInmediata(
                titulo: "Nueva solicitud de mantenimiento",
                mensaje: "\(SesionManager.nombreUsuarioActual) solicitó \(solicitud.tipoMantenimiento.lowercased()) para el \(fechaTexto)."
            )
            if let fechaCita = solicitud.fechaCita {
                NotificacionesManager.notificarUnDiaAntes(
                    fechaCita: fechaCita,
                    titulo: "Recordatorio de mantenimiento",
                    mensaje: "Mañana es tu \(solicitud.tipoMantenimiento.lowercased()). ¡Te esperamos!"
                )
            }
        }

        navigationController?.pushViewController(pantalla, animated: true)
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
