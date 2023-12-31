import UIKit
import R2Shared
import R2Navigator

class EPUBViewController: ReaderViewController {

    init(
      publication: Publication,
      locator: Locator?,
      resourcesServer: ResourcesServer
    ) {
      let navigator = EPUBNavigatorViewController(
        publication: publication,
        initialLocation: locator,
        resourcesServer: resourcesServer
      )

      super.init(
        navigator: navigator,
        publication: publication
      )

      navigator.delegate = self
    }

    var epubNavigator: EPUBNavigatorViewController {
      return navigator as! EPUBNavigatorViewController
    }

    override func viewDidLoad() {
      super.viewDidLoad()

      /// Set initial UI appearance.
      if let appearance = publication.userProperties.getProperty(reference: ReadiumCSSReference.appearance.rawValue) {
        setUIColor(for: appearance)
      }
    }

    internal func setUIColor(for appearance: UserProperty) {
      let colors = AssociatedColors.getColors(for: appearance)

      navigator.view.backgroundColor = colors.mainColor
      view.backgroundColor = colors.mainColor
      //
      navigationController?.navigationBar.barTintColor = colors.mainColor
      navigationController?.navigationBar.tintColor = colors.textColor

      navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colors.textColor]
    }
}

extension EPUBViewController: EPUBNavigatorDelegate {}

extension EPUBViewController: UIGestureRecognizerDelegate {

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }

}

extension EPUBViewController: UIPopoverPresentationControllerDelegate {
  // Prevent the popOver to be presented fullscreen on iPhones.
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
  {
    return .none
  }
}
