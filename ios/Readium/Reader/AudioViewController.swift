import UIKit
import MediaPlayer
import R2Shared
import R2Navigator
import Combine
import SwiftSoup

class AudioViewController: UIViewController {
    var navigator: _AudioNavigator?
    let publication: Publication
    private var locatorSubject = PassthroughSubject<Locator, Never>()
    lazy var locatorPublisher = locatorSubject.eraseToAnyPublisher()
    private var playbackSubject = PassthroughSubject<MediaPlaybackInfo, Never>()
    lazy var playbackPublisher = playbackSubject.eraseToAnyPublisher()
  
    init(
      publication: Publication,
      locator: Locator?,
      resourcesServer: ResourcesServer
    ) {
      navigator = _AudioNavigator(
        publication: publication,
        initialLocation: locator
      )
      
      self.publication = publication

      super.init(nibName: nil, bundle: nil)
      
      navigator?.delegate = self
    }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    navigator?.pause()
    navigator = nil
  }
}

extension AudioViewController: _AudioNavigatorDelegate {
  func navigator(_ navigator: _MediaNavigator, playbackDidChange info: MediaPlaybackInfo) {
    playbackSubject.send(info)
  }
  
  func navigator(_ navigator: _MediaNavigator, loadedTimeRangesDidChange ranges: [Range<Double>]) {
    print(ranges)
  }
  
  func navigator(_ navigator: Navigator, locationDidChange locator: Locator) {
//    subject.send(locator)
  }
  
  func navigator(_ navigator: Navigator, didJumpTo locator: Locator) {
    locatorSubject.send(locator)
  }

  func navigator(_ navigator: Navigator, presentError error: NavigatorError) {}
}
