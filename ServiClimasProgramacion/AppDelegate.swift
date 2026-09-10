//
//  AppDelegate.swift
//  ServiClimasApp
//
//  Created by Pedro  on 27/08/26.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    /// Sin esto, iOS oculta las notificaciones locales (como la de bienvenida)
    /// cuando la app está abierta en primer plano, que es justo cuando se disparan.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    /// Se dispara cuando el usuario toca una notificación (con la app en
    /// segundo plano, cerrada, o en primer plano). Lee la pantalla guardada
    /// en `userInfo` (ver `NotificacionesManager`) y navega ahí, siempre que
    /// todavía haya una sesión activa.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        defer { completionHandler() }

        guard
            let valor = response.notification.request.content.userInfo[NotificacionesManager.clavePantalla] as? String,
            let pantalla = NotificacionesManager.Pantalla(rawValue: valor)
        else { return }

        navegarDesdeNotificacion(hacia: pantalla)
    }

    private func navegarDesdeNotificacion(hacia pantalla: NotificacionesManager.Pantalla) {
        guard
            Auth.auth().currentUser != nil,
            let escenaVentana = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let navegacion = escenaVentana.windows.first(where: \.isKeyWindow)?.rootViewController as? UINavigationController
        else { return }

        switch pantalla {
        case .misSolicitudes:
            navegacion.pushViewController(MisSolicitudesViewController(), animated: true)
        case .admin:
            guard AdminConfig.esAdmin(correo: Auth.auth().currentUser?.email) else { return }
            navegacion.pushViewController(AdminViewController(), animated: true)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

