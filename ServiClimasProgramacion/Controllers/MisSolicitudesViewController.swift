import UIKit
import FirebaseFirestore
import FirebaseAuth

/// Pantalla del cliente para ver sus propias solicitudes de servicio guardadas
/// en Firestore. A diferencia de AdminViewController (que ve las de todos),
/// aquí solo se listan las solicitudes cuyo "correoUsuario" es el del usuario
/// que inició sesión — esto además es lo único que permiten las reglas de
/// Firestore para un usuario que no es administrador (ver backend-automatizacion/firestore.rules).
class MisSolicitudesViewController: UIViewController {

    private struct FilaSolicitud {
        let servicio: String
        let fecha: Date?
        let fechaCita: Date?
    }

    private let regresarButton = UIButton(type: .system)
    private let tituloLabel = UILabel()
    private let vacioLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var filas: [FilaSolicitud] = []
    private var listener: ListenerRegistration?

    private let celdaId = "celdaMiSolicitud"

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
        escucharMisSolicitudes()
    }

    deinit {
        listener?.remove()
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = ""
    }

    private func configurarElementos() {
        regresarButton.setTitle("Regresar", for: .normal)
        regresarButton.setTitleColor(.systemBlue, for: .normal)
        regresarButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        regresarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        regresarButton.tintColor = .systemBlue
        regresarButton.addTarget(self, action: #selector(regresarAccion), for: .touchUpInside)

        tituloLabel.text = "Mis solicitudes"
        tituloLabel.font = .systemFont(ofSize: 28, weight: .bold)
        tituloLabel.textColor = .label

        vacioLabel.text = "Todavía no tienes solicitudes de servicio."
        vacioLabel.font = .systemFont(ofSize: 15, weight: .regular)
        vacioLabel.textColor = .secondaryLabel
        vacioLabel.textAlignment = .center
        vacioLabel.numberOfLines = 0
        vacioLabel.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: celdaId)
        tableView.backgroundColor = .clear

        [regresarButton, tituloLabel, vacioLabel, tableView].forEach { view.addSubview($0) }
    }

    private func configurarLayout() {
        [regresarButton, tituloLabel, vacioLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            regresarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            regresarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            tituloLabel.topAnchor.constraint(equalTo: regresarButton.bottomAnchor, constant: 12),
            tituloLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tituloLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            vacioLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 60),
            vacioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            vacioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            tableView.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Datos en tiempo real

    private func escucharMisSolicitudes() {
        guard let correo = Auth.auth().currentUser?.email else {
            vacioLabel.text = "Inicia sesión para ver tus solicitudes."
            vacioLabel.isHidden = false
            return
        }

        // Sin order(by:) a propósito: combinar un where con un order(by) en otro
        // campo exige un índice compuesto en Firestore. Se ordena en el cliente
        // ya con los pocos documentos que trae la consulta filtrada.
        listener = Firestore.firestore()
            .collection("solicitudes")
            .whereField("correoUsuario", isEqualTo: correo)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if error != nil {
                    self.vacioLabel.text = "No se pudieron cargar tus solicitudes. Revisa tu conexión."
                    self.vacioLabel.isHidden = false
                    return
                }

                self.filas = (snapshot?.documents ?? [])
                    .map { documento -> FilaSolicitud in
                        let datos = documento.data()
                        return FilaSolicitud(
                            servicio: datos["servicio"] as? String ?? "Servicio",
                            fecha: (datos["fecha"] as? Timestamp)?.dateValue(),
                            fechaCita: (datos["fechaCita"] as? Timestamp)?.dateValue()
                        )
                    }
                    .sorted { ($0.fecha ?? .distantPast) > ($1.fecha ?? .distantPast) }

                self.vacioLabel.isHidden = !self.filas.isEmpty
                self.tableView.reloadData()
            }
    }

    @objc private func regresarAccion() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView

extension MisSolicitudesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: celdaId, for: indexPath)
        let fila = filas[indexPath.row]

        var contenido = celda.defaultContentConfiguration()
        contenido.text = fila.servicio
        contenido.secondaryText = textoFecha(fila)
        contenido.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        contenido.secondaryTextProperties.font = .systemFont(ofSize: 13, weight: .regular)
        contenido.secondaryTextProperties.color = .secondaryLabel
        celda.contentConfiguration = contenido
        celda.selectionStyle = .none

        return celda
    }

    private func textoFecha(_ fila: FilaSolicitud) -> String {
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_MX")
        formato.dateStyle = .medium
        formato.timeStyle = .short

        if let fechaCita = fila.fechaCita {
            return "Cita: \(formato.string(from: fechaCita))"
        }
        if let fecha = fila.fecha {
            return "Solicitado: \(formato.string(from: fecha))"
        }
        return ""
    }
}
