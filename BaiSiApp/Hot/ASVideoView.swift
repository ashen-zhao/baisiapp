//
//  ASVideoView.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/6.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

import MediaPlayer

class ASVideoView: UIView {
    
    @IBOutlet weak var lblPlayCount: UILabel!
    
    @IBOutlet weak var lblPlayTime: UILabel!
    
    @IBOutlet weak var bgkImageView: UIImageView!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var touchView: UIView!
    
    @IBOutlet weak var logoBgk: UIImageView!
    
    @IBOutlet weak var controlsVIew: UIView!
    
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var lblCurrentTime: UILabel!
    
    @IBOutlet weak var lblTotalTime: UILabel!
    
    let player = MPMoviePlayerController()
    var controlsHidden = true
    var timer:NSTimer!
    var touchTime:NSDate!
    var isFirstTouch = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stateChanged), name: MPMoviePlayerPlaybackStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(finished), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }
    
    
    class func videoView() -> ASVideoView {
        return NSBundle.mainBundle().loadNibNamed("ASVideoView", owner: nil, options: nil)[0] as! ASVideoView
    }
    
    // MARK: -
    var videoModel:ASVideoModel! {
        didSet {
            player.contentURL = NSURL(string: videoModel.video[0])
            player.view.frame = self.bounds
            player.scalingMode = .AspectFit;
            player.controlStyle = .None
            player.backgroundView.backgroundColor = UIColor.lightGrayColor()
            self.addSubview(player.view)
            self.sendSubviewToBack(player.view)
            self.bgkImageView.image = nil
            bgkImageView.kf_setImageWithURL(NSURL(string: videoModel.thumbnail.count > 0 ? videoModel.thumbnail[0]: "")!)
            lblPlayCount.text = "\(videoModel.playcount) 播放"
            lblPlayTime.text = getNormalTime(videoModel.duration)
            logoBgk.hidden = true
            
            viewsHidden(false)
            isFirstTouch = false
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func tapPlayPauseAction(sender: AnyObject) {
        
        touchTime = NSDate()
        if player.playbackState == .Playing {
            var frame = controlsVIew.frame
            if controlsHidden {
                frame.origin.y -= 45
                if timer != nil {
                    timer.invalidate()
                }
                timer =  NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(autoHiddenControls), userInfo: nil, repeats: true)
                
            } else {
                frame.origin.y += 45
            }
            controlsHidden = !controlsHidden
            UIView.animateWithDuration(0.3) {
                self.controlsVIew.frame = frame
            }
        } else {
            if !isFirstTouch{
                player.play()
            }
            isFirstTouch = true
        }
    }
    
    @IBAction func btnStartAction(sender: AnyObject) {
        if player.playbackState == .Playing {
            (sender as! UIButton).setImage(UIImage(named: "voice-play-start"), forState: .Normal)
            player.pause()
        } else {
            (sender as! UIButton).setImage(UIImage(named: "playButtonPause"), forState: .Normal)
            player.play()
        }
    }
    
    @IBAction func btnFullScreenAction(sender: AnyObject) {
    }
    
    @IBAction func btnAlertAction(sender: AnyObject) {
    }
    
    @IBAction func btnDownAction(sender: AnyObject) {
    }
    
    //MARK: - private Methods
    @objc private func stateChanged() {
        switch (self.player.playbackState) {
        case .Playing:
            viewsHidden(true)
            break;
        case .Paused:
            viewsHidden(true)
            break;
        default:
            break;
        }
    }
    
    @objc private func finished() {
        self.sendSubviewToBack(player.view)
    }
    
    func autoHiddenControls() {
        if controlsHidden {
            return
        }
        if NSDate().timeIntervalSinceDate(touchTime) > 5.0 {
            var frame = self.controlsVIew.frame
            frame.origin.y += 45
            UIView.animateWithDuration(0.3) {
                self.controlsVIew.frame = frame
            }
            self.controlsHidden = true
            timer.invalidate()
        }
    }
    
    private func getNormalTime(second:Int)->String {
        return "\(second / 60):\(String(format: "%02d", second % 60))"
    }
    
    private func viewsHidden(hidden:Bool) {
        btnPlay.hidden = hidden
        lblPlayTime.hidden = hidden
        lblPlayCount.hidden = hidden
        bgkImageView.hidden = hidden
    }
}
