import UIKit
import FirebaseAuth

class NuestrosServiciosViewController: UIViewController {

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let regresarButton = UIButton(type: .system)
    let saludoLabel = UILabel()
    let tituloLabel = UILabel()
    let servicioRequeridoLabel = UILabel()

    let mantenimientoButton = UIButton(type: .system)
    let instalacionButton = UIButton(type: .system)
    let reparacionButton = UIButton(type: .system)
    let compraButton = UIButton(type: .system)
    let misSolicitudesButton = UIButton(type: .system)
    let adminButton = UIButton(type: .system)
    let cerrarSesionButton = UIButton(type: .system)

    private lazy var esAdmin = AdminConfig.esAdmin(correo: Auth.auth().currentUser?.email)

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

        saludoLabel.text = "Hola, \(SesionManager.nombreUsuarioActual) 👋"
        saludoLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        saludoLabel.textColor = .secondaryLabel
        saludoLabel.textAlignment = .left

        tituloLabel.text = "Nuestros Servicios"
        tituloLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        tituloLabel.textColor = .label
        tituloLabel.textAlignment = .left

        servicioRequeridoLabel.text = "¿Qué servicio necesitas?"
        servicioRequeridoLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        servicioRequeridoLabel.textColor = .secondaryLabel
        servicioRequeridoLabel.textAlignment = .left

