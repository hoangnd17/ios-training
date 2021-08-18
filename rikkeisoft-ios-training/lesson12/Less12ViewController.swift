//
//  ViewController.swift
//  lesson12
//
//  Created by Đại Nguyễn  on 8/16/21.
//

import UIKit

class Less12ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let fm = FileManager.default
        let listImageName = fm.getAllImage()
        
    }
    
}

extension FileManager {
    func getListFileNameInBundle(bundlePath: String) -> [String] {
        
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent(bundlePath)
        do {
            let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
            return contents.map{$0.lastPathComponent}
        }
        catch {
            return []
        }
    }
    
    func getImageInBundle(bundlePath: String) -> UIImage? {
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent(bundlePath)
        return UIImage.init(contentsOfFile: assetURL.relativePath)
    }
    
    func getAllImage() -> [String] {
        var res: [String] = [String]()
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("res.bundle")
        do {
            let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)

            let arr =  contents.map {$0.lastPathComponent}

            for i in arr {
                let asset = bundleURL.appendingPathComponent("res.bundle/\(i)")
                
                do {
                    let name = try fileManager.contentsOfDirectory(at: asset, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
                    res.append(contentsOf: name.map{$0.lastPathComponent})
                }
                catch {
                    return []
                }
            }
        }
        catch {
            return []
        }
        return res
    }
}
