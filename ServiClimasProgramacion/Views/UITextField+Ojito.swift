import UIKit

extension UITextField {

    /// Agrega un botón de "ojito" a la derecha del campo para alternar
    /// entre contraseña visible y oculta.
    func agregarBotonOjito() {
        isSecureTextEntry = true

        let boton = UIButton(type: .custom)
        boton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        boton.tintColor = .secondaryLabel
        boton.frame = CGRect(x: 0, y: 0, width: 28, height: 24)
        boton.addTarget(self, action: #selector(alternarVisibilidadContrasena), for: .touchUpInside)

        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
        boton.center = CGPoint(x: 20, y: contenedor.bounds.midY)
        contenedor.addSubview(boton)

        rightView = contenedor
        rightViewMode = .always
    }

    @objc private func alternarVisibilidadContrasena(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        let nombreIcono = isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: nombreIcono), for: .normal)

        // Evita que el cursor salte al inicio del campo al alternar la visibilidad
        if let textoExistente = text {
            text = ""
            insertText(textoExistente)
        }
    }
}
