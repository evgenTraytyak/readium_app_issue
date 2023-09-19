import Foundation
import UIKit
import R2Shared


/// The PDF module is only available on iOS 11 and more, since it relies on PDFKit.
@available(iOS 11.0, *)
final class PDFModule: ReaderFormatModule {

    weak var delegate: ReaderFormatModuleDelegate?
    
    init(delegate: ReaderFormatModuleDelegate?) {
        self.delegate = delegate
    }
    
    var publicationFormats: [Publication.Format] {
        return [.pdf]
    }
    
    func makeReaderViewController(
      for publication: Publication,
      locator: Locator?,
      resourcesServer: ResourcesServer
    ) throws -> (reader: ReaderViewController?, audio: AudioViewController?) {
//        guard publication.metadata.identifier != nil else {
//            throw ReaderError.epubNotValid
//        }
        let pdfViewController = PDFViewController(
          publication: publication,
          locator: locator
        )
      
        pdfViewController.moduleDelegate = delegate
        return (reader: pdfViewController, audio: nil)
    }
    
}
