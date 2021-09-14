//
//  ViewController.swift
//  music_play
//
//  Created by Đại Nguyễn  on 8/23/21.
//

import UIKit
import MediaPlayer
import AVFoundation

class MusiicViewController: UIViewController {
    
    @IBOutlet weak var musicTb: UITableView!
    @IBOutlet weak var launchView: UIView!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var nameArtirst: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    var listURL = [URL]()
    var player: AVAudioPlayer?
    var updateTimer : CADisplayLink! = nil
    var currentIndex = 0
    var doubleTap : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        musicTb.delegate = self
        musicTb.dataSource = self
        
        musicTb.register(UINib(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicTableViewCell")
        
        listURL = fileUrlAudio()
        // setup
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        setupMediaPlayerNotificationView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    // update time slider
    @IBAction func changeTime(_ sender: UISlider) {
        guard let player = player else { return }
        player.pause()
        
        let target = TimeInterval(Float(sender.value) * Float(player.duration))
        player.play(atTime: target)
        
        if !player.isPlaying {
            player.play(atTime: target)
            pauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            player.currentTime = target
            pauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            
        }
        doubleTap = false
    }
    
    // import from itune
    @IBAction func importMusic(_ sender: Any) {
        let controller = MPMediaPickerController(mediaTypes: .music)
        controller.allowsPickingMultipleItems = true
        controller.popoverPresentationController?.sourceView = sender as? UIView
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func next()  {
        
    }
    
    @IBAction func nextMusic(_ sender: Any) {
        if currentIndex == listURL.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        let model = listURL[currentIndex]
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.configLaunchView(with: model)
            self.play(model)
        })
        
    }
    
    @IBAction func pauseMusic(_ sender: Any) {
        if (doubleTap) {
            guard let player = player else { return }
            player.play()
            UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.pauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            })
            
            doubleTap = false
        } else {
            guard let player = player else { return }
            player.pause()
            UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.pauseBtn.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            })
            doubleTap = true
        }
    }
    
    @IBAction func backMusic(_ sender: Any) {
        if currentIndex == 0 {
            currentIndex = listURL.count - 1
        } else {
            currentIndex -= 1
        }
        let model = listURL[currentIndex]
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.configLaunchView(with: model)
            self.play(model)
        })
    }
    
    // play music
    func play(_ url: URL) {
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.delegate = self
            player?.volume = 1
            player?.play()
            
            updateTimer = CADisplayLink(target: self, selector: #selector(updateSliderProgress))
            updateTimer.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
            
            DispatchQueue.main.async {
                self.duration.text = self.player?.duration.stringFromTimeInterval()
            }
            
            setupNowPlaying()
            
        } catch let error {
            player = nil
            print(error)
        }
    }
    
    func configLaunchView(with model: URL) {
        let info = separateName(model.deletingPathExtension().lastPathComponent)
        pauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        nameSong.text = info[0]
        nameArtirst.text = info[1]
        doubleTap = false
    }
    
    @objc func updateSliderProgress(){
        let progress = player!.currentTime / player!.duration
        audioSlider.setValue(Float(progress), animated: false)
        
        let remain = player!.duration - player!.currentTime
        duration.text = remain.stringFromTimeInterval()
    }
    
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
}



extension MusiicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileUrlAudio().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = listURL[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        
        let info = separateName(model.deletingPathExtension().lastPathComponent)
        
        cell.name.text = info[0]
        cell.artist.text = info[1]
        if let image = loadImageFromDiskWith(fileName: model.deletingPathExtension().lastPathComponent)  {
            cell.thumbnail.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        let model = listURL[indexPath.row]
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.launchView.isHidden = false
            self.configLaunchView(with: model)
            self.play(model)
        })
    }
}


extension MusiicViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        for mediaItem in mediaItemCollection.items {
            guard let assetURL = mediaItem.assetURL,
                  let nameArtist = mediaItem.artist,
                  let artwork = mediaItem.artwork?.image(at: CGSize(width: 100, height: 100)),
                  let nameSong = mediaItem.title else {
                return
            }
            
