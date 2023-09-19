import Foundation
import UIKit
import R2Shared


/// The ReaderModule handles the presentation of publications to be read by the user.
/// It contains sub-modules implementing ReaderFormatModule to handle each format of publication (eg. CBZ, EPUB).
protocol ReaderModuleAPI {
  var delegate: ReaderModuleDelegate? { get }

  func getViewController(
    for publication: Publication,
    locator: Locator?
  ) -> (reader: ReaderViewController?, audio: AudioViewController?)?
}

protocol ReaderModuleDelegate: ModuleDelegate {}

protocol ReaderViewDelegate: ReadiumView {
  func onFullScreen(hidden: Bool)
}


final class ReaderModule: ReaderModuleAPI {
  weak var delegate: ReaderModuleDelegate?
  private let resourcesServer: ResourcesServer

  /// Sub-modules to handle different publication formats (eg. EPUB, CBZ)
  var formatModules: [ReaderFormatModule] = []

  init(
    delegate: ReaderModuleDelegate?,
    resourcesServer: ResourcesServer
  ) {
    self.delegate = delegate
    self.resourcesServer = resourcesServer

    formatModules = [
      // CBZModule(delegate: self),
      AudioModule(delegate: self),
      EPUBModule(delegate: self),
    ]

   if #available(iOS 11.0, *) {
     formatModules.append(PDFModule(delegate: self))
   }
  }

  func getViewController(
    for publication: Publication,
    locator: Locator?
  ) -> (reader: ReaderViewController?, audio: AudioViewController?)? {
    guard let module = self.formatModules.first(
      where:{ $0.publicationFormats.contains(publication.format) }
    ) else {
      print("Unable to display the publication due to an unsupported format.")
      return nil
    }

    do {
      return try module.makeReaderViewController(
        for: publication,
        locator: locator,
        resourcesServer: resourcesServer
      )
    } catch {
      print("An unexpected error occurred when attempting to build the reader view.")
      print(error)
      return nil
    }
  }

}


extension ReaderModule: ReaderFormatModuleDelegate {
  func presentAlert(_ title: String, message: String, from viewController: UIViewController) {
    delegate?.presentAlert(title, message: message, from: viewController)
  }

  func presentError(_ error: Error?, from viewController: UIViewController) {
    delegate?.presentError(error, from: viewController)
  }

}
