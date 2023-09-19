import Combine
import Foundation
import R2Shared
import R2Streamer
import UIKit
import R2Navigator


class ReadiumView : UIView, Loggable {
  var readerService: ReaderService = ReaderService()
  weak var readerViewController: ReaderViewController?
  weak var audioViewController: AudioViewController?
  var delegate: ReaderViewDelegate?
  weak var viewController: UIViewController? {
    let viewController = sequence(first: self, next: { $0.next }).first(where: { $0 is UIViewController })
    return viewController as? UIViewController
  }
  private var subscriptions = Set<AnyCancellable>()

  @objc var file: NSDictionary? = nil {
    didSet {
      let initialLocation = file?["initialLocation"] as? NSDictionary
      let passpharse = file?["passpharse"] as? String
      if let url = file?["url"] as? String {
        self.loadBook(url: url, location: initialLocation, passpharse: passpharse)
      }
    }
  }
  @objc var location: NSDictionary? = nil {
    didSet {
      self.updateLocation()
    }
  }
  @objc var settings: NSDictionary? = nil {
    didSet {
      self.updateUserSettings(settings)
    }
  }
  @objc var onLocationChange: RCTDirectEventBlock?
  @objc var onTableOfContents: RCTDirectEventBlock?
  @objc var onReady: RCTDirectEventBlock?
  @objc var onFullModeChange: RCTDirectEventBlock?
  @objc var onDownloaded: RCTDirectEventBlock?
  @objc var onAudioPlaybackChange: RCTDirectEventBlock?
  @objc var onDownloading: RCTDirectEventBlock?

  func loadBook(
    url: String,
    location: NSDictionary?,
    passpharse: String?
  ) {
    guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { return }

    self.readerService.buildViewController(
      url: url,
      location: location,
      sender: rootViewController,
      passpharse: passpharse,
      completion: { [weak self] (reader, audio) in
        if let reader = reader {
          self?.addViewControllerAsSubview(reader)
        }
        
        if let audio = audio {
          self?.addAudioViewAsSubview(audio)
        }
        self?.location = location
      },
      downloaded: { [weak self] path in
        self?.onDownloaded?(["path": path])
      },
      onProgress: { [weak self] progress in
        self?.onDownloading?(["progress": progress])
      }
    )
  }

  func getLocator() -> Locator? {
    return ReaderService.locatorFromLocation(location, readerViewController?.publication)
  }

  func updateLocation() {
    guard let navigator = readerViewController?.navigator else {
      return;
    }
    guard let locator = self.getLocator() else {
      return;
    }

    let cur = navigator.currentLocation
    if (cur != nil && locator.hashValue == cur?.hashValue) {
      return;
    }

    navigator.go(
      to: locator,
      animated: true
    )
  }

  func updateUserSettings(_ settings: NSDictionary?) {

    if (readerViewController == nil) {
      // defer setting update as view isn't initialized yet
      return;
    }

    if let navigator = readerViewController!.navigator as? EPUBNavigatorViewController {
      let userProperties = navigator.userSettings.userProperties

      for property in userProperties.properties {
        let value = settings?[property.reference]

        if (value == nil) {
          continue
        }

        if let e = property as? Enumerable {
          e.index = value as! Int

          // synchronize background color
          if property.reference == ReadiumCSSReference.appearance.rawValue {
            if let vc = readerViewController as? EPUBViewController {
              vc.setUIColor(for: property)
            }
          }
        } else if let i = property as? Incrementable {
          i.value = value as! Float
        } else if let s = property as? Switchable {
          s.on = value as! Bool
        }
      }

      navigator.updateUserSettingStyle()
    }
  }

  func goToPosition(position: Double?) {
    guard let navigator = readerViewController?.navigator else {
      return;
    }
    
    guard let pos = position else {
      return;
    }
    
    
    if let locator = readerViewController?.publication.locate(progression: pos) {
      navigator.go(to: locator, animated: true)
    }
  }
  
  func goToAudioPosition(position: Double?) {
    guard let navigator = audioViewController?.navigator else {
      return;
    }
    
    guard let pos = position else {
      return;
    }
    
    if let locator = audioViewController?.publication.locate(progression: pos) {
      navigator.go(to: locator, animated: true)
    }
  }
  
