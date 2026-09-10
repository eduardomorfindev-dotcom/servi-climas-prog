import UIKit

/// Pantalla "Comprar aire acondicionado". Solo construye la interfaz y
/// reenvía los toques del usuario al Presenter — ninguna decisión de
/// negocio (validaciones, reglas de voltaje, armado de la solicitud) vive
/// aquí.
final class CompraAireViewController: UIViewController {

    private let presenter: CompraAirePresenterProtocol

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let regresarButton = UIButton(type: .system)
    let tituloLabel = UILabel()
    let descripcionLabel = UILabel()

    let capacidadLabel = UILabel()
    let capacidadButton = UIButton(type: .system)

    let tipoLabel = UILabel()
    let tipoButton = UIButton(type: .system)

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

    init(presenter: CompraAirePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no está implementado")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
        presenter.vistaSeCargo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.vistaVaAAparecer()
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
        configurarBoton(capacidadButton, titulo: "Selecciona la capacidad", icono: "gauge")
        capacidadButton.menu = construirMenuCapacidad()
        capacidadButton.showsMenuAsPrimaryAction = true

        tipoLabel.text = "¿Qué tipo de equipo?"
        configurarLabel(tipoLabel)
        configurarBoton(tipoButton, titulo: "Selecciona el tipo de equipo", icono: "wind")
        tipoButton.menu = construirMenuTipo()
        tipoButton.showsMenuAsPrimaryAction = true

        voltajeLabel.text = "¿Qué voltaje maneja tu instalación?"
        configurarLabel(voltajeLabel)
        configurarBoton(voltaje110Button, titulo: "110V", icono: "powerplug.fill")
        configurarBoton(voltaje220Button, titulo: "220V", icono: "powerplug.fill")
        voltaje110Button.addTarget(self, action: #selector(seleccionarVoltaje110), for: .touchUpInside)
        voltaje220Button.addTarget(self, action: #selector(seleccionarVoltaje220), for: .touchUpInside)

        pagoLabel.text = "¿Cómo prefieres pagar?"
        configurarLabel(pagoLabel)
        configurarBoton(efectivoButton, titulo: "Efectivo", icono: "banknote.fill")
        configurarBoton(transferenciaButton, titulo: "Transferencia", icono: "creditcard.fill")
        efectivoButton.addTarget(self, action: #selector(seleccionarEfectivo), for: .touchUpInside)
        transferenciaButton.addTarget(self, action: #selector(seleccionarTransferencia), for: .touchUpInside)

        facturaLabel.text = "¿Necesitas factura?"
        configurarLabel(facturaLabel)
        configurarBoton(facturaSiButton, titulo: "Sí", icono: "doc.text.fill")
        configurarBoton(facturaNoButton, titulo: "No", icono: "xmark.circle")
        facturaSiButton.addTarget(self, action: #selector(seleccionarFacturaSi), for: .touchUpInside)
        facturaNoButton.addTarget(self, action: #selector(seleccionarFacturaNo), for: .touchUpInside)

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
            capacidadLabel, capacidadButton,
            tipoLabel, tipoButton,
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
        botones.forEach { desmarcarBoton($0) }
        seleccionado.layer.borderWidth = 2
        seleccionado.layer.borderColor = UIColor.systemIndigo.cgColor
        seleccionado.configuration?.baseBackgroundColor = .systemIndigo
        seleccionado.configuration?.baseForegroundColor = .white
    }

    private func desmarcarBoton(_ boton: UIButton) {
        boton.layer.borderWidth = 1
        boton.layer.borderColor = UIColor.separator.cgColor
        boton.configuration?.baseBackgroundColor = .secondarySystemGroupedBackground
        boton.configuration?.baseForegroundColor = .label
    }

    /// Pinta de morado el botón desplegable elegido y le pone el texto de la
    /// opción seleccionada, igual que como se marca cualquier otro botón.
    private func marcarBotonSeleccionado(_ boton: UIButton, titulo: String) {
        boton.configuration?.title = titulo
        boton.layer.borderWidth = 2
        boton.layer.borderColor = UIColor.systemIndigo.cgColor
        boton.configuration?.baseBackgroundColor = .systemIndigo
        boton.configuration?.baseForegroundColor = .white
    }

    private func configurarLayout() {
        let elementos = [
            scrollView, contenidoView, regresarButton, tituloLabel, descripcionLabel,
            capacidadLabel, capacidadButton,
            tipoLabel, tipoButton,
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

            capacidadButton.topAnchor.constraint(equalTo: capacidadLabel.bottomAnchor, constant: 14),
            capacidadButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            capacidadButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            capacidadButton.heightAnchor.constraint(equalToConstant: 58),

            tipoLabel.topAnchor.constraint(equalTo: capacidadButton.bottomAnchor, constant: 26),
            tipoLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            tipoLabel.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),

            tipoButton.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 14),
            tipoButton.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            tipoButton.trailingAnchor.constraint(equalTo: tituloLabel.trailingAnchor),
            tipoButton.heightAnchor.constraint(equalToConstant: 58),

            voltajeLabel.topAnchor.constraint(equalTo: tipoButton.bottomAnchor, constant: 26),
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

    private func construirMenuCapacidad() -> UIMenu {
        let acciones = presenter.capacidadesSugeridas.map { toneladas -> UIAction in
            let titulo = toneladas == 1 ? "1 tonelada" : "\(toneladas) toneladas"
            return UIAction(title: titulo) { [weak self] _ in
                self?.presenter.seleccionoCapacidad(toneladas: toneladas, titulo: titulo)
            }
        }
        return UIMenu(title: "¿Qué capacidad necesitas?", children: acciones)
    }

    private func construirMenuTipo() -> UIMenu {
        let acciones = presenter.tiposEquipo.map { tipo -> UIAction in
            UIAction(title: tipo) { [weak self] _ in
                self?.presenter.seleccionoTipo(tipo)
            }
        }
        return UIMenu(title: "¿Qué tipo de equipo?", children: acciones)
    }

    @objc private func regresarAccion() {
        presenter.presionoRegresar()
    }

    @objc private func seleccionarVoltaje110() {
        presenter.intentoSeleccionarVoltaje("110V")
    }

    @objc private func seleccionarVoltaje220() {
        presenter.intentoSeleccionarVoltaje("220V")
    }

    @objc private func seleccionarEfectivo() {
        presenter.seleccionoMetodoPago(.efectivo)
    }

    @objc private func seleccionarTransferencia() {
        presenter.seleccionoMetodoPago(.transferencia)
    }

    @objc private func seleccionarFacturaSi() {
        presenter.seleccionoFactura(true)
    }

    @objc private func seleccionarFacturaNo() {
        presenter.seleccionoFactura(false)
    }

    @objc private func solicitarAccion() {
        presenter.presionoSolicitar()
    }
}

// MARK: - CompraAireViewProtocol

extension CompraAireViewController: CompraAireViewProtocol {

    func mostrarCapacidad(_ titulo: String) {
        marcarBotonSeleccionado(capacidadButton, titulo: titulo)
    }

    func mostrarTipo(_ titulo: String) {
        marcarBotonSeleccionado(tipoButton, titulo: titulo)
    }

    func marcarVoltaje(_ voltaje: String) {
        let seleccionado = voltaje == "110V" ? voltaje110Button : voltaje220Button
        marcarSeleccion(seleccionado, entre: [voltaje110Button, voltaje220Button])
    }

    func desmarcarVoltaje110() {
        desmarcarBoton(voltaje110Button)
    }

    func marcarMetodoPago(_ metodoPago: MetodoPago) {
        let seleccionado = metodoPago == .efectivo ? efectivoButton : transferenciaButton
        marcarSeleccion(seleccionado, entre: [efectivoButton, transferenciaButton])
    }

    func marcarFactura(_ factura: Bool) {
        let seleccionado = factura ? facturaSiButton : facturaNoButton
        marcarSeleccion(seleccionado, entre: [facturaSiButton, facturaNoButton])
    }

    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
