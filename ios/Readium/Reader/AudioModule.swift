import Foundation
import UIKit
import R2Shared


final class AudioModule: ReaderFormatModule {

    weak var delegate: ReaderFormatModuleDelegate?

    init(delegate: ReaderFormatModuleDelegate?) {
        self.delegate = delegate
    }

    var publicationFormats: [Publication.Format] {
      return [.webpub]
    }

    func makeReaderViewController(
      for publication: Publication,
      locator: Locator?,
      resourcesServer: ResourcesServer
    ) throws -> (reader: ReaderViewController?, audio: AudioViewController?) {
        guard publication.metadata.identifier != nil else {
            throw ReaderError.epubNotValid
        }
      
        

        let audioViewController = AudioViewController(
            publication: publication,
            locator: locator,
            resourcesServer: resourcesServer
        )

        return (reader: nil, audio: audioViewController)
    }

}
