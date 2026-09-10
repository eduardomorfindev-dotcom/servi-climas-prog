import UIKit

/// Navegación de la pantalla "Comprar aire acondicionado": a dónde ir y
/// cómo armar el módulo completo.
protocol CompraAireRouterProtocol: AnyObject {
    func regresar(desde vista: UIViewController)

    func mostrarConfirmacion(
        desde vista: UIViewController,
        solicitud: SolicitudCompraAire,
        alConfirmar: @escaping () -> Void
    )
}

final class CompraAireRouter: CompraAireRouterProtocol {

    /// Arma el módulo completo (View + Presenter + Interactor + Router) y
    /// regresa la pantalla ya lista para empujarla al stack de navegación.
    static func crearModulo() -> UIViewController {
        let interactor = CompraAireInteractor()
        let router = CompraAireRouter()
        let presenter = CompraAirePresenter(interactor: interactor, router: router)
        let vista = CompraAireViewController(presenter: presenter)
        presenter.vista = vista
        return vista
    }

    func regresar(desde vista: UIViewController) {
        vista.navigationController?.popViewController(animated: true)
    }

    func mostrarConfirmacion(
        desde vista: UIViewController,
        solicitud: SolicitudCompraAire,
        alConfirmar: @escaping () -> Void
    ) {
        let pantalla = ConfirmarSolicitudViewController(solicitud: solicitud, alConfirmar: alConfirmar)
        vista.navigationController?.pushViewController(pantalla, animated: true)
    }
}
