//#if LCP

import Combine
import Foundation
import UIKit
import R2Shared
import R2LCPClient
import ReadiumLCP


class LCPLibraryService: DRMLibraryService {

    private var lcpService = LCPService(client: LCPClient())
    private var lastProgress = 0
    
    lazy var contentProtection: ContentProtection? = lcpService.contentProtection()
    
    func canFulfill(_ file: URL) -> Bool {
        return file.pathExtension.lowercased() == "lcpl"
    }
    
  func fulfill(_ file: URL, onProgress: @escaping (_: Float) -> Void = { _ in }) -> AnyPublisher<DRMFulfilledPublication?, Error> {
        Future { promise in
          self.lcpService.acquirePublication(from: file, onProgress: { progress in
            switch progress {
                case .percent(let perc):
              let intPercents = Int((perc * 100).rounded(.down))
                  print(intPercents % 2)
              if intPercents % 2 == 0 && intPercents != self.lastProgress {
                    self.lastProgress = intPercents
                    return onProgress(perc)
                  }
                  return
                case .indefinite:
                return
                }
          } ) { result in
                // Removes the license file, but only if it's in the App directory (e.g. Inbox/).
                // Otherwise we might delete something from a shared location (e.g. iCloud).
                if Paths.isAppFile(at: file) {
                    try? FileManager.default.removeItem(at: file)
                }
                
                switch result {
                case .success(let pub):
                    promise(.success(DRMFulfilledPublication(
                        localURL: pub.localURL,
                        suggestedFilename: pub.suggestedFilename
                    )))
                case .failure(let error):
                    promise(.failure(error))
                case .cancelled:
                    promise(.success(nil))
                }
            }
        }.eraseToAnyPublisher()
    }
}

/// Facade to the private R2LCPClient.framework.
class LCPClient: ReadiumLCP.LCPClient {

    func createContext(jsonLicense: String, hashedPassphrase: String, pemCrl: String) throws -> LCPClientContext {
        return try R2LCPClient.createContext(jsonLicense: jsonLicense, hashedPassphrase: hashedPassphrase, pemCrl: pemCrl)
    }

    func decrypt(data: Data, using context: LCPClientContext) -> Data? {
        return R2LCPClient.decrypt(data: data, using: context as! DRMContext)
    }

    func findOneValidPassphrase(jsonLicense: String, hashedPassphrases: [String]) -> String? {
        return R2LCPClient.findOneValidPassphrase(jsonLicense: jsonLicense, hashedPassphrases: hashedPassphrases)
    }

}

//#endif
