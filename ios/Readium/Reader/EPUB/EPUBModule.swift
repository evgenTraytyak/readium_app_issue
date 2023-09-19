import Foundation
import UIKit
import R2Shared


final class EPUBModule: ReaderFormatModule {

    weak var delegate: ReaderFormatModuleDelegate?

    init(delegate: ReaderFormatModuleDelegate?) {
        self.delegate = delegate
    }

    var publicationFormats: [Publication.Format] {
      return [.epub]
    }

    func makeReaderViewController(
      for publication: Publication,
      locator: Locator?,
      resourcesServer: ResourcesServer
    ) throws -> (reader: ReaderViewController?, audio: AudioViewController?) {
        guard publication.metadata.identifier != nil else {
            throw ReaderError.epubNotValid
        }

        let epubViewController = EPUBViewController(
            publication: publication,
            locator: locator,
            resourcesServer: resourcesServer
        )
        epubViewController.moduleDelegate = delegate
      return (reader: epubViewController, audio: nil)
    }

}