        configurarBoton(
            boton: mantenimientoButton,
            titulo: "Mantenimiento",
            descripcion: "Limpieza y revisión preventiva",
            icono: "wrench.and.screwdriver.fill",
            color: .systemBlue
        )
        mantenimientoButton.addTarget(self, action: #selector(mantenimientoAccion), for: .touchUpInside)

        configurarBoton(
            boton: instalacionButton,
            titulo: "Instalación",
            descripcion: "Instalación profesional de equipos",
            icono: "snowflake",
            color: .systemBlue
        )
        instalacionButton.addTarget(self, action: #selector(instalacionAccion), for: .touchUpInside)

        configurarBoton(
            boton: reparacionButton,
            titulo: "Reparación",
            descripcion: "Diagnóstico y solución de fallas",
            icono: "wrench.adjustable.fill",
            color: .systemBlue
        )
        reparacionButton.addTarget(self, action: #selector(reparacionAccion), for: .touchUpInside)

        configurarBoton(
            boton: compraButton,
            titulo: "Comprar aire acondicionado",
            descripcion: "Encuentra el equipo ideal para tu espacio",
            icono: "cart.fill",
            color: .systemIndigo
        )
        compraButton.addTarget(self, action: #selector(compraAccion), for: .touchUpInside)

        configurarBoton(
            boton: misSolicitudesButton,
            titulo: "Mis solicitudes",
            descripcion: "Consulta el estado de tus citas y servicios",
            icono: "list.bullet.rectangle.fill",
            color: .systemTeal
        )
        misSolicitudesButton.addTarget(self, action: #selector(misSolicitudesAccion), for: .touchUpInside)

        if esAdmin {
            configurarBoton(
                boton: adminButton,
                titulo: "Panel de Administración",
                descripcion: "Ver todas las solicitudes de servicio",
                icono: "list.clipboard.fill",
                color: .systemGray
            )
            adminButton.addTarget(self, action: #selector(adminAccion), for: .touchUpInside)
        }

        cerrarSesionButton.setTitle("Cerrar sesión", for: .normal)
        cerrarSesionButton.setTitleColor(.systemRed, for: .normal)
        cerrarSesionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cerrarSesionButton.backgroundColor = .systemRed.withAlphaComponent(0.08)
        cerrarSesionButton.layer.cornerRadius = 14
        cerrarSesionButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        cerrarSesionButton.addTarget(self, action: #selector(cerrarSesionAccion), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        var subviews: [UIView] = [
            regresarButton,
            saludoLabel,
            tituloLabel,
            servicioRequeridoLabel,
            mantenimientoButton,
            instalacionButton,
            reparacionButton,
            compraButton,
            misSolicitudesButton,
            cerrarSesionButton
        ]

        if esAdmin {
            subviews.append(adminButton)
        }

        subviews.forEach {
            contenidoView.addSubview($0)
        }
    }

    private func configurarBoton(
        boton: UIButton,
        titulo: String,
        descripcion: String,
        icono: String,
        color: UIColor
    ) {
        var configuracion = UIButton.Configuration.filled()
        configuracion.title = titulo
        configuracion.subtitle = descripcion
        configuracion.image = UIImage(systemName: icono)
        configuracion.imagePlacement = .leading
        configuracion.imagePadding = 16
        configuracion.baseForegroundColor = .white
        configuracion.baseBackgroundColor = color
        configuracion.cornerStyle = .large
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)

        configuracion.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            return nuevos
        }

        configuracion.subtitleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            nuevos.foregroundColor = UIColor.white.withAlphaComponent(0.85)
            return nuevos
        }

        boton.configuration = configuracion
        boton.layer.cornerRadius = 18
        boton.layer.shadowColor = UIColor.black.cgColor
        boton.layer.shadowOpacity = 0.12
        boton.layer.shadowOffset = CGSize(width: 0, height: 4)
        boton.layer.shadowRadius = 8
        boton.clipsToBounds = false
        boton.accessibilityTraits = .button
        boton.accessibilityLabel = titulo
        boton.accessibilityHint = descripcion
    }

    private func configurarLayout() {
        var elementos: [UIView] = [
            scrollView,
            contenidoView,
            regresarButton,
            saludoLabel,
            tituloLabel,
            servicioRequeridoLabel,
            mantenimientoButton,
            instalacionButton,
            reparacionButton,
            compraButton,
            misSolicitudesButton,
            cerrarSesionButton
        ]

        if esAdmin {
            elementos.append(adminButton)
        }

        elementos.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

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

            saludoLabel.topAnchor.constraint(equalTo: regresarButton.bottomAnchor, constant: 16),
            saludoLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 24),
            saludoLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -24),

            tituloLabel.topAnchor.constraint(equalTo: saludoLabel.bottomAnchor, constant: 4),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 24),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -24),

            servicioRequeridoLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 8),
            servicioRequeridoLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 24),
            servicioRequeridoLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -24),

            mantenimientoButton.topAnchor.constraint(equalTo: servicioRequeridoLabel.bottomAnchor, constant: 24),
            mantenimientoButton.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 20),
            mantenimientoButton.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -20),
            mantenimientoButton.heightAnchor.constraint(equalToConstant: 76),

            instalacionButton.topAnchor.constraint(equalTo: mantenimientoButton.bottomAnchor, constant: 14),
            instalacionButton.leadingAnchor.constraint(equalTo: mantenimientoButton.leadingAnchor),
            instalacionButton.trailingAnchor.constraint(equalTo: mantenimientoButton.trailingAnchor),
            instalacionButton.heightAnchor.constraint(equalToConstant: 76),

            reparacionButton.topAnchor.constraint(equalTo: instalacionButton.bottomAnchor, constant: 14),
            reparacionButton.leadingAnchor.constraint(equalTo: mantenimientoButton.leadingAnchor),
            reparacionButton.trailingAnchor.constraint(equalTo: mantenimientoButton.trailingAnchor),
            reparacionButton.heightAnchor.constraint(equalToConstant: 76),

            compraButton.topAnchor.constraint(equalTo: reparacionButton.bottomAnchor, constant: 14),
            compraButton.leadingAnchor.constraint(equalTo: mantenimientoButton.leadingAnchor),
            compraButton.trailingAnchor.constraint(equalTo: mantenimientoButton.trailingAnchor),
            compraButton.heightAnchor.constraint(equalToConstant: 76),

            misSolicitudesButton.topAnchor.constraint(equalTo: compraButton.bottomAnchor, constant: 14),
            misSolicitudesButton.leadingAnchor.constraint(equalTo: mantenimientoButton.leadingAnchor),
            misSolicitudesButton.trailingAnchor.constraint(equalTo: mantenimientoButton.trailingAnchor),
            misSolicitudesButton.heightAnchor.constraint(equalToConstant: 76)
        ])

        if esAdmin {
            NSLayoutConstraint.activate([
                adminButton.topAnchor.constraint(equalTo: misSolicitudesButton.bottomAnchor, constant: 14),
                adminButton.leadingAnchor.constraint(equalTo: mantenimientoButton.leadingAnchor),
                adminButton.trailingAnchor.constraint(equalTo: mantenimientoButton.trailingAnchor),
                adminButton.heightAnchor.constraint(equalToConstant: 76),

                cerrarSesionButton.topAnchor.constraint(equalTo: adminButton.bottomAnchor, constant: 32)
            ])
        } else {
            NSLayoutConstraint.activate([
                cerrarSesionButton.topAnchor.constraint(equalTo: misSolicitudesButton.bottomAnchor, constant: 32)
            ])
        }

        NSLayoutConstraint.activate([
            cerrarSesionButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            cerrarSesionButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -32)
        ])
    }

    @objc private func regresarAccion() {
        if let navigationVC = self.navigationController {
            navigationVC.popViewController(animated: true)
        } else {
            let inicioVC = InicioViewController()
            inicioVC.modalPresentationStyle = .fullScreen
            present(inicioVC, animated: true, completion: nil)
        }
    }

    @objc private func mantenimientoAccion() {
        navigationController?.pushViewController(MantenimientoViewController(), animated: true)
    }

    @objc private func instalacionAccion() {
        navigationController?.pushViewController(InstalacionViewController(), animated: true)
    }

    @objc private func reparacionAccion() {
        navigationController?.pushViewController(ReparacionViewController(), animated: true)
    }

    @objc private func compraAccion() {
        navigationController?.pushViewController(CompraAireViewController(), animated: true)
    }

    @objc private func misSolicitudesAccion() {
        navigationController?.pushViewController(MisSolicitudesViewController(), animated: true)
    }

    @objc private func adminAccion() {
        navigationController?.pushViewController(AdminViewController(), animated: true)
    }

    @objc private func cerrarSesionAccion() {
        SesionManager.cerrarSesion()
        navigationController?.popToRootViewController(animated: true)
    }
}