  func goToLocation(location: NSDictionary?) {
    guard let navigator = readerViewController?.navigator else {
      return;
    }
    
    if let locator = ReaderService.locatorFromLocation(location, readerViewController?.publication) {
      navigator.go(
        to: locator,
        animated: true
      )
    }
  }
  
  func pauseAudio() {
    guard let navigator = audioViewController?.navigator else {
      return
    }
    
    navigator.pause()
    
    self.onAudioPlaybackChange?([
      "progress": navigator.playbackInfo.progress,
      "duration": navigator.playbackInfo.duration ?? 0,
      "time": navigator.playbackInfo.time,
      "currentResource": navigator.playbackInfo.resourceIndex,
      "isPlaying": navigator.playbackInfo.state == .playing
    ])
  }
  
  func playAudio() {
    guard let navigator = audioViewController?.navigator else {
      return
    }
    navigator.play()
  }
  
  func seekAudio(value: Double) {
    guard let navigator = audioViewController?.navigator else {
      return
    }

    navigator.seek(relatively: value)
  }
  
  func goToNextAudio() {
    guard let navigator = audioViewController?.navigator else {
      return
    }

    navigator.goToNextResource()
  }
  
  func goToPreviousAudio() {
    guard let navigator = audioViewController?.navigator else {
      return
    }
    navigator.goToPreviousResource()
  }
  
  func setAudioRate(rate: Double) {
    guard let navigator = audioViewController?.navigator else {
      return
    }
    navigator.rate = rate
  }

  override func removeFromSuperview() {
    readerViewController?.willMove(toParent: nil)
    readerViewController?.view.removeFromSuperview()
    readerViewController?.removeFromParent()

    audioViewController?.willMove(toParent: nil)
    audioViewController?.view.removeFromSuperview()
    audioViewController?.removeFromParent()
    
    // cancel all current subscriptions
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions = Set<AnyCancellable>()

    audioViewController = nil
    readerViewController = nil
    super.removeFromSuperview()
  }
  
  private func addAudioViewAsSubview(_ vc: AudioViewController) {
    vc.locatorPublisher.sink(
      receiveValue: { locator in
        self.onLocationChange?(locator.json)
      }
    )
    .store(in: &self.subscriptions)
    
    vc.playbackPublisher.sink(
      receiveValue: { info in
        self.onAudioPlaybackChange?([
          "progress": info.progress,
          "duration": info.duration ?? 0,
          "time": info.time,
          "currentResource": info.resourceIndex,
          "isPlaying": info.state == .playing
        ])
      }
    )
    .store(in: &self.subscriptions)
    
    self.onReady?([
      "totalPages": vc.publication.readingOrder.count,
      "location": vc.navigator?.currentLocation?.json ?? nil
    ])
    
    self.audioViewController = vc
    vc.view.frame = self.bounds
    
    guard let mvc = self.viewController else {
      return
    }
    
    mvc.addChild(vc)
    let rootView = vc.view!
    self.addSubview(rootView)
  }

  private func addViewControllerAsSubview(_ vc: ReaderViewController) {
    vc.publisher.sink(
      receiveValue: { locator in
        self.onLocationChange?(locator.json)
      }
    )
    .store(in: &self.subscriptions)

    readerViewController = vc
    readerViewController?.delegate = self

    // if the controller was just instantiated then apply any existing settings
    if (settings != nil) {
      self.updateUserSettings(settings)
    }
    
    self.onReady?([
      "totalPages": vc.publication.positions.count,
      "location": vc.navigator.currentLocation?.json ?? nil
    ])

    self.onTableOfContents?([
      "toc": vc.publication.tableOfContents.map({ link in
        return link.json
      })
    ])
    
    guard let mvc = self.viewController else {
      return
    }

    readerViewController!.view.frame = self.bounds
    mvc.addChild(readerViewController!)
    let rootView = self.readerViewController!.view!
    self.addSubview(rootView)
    self.readerViewController!.didMove(toParent: mvc)
  }
}

extension ReadiumView: ReaderViewDelegate {
  func onFullScreen(hidden: Bool) {
    self.onFullModeChange?(["fullMode": hidden])
  }
}
