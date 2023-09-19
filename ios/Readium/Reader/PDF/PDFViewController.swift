import Foundation
import UIKit
import R2Navigator
import R2Shared


@available(iOS 11.0, *)
final class PDFViewController: ReaderViewController {
    
    init(
      publication: Publication,
      locator: Locator?
    ) {
        let navigator = PDFNavigatorViewController(
          publication: publication,
          initialLocation: locator
        )
        
        super.init(
          navigator: navigator,
          publication: publication
        )
        
        navigator.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        ReadiumCSSReference.appearance.rawValue
      
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

@available(iOS 11.0, *)
extension PDFViewController: PDFNavigatorDelegate {
}
