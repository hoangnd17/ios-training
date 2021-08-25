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
        
        listURL = fileUrls(for: .documentDirectory)
        // airplay
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.interruptSpokenAudioAndMixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
    }
    
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
            if (sender.value  == 1.0){
                
            }
        }
        doubleTap = false
    }
    
    @IBAction func importMusic(_ sender: Any) {
        let controller = MPMediaPickerController(mediaTypes: .music)
        controller.allowsPickingMultipleItems = true
        controller.popoverPresentationController?.sourceView = sender as? UIView
        controller.delegate = self
        present(controller, animated: true)
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
    
    // export to document
    func export(assetURL: URL, nameArtist: String, nameSong: String, completionHandler: @escaping (_ fileURL: URL?, _ error: Error?) -> ()) {
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
        }
    }
    
    func fileUrls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL] {
        let documentsURL = FileManager.default.urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs ?? []
    }
    
    func separateName(_ name: String) -> [String] {
        let info = name.components(separatedBy: "-")
        
        return info
    }
    
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
}



extension MusiicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FileManager.default.fileUrls(for: .documentDirectory)!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = listURL[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        
        let info = separateName(model.deletingPathExtension().lastPathComponent)
        
        cell.name.text = info[0]
        cell.artist.text = info[1]
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
                  let nameSong = mediaItem.title else {
                return
            }
            export(assetURL: assetURL, nameArtist: nameArtist, nameSong: nameSong ) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("export failed: \(String(describing: error))")
                    return
                }
                
                print("\(fileURL)")
                DispatchQueue.main.async {
                    self.listURL = self.fileUrls(for: .documentDirectory)
                    self.musicTb.reloadData()
                }
            }
        }
        
        //        let player = MPMusicPlayerController.systemMusicPlayer
        //        player.setQueue(with: mediaItemCollection)
        mediaPicker.dismiss(animated: true)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    
}
extension MusiicViewController: AVAudioPlayerDelegate {
    
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
