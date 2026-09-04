import UIKit

/// Paso de verificación en dos pasos durante el LOGIN: la contraseña ya fue
/// correcta, pero la cuenta tiene activada la app autenticadora, así que
/// Firebase pide confirmar el código de 6 dígitos que esa app está mostrando
/// en ese momento antes de dejar entrar de verdad.
final class CodigoAutenticadorViewController: UIViewController, UITextFieldDelegate {

    private let confirmarCodigo: (_ codigo: String, _ completion: @escaping (Result<Void, Error>) -> Void) -> Void
    private let alExito: () -> Void

    let scrollView = UIScrollView()
    let contenidoView = UIView()

    let iconoImageView = UIImageView()
    let tituloLabel = UILabel()
    let subtituloLabel = UILabel()
    let codigoTextField = UITextField()
    let confirmarButton = UIButton(type: .system)
    let cancelarButton = UIButton(type: .system)

    init(
        confirmarCodigo: @escaping (_ codigo: String, _ completion: @escaping (Result<Void, Error>) -> Void) -> Void,
        alExito: @escaping () -> Void
    ) {
        self.confirmarCodigo = confirmarCodigo
        self.alExito = alExito
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
    }

    private func configurarPantalla() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true

        let gesto = UITapGestureRecognizer(target: self, action: #selector(cerrarTeclado))
        gesto.cancelsTouchesInView = false
        view.addGestureRecognizer(gesto)
    }

    private func configurarElementos() {
        let configuracionSimbolo = UIImage.SymbolConfiguration(pointSize: 46, weight: .medium)
        iconoImageView.image = UIImage(systemName: "lock.shield", withConfiguration: configuracionSimbolo)
        iconoImageView.tintColor = .systemBlue
        iconoImageView.contentMode = .scaleAspectFit

        tituloLabel.text = "Verificación en dos pasos"
        tituloLabel.font = UIFont(name: "AvenirNext-Bold", size: 26) ?? .boldSystemFont(ofSize: 26)
        tituloLabel.textAlignment = .center
        tituloLabel.textColor = .label

        subtituloLabel.text = "Abre tu app autenticadora y escribe el código de 6 dígitos que te está mostrando ahora mismo."
        subtituloLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtituloLabel.textAlignment = .center
        subtituloLabel.textColor = .secondaryLabel
        subtituloLabel.numberOfLines = 0

        codigoTextField.placeholder = "Código de 6 dígitos"
        codigoTextField.borderStyle = .none
        codigoTextField.backgroundColor = .secondarySystemBackground
        codigoTextField.layer.cornerRadius = 14
        codigoTextField.layer.borderWidth = 1
        codigoTextField.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        codigoTextField.font = .systemFont(ofSize: 22, weight: .semibold)
        codigoTextField.textAlignment = .center
        codigoTextField.keyboardType = .numberPad
        codigoTextField.delegate = self

        confirmarButton.setTitle("Confirmar código", for: .normal)
        confirmarButton.setTitleColor(.white, for: .normal)
        confirmarButton.backgroundColor = .systemBlue
        confirmarButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        confirmarButton.layer.cornerRadius = 15
        confirmarButton.addTarget(self, action: #selector(confirmarAccion), for: .touchUpInside)

        cancelarButton.setTitle("Cancelar", for: .normal)
        cancelarButton.setTitleColor(.systemRed, for: .normal)
        cancelarButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        cancelarButton.addTarget(self, action: #selector(cancelarAccion), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contenidoView)

        let subvistas = [
            iconoImageView, tituloLabel, subtituloLabel,
            codigoTextField, confirmarButton, cancelarButton
        ]
        subvistas.forEach { contenidoView.addSubview($0) }
    }

    private func configurarLayout() {
        let elementos = [
            scrollView, contenidoView,
            iconoImageView, tituloLabel, subtituloLabel,
            codigoTextField, confirmarButton, cancelarButton
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

            iconoImageView.topAnchor.constraint(equalTo: contenidoView.topAnchor, constant: 60),
            iconoImageView.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            iconoImageView.heightAnchor.constraint(equalToConstant: 60),

            tituloLabel.topAnchor.constraint(equalTo: iconoImageView.bottomAnchor, constant: 18),
            tituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            tituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),

            subtituloLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 10),
            subtituloLabel.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 30),
            subtituloLabel.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -30),

            codigoTextField.topAnchor.constraint(equalTo: subtituloLabel.bottomAnchor, constant: 30),
            codigoTextField.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 50),
            codigoTextField.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -50),
            codigoTextField.heightAnchor.constraint(equalToConstant: 56),

            confirmarButton.topAnchor.constraint(equalTo: codigoTextField.bottomAnchor, constant: 22),
            confirmarButton.leadingAnchor.constraint(equalTo: contenidoView.leadingAnchor, constant: 25),
            confirmarButton.trailingAnchor.constraint(equalTo: contenidoView.trailingAnchor, constant: -25),
            confirmarButton.heightAnchor.constraint(equalToConstant: 52),

            cancelarButton.topAnchor.constraint(equalTo: confirmarButton.bottomAnchor, constant: 16),
            cancelarButton.centerXAnchor.constraint(equalTo: contenidoView.centerXAnchor),
            cancelarButton.bottomAnchor.constraint(equalTo: contenidoView.bottomAnchor, constant: -25)
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        confirmarAccion()
        return true
    }

    @objc private func cerrarTeclado() {
        view.endEditing(true)
    }

    @objc private func confirmarAccion() {
        let codigo = codigoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if codigo.count < 6 {
            mostrarAlerta(titulo: "Código incompleto", mensaje: "Escribe los 6 dígitos que muestra tu app autenticadora.")
            return
        }

        confirmarButton.isEnabled = false

        confirmarCodigo(codigo) { [weak self] resultado in
            guard let self else { return }
            self.confirmarButton.isEnabled = true

            switch resultado {
            case .success:
                self.alExito()
            case .failure(let error):
                self.mostrarAlerta(titulo: "No se pudo confirmar", mensaje: SesionManager.mensajeError(error))
            }
        }
    }

    @objc private func cancelarAccion() {
        navigationController?.popViewController(animated: true)
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
