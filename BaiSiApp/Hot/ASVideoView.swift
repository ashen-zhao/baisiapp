//
//  ASVideoView.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/6.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import MediaPlayer
import Kingfisher

class ASVideoView: UIView {
    
    @IBOutlet weak var lblPlayCount: UILabel!
    
    @IBOutlet weak var lblPlayTime: UILabel!
    
    @IBOutlet weak var bgkImageView: UIImageView!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var touchView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var logoBgk: UIImageView!
    
    @IBOutlet weak var controlsVIew: UIView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var lblCurrentTime: UILabel!
    
    @IBOutlet weak var lblTotalTime: UILabel!
    
    @IBOutlet weak var controlStart: UIButton!
    
    
    typealias callbackfunc = ()->()

    var blc_Touch:callbackfunc!
    
    let player = MPMoviePlayerController()
    var controlsHidden = true
    var timer:Timer!
    var currentTimer:Timer!
    var touchTime:Date!
    var isFirstTouch = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIView.AutoresizingMask()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(stateChanged), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finished), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
    }
    
    
    class func videoView() -> ASVideoView {
        return Bundle.main.loadNibNamed("ASVideoView", owner: nil, options: nil)![0] as! ASVideoView
    }
    
    // MARK: -
    var videoModel:ASVideoModel! {
        didSet {
            player.contentURL = URL(string: videoModel.video[0])
            player.view.frame = self.bounds
            player.scalingMode = .aspectFit;
            player.controlStyle = .none
            player.backgroundView.backgroundColor = UIColor.clear
            self.addSubview(player.view)
            self.insertSubview(player.view, belowSubview: bgkImageView)
            bgkImageView.kf.setImage(with: ImageResource.init(downloadURL: URL(string: videoModel.thumbnail.count > 0 ? videoModel.thumbnail[0]: "")!))
            
            lblPlayCount.text = "\(videoModel.playcount) 播放"
            lblPlayTime.text = getNormalTimeStyle(String(videoModel.duration))
            logoBgk.isHidden = true
            lblTotalTime.text = getNormalTimeStyle(String(videoModel.duration))
            
            lblCurrentTime.text = "00:00"
            slider.setThumbImage(UIImage(named: "voice-play-progress-icon"), for: UIControl.State())
            slider.value = 0.0
            
            isFirstTouch = false
            bgkImageView.isHidden = false
            indicator.isHidden = true
            btnPlay.isHidden = false
            lblPlayTime.isHidden = false
            lblPlayCount.isHidden = false
            controlsHidden = true
            controlStart.setImage(UIImage(named: "playButtonPause"), for: UIControl.State())
        }
    }
    
    //MARK: - Actions
    
    @IBAction func tapPlayPauseAction(_ sender: AnyObject) {
        
        touchTime = Date()
        if player.playbackState == .playing {
            var frame = controlsVIew.frame
            if controlsHidden {
                frame.origin.y -= 55
                if timer != nil {
                    timer.invalidate()
                }
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(autoHiddenControls), userInfo: nil, repeats: true)
                
            } else {
                frame.origin.y += 55
            }
            controlsHidden = !controlsHidden
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsVIew.frame = frame
            }) 
        } else {
            if !isFirstTouch{
                self.player.play()
                blc_Touch()
                //这里很神奇，如果将btnPlay.hidden = true写在player.play()前面，则btnPlay不会隐藏，不知道是什么原因
                indicator.isHidden = false
                btnPlay.isHidden = true
                indicator.startAnimating()
            }
            isFirstTouch = true
        }
    }
    
    @IBAction func btnStartAction(_ sender: AnyObject) {
        if player.playbackState == .playing {
            (sender as! UIButton).setImage(UIImage(named: "voice-play-start"), for: UIControl.State())
            player.pause()
        } else {
            (sender as! UIButton).setImage(UIImage(named: "playButtonPause"), for: UIControl.State())
            player.play()
            if timer != nil {
                timer.invalidate()
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(autoHiddenControls), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func btnFullScreenAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnAlertAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnDownAction(_ sender: AnyObject) {
        
    }
    
    //MARK: - private Methods
    @objc fileprivate func stateChanged() {
        if currentTimer != nil {
            currentTimer.invalidate()
        }
        
        switch (self.player.playbackState) {
        case .playing:
            currentTimer =  Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(changeCurrentTimeLbl), userInfo: nil, repeats: true)
            break;
        case .paused:
            pauseState()
            break;
        default:
            break;
        }
    }
    
    
    func pauseState() {
        
        controlStart.setImage(UIImage(named: "voice-play-start"), for: UIControl.State())
        
        if controlsHidden {
            var frame = controlsVIew.frame
            frame.origin.y -= 55
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsVIew.frame = frame
            }) 
            controlsHidden = false
        }
    }
    
    @objc fileprivate func finished() {
        isFirstTouch = false
        bgkImageView.isHidden = false
        lblPlayTime.isHidden = false
        lblPlayCount.isHidden = false
        btnPlay.isHidden = false
        
        if currentTimer != nil {
            currentTimer.invalidate()
        }
        if !controlsHidden {
            var frame = self.controlsVIew.frame
            frame.origin.y += 55
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsVIew.frame = frame
            }) 
            self.controlsHidden = true
        }
    }
    
    @objc func autoHiddenControls() {
        if controlsHidden || player.playbackState == .paused {
            return
        }
        if Date().timeIntervalSince(touchTime) > 5.0 {
            var frame = self.controlsVIew.frame
            frame.origin.y += 55
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsVIew.frame = frame
            }) 
            self.controlsHidden = true
            timer.invalidate()
        }
    }
    
    @objc func changeCurrentTimeLbl() {
        if player.currentPlaybackTime.isNaN  {
            return
        }
        lblCurrentTime.text = getNormalTimeStyle(String(Int(player.currentPlaybackTime)))
        slider.setValue((Float)(player.currentPlaybackTime / player.duration), animated: true)
        slider.setMinimumTrackImage(UIImage(named: "voice-play-progress"), for: UIControl.State())
        indicator.isHidden = true
        bgkImageView.isHidden = true
        lblPlayTime.isHidden = true
        lblPlayCount.isHidden = true
    }
    
    func getNormalTimeStyle(_ time:String)->String {
        var result = "00:00"
        let timeInterval:Int! = Int(time)
        if timeInterval < 60 {
            result = String(format:"00:%02d", timeInterval!)
        } else if timeInterval < 3600 {
            result = String(format: "%02d:%02d", timeInterval / 60, timeInterval % 60)
        }
        return result
    }
}
