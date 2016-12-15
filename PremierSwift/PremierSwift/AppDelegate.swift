import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else { return false }
        let moviesViewController = MoviesViewController()
        let navigationController = UINavigationController(rootViewController: moviesViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return true
    }
}

