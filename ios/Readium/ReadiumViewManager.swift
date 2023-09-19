import Foundation

@objc(ReadiumViewManager)
class ReadiumViewManager: RCTViewManager {
  override func view() -> (ReadiumView) {
    return ReadiumView()
  }

  override class func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc func goToPosition(_ reactTag: NSNumber, position: Double) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.goToPosition(position: position)
    }
  }
  
  @objc func goToLocation(_ reactTag: NSNumber, location: NSDictionary) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.goToLocation(location: location)
    }
  }
  
  @objc func playAudio(_ reactTag: NSNumber) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.playAudio()
    }
  }
  
  @objc func pauseAudio(_ reactTag: NSNumber) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.pauseAudio()
    }
  }
  
  @objc func seekAudio(_ reactTag: NSNumber, value: Double) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.seekAudio(value: value)
    }
  }
  
  @objc func goToNextAudio(_ reactTag: NSNumber) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.goToNextAudio()
    }
  }
  
  @objc func goToPreviousAudio(_ reactTag: NSNumber) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.goToPreviousAudio()
    }
  }
  
  @objc func goToAudioPosition(_ reactTag: NSNumber, position: Double) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.goToAudioPosition(position: position)
    }
  }
  
  @objc func setAudioRate(_ reactTag: NSNumber, rate: Double) {
    self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
        let view: ReadiumView = (viewRegistry![reactTag] as? ReadiumView)!
        view.setAudioRate(rate: rate)
    }
  }
}
