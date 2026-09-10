import UIKit

/// Lo que el Presenter le puede pedir a la vista: solo actualizaciones de
/// interfaz, nunca decisiones de negocio.
protocol CompraAireViewProtocol: AnyObject {
    func mostrarCapacidad(_ titulo: String)
    func mostrarTipo(_ titulo: String)
    func marcarVoltaje(_ voltaje: String)
    func desmarcarVoltaje110()
    func marcarMetodoPago(_ metodoPago: MetodoPago)
    func marcarFactura(_ factura: Bool)
    func mostrarAlerta(titulo: String, mensaje: String)
}

/// Lo que la vista le puede avisar al Presenter: eventos de usuario, en
/// crudo, sin ninguna validación hecha todavía.
protocol CompraAirePresenterProtocol: AnyObject {
    var capacidadesSugeridas: [Int] { get }
    var tiposEquipo: [String] { get }

    func vistaSeCargo()
    func vistaVaAAparecer()
    func seleccionoCapacidad(toneladas: Int, titulo: String)
    func seleccionoTipo(_ tipo: String)
    func intentoSeleccionarVoltaje(_ voltaje: String)
    func seleccionoMetodoPago(_ metodoPago: MetodoPago)
    func seleccionoFactura(_ factura: Bool)
    func presionoRegresar()
    func presionoSolicitar()
}

final class CompraAirePresenter: CompraAirePresenterProtocol {

    weak var vista: (UIViewController & CompraAireViewProtocol)?

    private let interactor: CompraAireInteractorProtocol
    private let router: CompraAireRouterProtocol

    private var capacidadSeleccionada: String?
    private var capacidadToneladas: Int?
    private var tipoSeleccionado: String?
    private var voltajeSeleccionado: String?
    private var metodoPagoSeleccionado: MetodoPago?
    private var facturaSeleccionada: Bool?

    /// Evita que un doble toque empuje la pantalla de confirmación dos veces.
    private var estaProcesandoSolicitud = false

    var capacidadesSugeridas: [Int] { interactor.capacidadesSugeridas }
    var tiposEquipo: [String] { interactor.tiposEquipo }

    init(interactor: CompraAireInteractorProtocol, router: CompraAireRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func vistaSeCargo() {}

    func vistaVaAAparecer() {
        estaProcesandoSolicitud = false
    }

    func seleccionoCapacidad(toneladas: Int, titulo: String) {
        capacidadSeleccionada = titulo
        capacidadToneladas = toneladas
        vista?.mostrarCapacidad(titulo)
        rechazarVoltajeSiYaNoEsCompatible()
    }

    func seleccionoTipo(_ tipo: String) {
        tipoSeleccionado = tipo
        vista?.mostrarTipo(tipo)
    }

    func intentoSeleccionarVoltaje(_ voltaje: String) {
        if let toneladas = capacidadToneladas, !interactor.esVoltajeCompatible(conToneladas: toneladas, voltaje: voltaje) {
            vista?.mostrarAlerta(
                titulo: "Voltaje no disponible",
                mensaje: "Los equipos mayores a 1 tonelada solo están disponibles en 220V."
            )
            return
        }

        voltajeSeleccionado = voltaje
        vista?.marcarVoltaje(voltaje)
    }

    func seleccionoMetodoPago(_ metodoPago: MetodoPago) {
        metodoPagoSeleccionado = metodoPago
        vista?.marcarMetodoPago(metodoPago)
    }

    func seleccionoFactura(_ factura: Bool) {
        facturaSeleccionada = factura
        vista?.marcarFactura(factura)
    }

    func presionoRegresar() {
        guard let vista else { return }
        router.regresar(desde: vista)
    }

    func presionoSolicitar() {
        guard !estaProcesandoSolicitud else { return }

        guard let capacidad = capacidadSeleccionada else {
            vista?.mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona la capacidad del equipo.")
            return
        }
        guard let tipo = tipoSeleccionado else {
            vista?.mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el tipo de equipo.")
            return
        }
        guard let voltaje = voltajeSeleccionado else {
            vista?.mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona el voltaje.")
            return
        }
        if let toneladas = capacidadToneladas, !interactor.esVoltajeCompatible(conToneladas: toneladas, voltaje: voltaje) {
            vista?.mostrarAlerta(
                titulo: "Combinación inválida",
                mensaje: "Los equipos mayores a 1 tonelada solo están disponibles en 220V."
            )
            return
        }
        guard let metodoPago = metodoPagoSeleccionado else {
            vista?.mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Selecciona tu método de pago.")
            return
        }
        guard let factura = facturaSeleccionada else {
            vista?.mostrarAlerta(titulo: "Falta seleccionar", mensaje: "Indica si necesitas factura.")
            return
        }
        guard let vista else { return }

        let solicitud = interactor.construirSolicitud(
            capacidad: capacidad,
            tipo: tipo,
            voltaje: voltaje,
            metodoPago: metodoPago,
            factura: factura
        )

        estaProcesandoSolicitud = true

        router.mostrarConfirmacion(desde: vista, solicitud: solicitud) { [interactor] in
            interactor.notificarNuevaCotizacion(solicitud)
        }
    }

    /// Si ya había 110V elegido y la nueva capacidad ya no es compatible con
    /// eso, se desmarca y se avisa — misma regla que en
    /// `intentoSeleccionarVoltaje`, pero disparada desde el otro lado
    /// (cambiar la capacidad en vez de cambiar el voltaje).
    private func rechazarVoltajeSiYaNoEsCompatible() {
        guard
            let toneladas = capacidadToneladas,
            voltajeSeleccionado == "110V",
            !interactor.esVoltajeCompatible(conToneladas: toneladas, voltaje: "110V")
        else { return }

        voltajeSeleccionado = nil
        vista?.desmarcarVoltaje110()
        vista?.mostrarAlerta(
            titulo: "Voltaje no disponible",
            mensaje: "Los equipos mayores a 1 tonelada solo están disponibles en 220V. Quitamos tu selección de 110V — elige 220V para continuar."
        )
    }
}
