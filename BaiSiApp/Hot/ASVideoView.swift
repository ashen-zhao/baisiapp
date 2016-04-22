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
            player.view.frame = bgkImageView.frame
            player.scalingMode = .AspectFit;
            player.backgroundView.backgroundColor = UIColor.lightGrayColor()
            self.addSubview(player.view)
            self.sendSubviewToBack(player.view)
            
            bgkImageView.kf_setImageWithURL(NSURL(string: videoModel.thumbnail.count > 0 ? videoModel.thumbnail[0]: "")!)
            lblPlayCount.text = "\(videoModel.playcount) 播放"
            lblPlayTime.text = getNormalTime(videoModel.duration)
        }
    }
    
    
    //MARK: - Actions
    @IBAction func btnPlayAction(sender: AnyObject) {
        self.bringSubviewToFront(player.view)
        player.play()
    }
    
    
    //MARK: - private Methods
    
    func stateChanged() {
        switch (self.player.playbackState) {
        case .Playing:
            print("正在播放...");
            break;
        case .Paused:
            print("暂停播放.");
            break;
        case .Stopped:
            print("停止播放.");
            break;
        default:
            break;
        }
    }
    
    func finished() {
        self.sendSubviewToBack(player.view)
    }
    
    private func getNormalTime(second:Int)->String {
        return "\(second / 60):\(String(format: "%02d", second % 60))"
    }
}
