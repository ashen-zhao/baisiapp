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
    @IBOutlet weak var logoBgk: UIImageView!
    
    @IBOutlet weak var controlsVIew: UIView!
    let player = MPMoviePlayerController()
    
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
            bgkImageView.kf_setImageWithURL(NSURL(string: videoModel.thumbnail.count > 0 ? videoModel.thumbnail[0]: "")!)
            lblPlayCount.text = "\(videoModel.playcount) 播放"
            lblPlayTime.text = getNormalTime(videoModel.duration)
            logoBgk.hidden = true
        }
    }
    
    
    //MARK: - Actions
    @IBAction func btnPlayAction(sender: AnyObject) {
        
    }
    
    @IBAction func tapPlayPauseAction(sender: AnyObject) {
        
        if player.playbackState == .Playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
    //MARK: - private Methods
    @objc private func stateChanged() {
        switch (self.player.playbackState) {
        case .Playing:
            viewsHidden(true, bgkHidden: true)
            break;
        case .Paused:
            viewsHidden(false, bgkHidden: true)
            break;
        case .Stopped:
            viewsHidden(false, bgkHidden: false)
            break;
        default:
            break;
        }
    }
    
    @objc private func finished() {
        self.sendSubviewToBack(player.view)
    }
    
    private func getNormalTime(second:Int)->String {
        return "\(second / 60):\(String(format: "%02d", second % 60))"
    }
    
    private func viewsHidden(btnHidden:Bool, bgkHidden:Bool) {
        btnPlay.hidden = btnHidden
        bgkImageView.hidden = bgkHidden
        lblPlayTime.hidden = bgkHidden
        lblPlayCount.hidden = bgkHidden
        
        var frame = controlsVIew.frame
        if controlsVIew.hidden {
            controlsVIew.hidden = false
            frame.origin.y -= 50
            self.controlsVIew.frame = frame
            return
        }
        
        if btnHidden {
            frame.origin.y -= 50
        } else {
            frame.origin.y += 50
        }
        
        UIView.animateWithDuration(0.3) {
            self.controlsVIew.frame = frame
        }
    }
}
