//
//  LiveScreenViewController.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import UIKit
import AVFoundation
class LiveScreenViewController: B2CBaseViewController {
    @IBOutlet weak var videoView: UIView!
    var player: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LiveScreenViewController {
    
    func setupUI() {
        hideNavigationBar()
        playVideo()
        addObserver()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetPlayer),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    @objc func resetPlayer() {
        let t1 = Float((player?.currentTime().value)!)
       let t2 = Float((player?.currentTime().timescale)!)
      let times2 = t1 / t2
        //player?.seek(to: .zero)
        player?.seek(to: CMTimeMakeWithSeconds(Float64(times2), 1) )
        player?.play()
    }

    
    func playVideo() {
        let bundle = Bundle.resourceBundle(for: Self.self)
        let videoString:String? = bundle.path(forResource: "splash_video", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else { return }
        player = AVPlayer(url: URL(fileURLWithPath: unwrappedVideoPath))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
}