            export(assetURL: assetURL, nameArtist: nameArtist, nameSong: nameSong, artwork: artwork) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("export failed: \(String(describing: error))")
                    return
                }
                
                print(fileURL.lastPathComponent)
                DispatchQueue.main.async {
                    self.listURL = self.fileUrlAudio()
                    self.musicTb.reloadData()
                }
            }
        }
        
        mediaPicker.dismiss(animated: true)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    // export to document
    func export(assetURL: URL, nameArtist: String, nameSong: String,artwork: UIImage, completionHandler: @escaping (_ fileURL: URL?, _ error: Error?) -> ()) {
        let asset = AVURLAsset(url: assetURL)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completionHandler(nil, ExportError.unableToCreateExporter)
            return
        }
        
        // set name file (name - artist)
        let path = "\(nameSong)-\(nameArtist)"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(path) .appendingPathExtension("m4a")
        
        // check exists in document
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("music exist")
        } else {
            exporter.outputURL = fileURL
            exporter.outputFileType = AVFileType(rawValue: "com.apple.m4a-audio")
            exporter.exportAsynchronously {
                if exporter.status == .completed {
                    completionHandler(fileURL, nil)
                } else {
                    completionHandler(nil, exporter.error)
                }
            }
            
            saveImage(imageName: path, image: artwork)
        }
    }
    
    func fileUrlAudio() -> [URL] {
        var res = [URL]()
        let list = FileManager.default.fileUrls(for: .documentDirectory) ?? []
        for url in list {
            if url.pathExtension == "m4a" {
                res.append(url)
            }
        }
        return res
    }
    
    func separateName(_ name: String) -> [String] {
        let info = name.components(separatedBy: "-")
        
        return info
    }
    
    func setupNowPlaying() {

        // Define Now Playing Info
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        let model = listURL[currentIndex]
        guard let image = loadImageFromDiskWith(fileName: model.deletingPathExtension().lastPathComponent) else {
            return
        }
        let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: {  (_) -> UIImage in
            return image
        })
        
        var time: TimeInterval = 0
        do {
            let play = try AVAudioPlayer(contentsOf: model)
            time = play.duration
        } catch let error {
            print(error)
        }

        nowPlayingInfo[MPMediaItemPropertyTitle] = nameSong.text
        nowPlayingInfo[MPMediaItemPropertyArtist] = nameArtirst.text
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = time
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 1.0)
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    // setup remote control
    func setupMediaPlayerNotificationView() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // add handle
        commandCenter.playCommand.addTarget(self, action: #selector(playCenter))
        commandCenter.pauseCommand.addTarget(self, action: #selector(pauseCenter))
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(nextCenter))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(previousCenter))
        
    }
    
    
    @objc func playCenter()  -> MPRemoteCommandHandlerStatus  {
        guard let player = player else {
            return .commandFailed
        }
        pauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        player.play()
        doubleTap = false
        return .success
    }
    
    @objc func pauseCenter() -> MPRemoteCommandHandlerStatus  {
        guard let player = player else {
            return .commandFailed
        }
        player.pause()
        pauseBtn.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        
        doubleTap = true
        return.success
    }
    
    @objc func nextCenter() -> MPRemoteCommandHandlerStatus  {
        if currentIndex == listURL.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        let model = listURL[currentIndex]
        
        configLaunchView(with: model)
        play(model)
        print("next")
        return.success
    }
    
    @objc func previousCenter() -> MPRemoteCommandHandlerStatus  {
        if currentIndex == 0 {
            currentIndex = listURL.count - 1
        } else {
            currentIndex -= 1
        }
        let model = listURL[currentIndex]
        
        configLaunchView(with: model)
        play(model)
        return.success
    }
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
}
extension MusiicViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            if currentIndex == listURL.count - 1 {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
            let model = listURL[currentIndex]
            
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.configLaunchView(with: model)
                self.play(model)
            })
        }
    }
}

enum ExportError: Error {
    case unableToCreateExporter
}

extension FileManager {
    func fileUrls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs ?? []
    }
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
}
