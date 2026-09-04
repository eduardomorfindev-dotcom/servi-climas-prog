# ServiClimasProgramacion

Proyecto de práctica: réplica funcional de **ServiClimasApp**, construida como un
proyecto de Xcode completamente independiente, 100% programático en UIKit
(sin Storyboards para las pantallas, sin SwiftUI).

Se conecta al **mismo backend de Firebase** que la app original (mismo
`GoogleService-Info.plist`, mismo proyecto de Firebase Auth y Firestore), así
que los usuarios y las solicitudes que crea esta app son los mismos datos que
usa ServiClimasApp.

## Estructura de carpetas

```
ServiClimasProgramacion/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Controllers/     ← todas las pantallas (UIViewController)
├── Services/
│   └── Network/     ← capa de acceso a Firebase (Auth, Firestore, notificaciones)
├── Models/           ← datos puros: solicitudes, método de pago, config de admin
├── Views/             ← componentes de UI reutilizables (ej. botón "ojito" de contraseña)
├── Assets.xcassets
├── Base.lproj/        ← LaunchScreen y Main storyboard base (no usados para la navegación)
├── GoogleService-Info.plist
└── Info.plist
```

## Flujo de autenticación (dos pasos)

1. **Correo y contraseña**: `InicioViewController` / `RegistroViewController`
   usan Firebase Authentication (`Services/Network/SesionManager.swift`).
2. **Verificación de correo**: `VerificacionViewController` exige confirmar el
   correo (enlace real de Firebase, `sendEmailVerification`) antes de seguir.
3. **Verificación en dos pasos (TOTP)**: justo después, `ConfigurarAutenticadorViewController`
   ofrece activar un segundo factor real usando una app autenticadora (Google
   Authenticator, Microsoft Authenticator, Authy, o el Llavero de iOS) — un
   código QR + Firebase Multi-Factor Authentication. **Es gratis**: TOTP no
   manda SMS ni nada por red, así que no debería requerir el plan de pago
   "Blaze" de Firebase (a diferencia de la verificación por SMS). Solo hace
   falta activar "Multi-factor authentication" → "Authenticator apps (TOTP)"
   en Firebase Console → Authentication → Sign-in method. Este paso es
   omitible ("Configurar más tarde") para no bloquear la app mientras eso no
   esté activado. Una vez activado, cada login pide el código de la app
   (`CodigoAutenticadorViewController`).

También incluye `RecuperarContrasenaViewController` (recuperar contraseña) y
`MisSolicitudesViewController` (historial de solicitudes del cliente).

## Cómo correrlo

1. Abre `ServiClimasProgramacion.xcodeproj` en Xcode.
2. Espera a que resuelva los paquetes de Swift Package Manager (Firebase).
3. Selecciona un simulador de iPhone y presiona ▶️ (⌘R).
