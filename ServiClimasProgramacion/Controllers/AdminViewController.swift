import UIKit
import FirebaseFirestore

/// Panel de administración: lista en tiempo real todas las solicitudes de
/// servicio guardadas en Firestore (colección "solicitudes"), sin importar
/// qué cliente las haya creado. Solo debe llegar aquí el correo definido en
/// `AdminConfig.correoAdmin`.
class AdminViewController: UIViewController {

    private struct FilaSolicitud {
        let servicio: String
        let nombreCliente: String
        let direccion: String
        let fecha: Date?
        let fechaCita: Date?
    }

    private let regresarButton = UIButton(type: .system)
    private let tituloLabel = UILabel()
    private let vacioLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var filas: [FilaSolicitud] = []
    private var listener: ListenerRegistration?

    private let celdaId = "celdaSolicitud"

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPantalla()
        configurarElementos()
        configurarLayout()
        escucharSolicitudes()
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

        tituloLabel.text = "Panel de Administración"
        tituloLabel.font = .systemFont(ofSize: 28, weight: .bold)
        tituloLabel.textColor = .label

        vacioLabel.text = "Todavía no hay solicitudes de servicio."
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

    private func escucharSolicitudes() {
        listener = Firestore.firestore()
            .collection("solicitudes")
            .order(by: "fecha", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if error != nil {
                    self.vacioLabel.text = "No se pudieron cargar las solicitudes. Revisa tu conexión."
                    self.vacioLabel.isHidden = false
                    return
                }

                self.filas = (snapshot?.documents ?? []).map { documento in
                    let datos = documento.data()
                    return FilaSolicitud(
                        servicio: datos["servicio"] as? String ?? "Servicio",
                        nombreCliente: datos["nombreUsuario"] as? String ?? "Cliente",
                        direccion: datos["direccionUsuario"] as? String ?? "Sin dirección registrada",
                        fecha: (datos["fecha"] as? Timestamp)?.dateValue(),
                        fechaCita: (datos["fechaCita"] as? Timestamp)?.dateValue()
                    )
                }

                self.vacioLabel.isHidden = !self.filas.isEmpty
                self.tableView.reloadData()
            }
    }

    @objc private func regresarAccion() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView

extension AdminViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: celdaId, for: indexPath)
        let fila = filas[indexPath.row]

        var contenido = celda.defaultContentConfiguration()
        contenido.text = "\(fila.servicio) — \(fila.nombreCliente)"
        contenido.secondaryText = "\(fila.direccion)\n\(textoFecha(fila))"
        contenido.secondaryTextProperties.numberOfLines = 2
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
