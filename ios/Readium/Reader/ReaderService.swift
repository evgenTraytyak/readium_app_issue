import Combine
import Foundation
import R2Shared
import R2Streamer
import UIKit

final class ReaderService: Loggable {
  var app: AppModule?
  private var streamer: Streamer
  var publicationServer: PublicationServer?
  private var subscriptions = Set<AnyCancellable>()
  var drmLibraryServices = [DRMLibraryService]()
  
  init() {
//    do {
      self.app = AppModule()
      self.publicationServer = PublicationServer()

//      #if LCP
        drmLibraryServices.append(LCPLibraryService())
//      #endif

      streamer = Streamer(
        contentProtections: drmLibraryServices.compactMap { $0.contentProtection }
      )
      
//    } catch {
//      print("TODO: An error occurred instantiating the ReaderService")
//      print(error)
//    }
  }
  
  static func locatorFromLocation(
    _ location: NSDictionary?,
    _ publication: Publication?
  ) -> Locator? {
    guard location != nil else {
      return nil
    }

    let hasLocations = location?["locations"] != nil
    let hasChildren = location?["children"] != nil
    let hasHref = !(location!["href"] as! String).isEmpty

    // check that we're not dealing with a Link
    if ((hasChildren || hasHref) && !hasLocations) {
      guard let publication = publication else {
        return nil
      }
      guard let link = try? Link(json: location) else {
        return nil
      }
      
      return publication.locate(link)
    } else {
      return try? Locator(json: location)
    }
    
    return nil
  }

  func buildViewController(
    url: String,
    location: NSDictionary?,
    sender: UIViewController?,
    passpharse: String?,
    completion: @escaping (_ reader: ReaderViewController?, _ audio: AudioViewController?) -> Void,
    downloaded: @escaping (_: String) -> Void,
    onProgress: @escaping (_: Float) -> Void
  ) {
    guard let reader = self.app?.reader else { return }
    
    self.url(path: url)
      .flatMap { self.fulfillIfNeeded($0, onProgress: onProgress) }
      .flatMap { localURl in self.openPublication(at: localURl, allowUserInteraction: false, passpharse: passpharse, sender: sender )
          .flatMap { pub, mediaType in self.moveToDocuments(from: localURl, mediaType: mediaType, downloaded: downloaded)
            .flatMap { localURl in self.openPublication(at: localURl, allowUserInteraction: true, passpharse: passpharse, sender: sender ) }
          }
      }
      .flatMap { pub, _ in self.checkIsReadable(publication: pub) }
      .sink(
        receiveCompletion: { error in
          print(">>>>>>>>>>> TODO: handle me", error)
        },
        receiveValue: { [weak self] pub in
          self?.preparePresentation(of: pub)
          let locator: Locator? = ReaderService.locatorFromLocation(location, pub)
          let vc = reader.getViewController(
            for: pub,
            locator: locator
          )

          if (vc != nil) {
            completion(vc!.reader, vc!.audio)
          }
        }
      )
      .store(in: &subscriptions)
  }
  
  private func moveToDocuments(from source: URL, mediaType: MediaType, downloaded: @escaping (_: String) -> Void) -> AnyPublisher<URL, ReaderError> {
    Paths.makeDocumentURL(title: source.lastPathComponent, mediaType: mediaType)
      .setFailureType(to: ReaderError.self)
      .flatMap { destination in
        Future(on: .global()) { promise in
          // Necessary to read URL exported from the Files app, for example.
          let shouldRelinquishAccess = source.startAccessingSecurityScopedResource()
          defer {
            if shouldRelinquishAccess {
                source.stopAccessingSecurityScopedResource()
            }
          }
          
          do {
            let files = FileManager.default
            let documents = try files.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            let documentURL = documents.appendingPathComponent(source.lastPathComponent)
            if (try? documentURL.checkResourceIsReachable()) == true {
                return promise(.success(documentURL))
            }
            if Paths.isAppFile(at: source) {
              try FileManager.default.moveItem(at: source, to: destination)
            } else {
              try FileManager.default.copyItem(at: source, to: destination)
            }
            downloaded(destination.lastPathComponent)
            promise(.success(destination))
          } catch {
            promise(.failure(ReaderError.fileNotFound(error)))
          }
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func fulfillIfNeeded(_ url: URL, onProgress: @escaping (_: Float) -> Void) -> AnyPublisher<URL, ReaderError> {
    guard let drmService = drmLibraryServices.first(where: { $0.canFulfill(url) }) else {
      return .just(url)
    }
      
    return drmService.fulfill(url, onProgress: onProgress)
      .mapError { ReaderError.openFailed($0) }
      .flatMap { pub -> AnyPublisher<URL, ReaderError> in
        guard let url = pub?.localURL else {
          return .fail(.cancelled)
        }
        return .just(url)
      }
      .eraseToAnyPublisher()
  }

  func url(path: String) -> AnyPublisher<URL, ReaderError> {
    // Absolute URL.
    if let url = URL(string: path), url.scheme != nil {
      return .just(url)
    }

    // Absolute file path.
    if path.hasPrefix("/") {
      return .just(URL(fileURLWithPath: path))
    }

    return .fail(ReaderError.fileNotFound(fatalError("Unable to locate file: " + path)))
  }
  

  private func openPublication(
    at url: URL,
    allowUserInteraction: Bool,
    passpharse: String?,
    sender: UIViewController?
  ) -> AnyPublisher<(Publication, MediaType), ReaderError> {
    let openFuture = Future<(Publication, MediaType), ReaderError>(
      on: .global(),
      { [weak self] promise in
        let asset = FileAsset(url: url)
        guard let mediaType = asset.mediaType() else {
          promise(.failure(.openFailed(Publication.OpeningError.unsupportedFormat)))
          return
        }

        self?.streamer.open(
          asset: asset,
          credentials: passpharse,
          allowUserInteraction: allowUserInteraction,
          sender: sender
        ) { result in
          switch result {
          case .success(let publication):
            promise(.success((publication, mediaType)))
          case .failure(let error):
            promise(.failure(.openFailed(error)))
          case .cancelled:
            promise(.failure(.cancelled))
          }
        }
      }
    )

    return openFuture.eraseToAnyPublisher()
  }

  private func checkIsReadable(publication: Publication) -> AnyPublisher<Publication, ReaderError> {
    guard !publication.isRestricted else {
      print(publication.lcpLicense)
      if let error = publication.protectionError {
        print(publication.lcpLicense)
        return .fail(.openFailed(error))
      } else {
        return .fail(.cancelled)
      }
    }
    return .just(publication)
  }

  private func preparePresentation(of publication: Publication) {
    if (self.publicationServer == nil) {
      log(.error, "Whoops")
      return
    }

    publicationServer?.removeAll()
    
    if !publication.conforms(to: .audiobook) {
      do {
        try publicationServer?.add(publication)
      } catch {
        log(.error, error)
      }
    }
  }
}
