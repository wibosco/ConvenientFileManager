//
//  ListViewController.swift
//  SwiftExample
//
//  Created by William Boles on 11/11/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import ConvenientFileManager

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var images = [Media]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMediaBarButtonItem: UIBarButtonItem!
    
    lazy var imagePickerViewController: UIImagePickerController = {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.modalPresentationStyle = .currentContext
        imagePickerViewController.sourceType = .savedPhotosAlbum
        
        return imagePickerViewController
    }()
    
    //MARK: ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100.0
        
        addMediaBarButtonItem.action = #selector(ListViewController.addMediaButtonPressed)
        addMediaBarButtonItem.target = self
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath) as! MediaTableViewCell
        
        let media = images[indexPath.row]
        
        cell.locationLabel.text = media.location.rawValue.capitalized
        cell.mediaImageView.image = loadImageFromMediaSavedLocation(media: media)
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let media = images[indexPath.row]
        switch media.location {
        case .cache:
            FileManager.deleteDataFromCacheDirectory(relativePath: media.name)
        case .documents:
            FileManager.deleteDataFromDocumentsDirectory(relativePath: media.name)
        }
        
        images.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    //MARK: Media
    
    func loadImageFromMediaSavedLocation(media: Media) -> UIImage? {
        let imageData: Data?
        
        switch media.location {
        case .cache:
            imageData = FileManager.retrieveDataFromCacheDirectory(relativePath: media.name)
        case .documents:
            imageData = FileManager.retrieveDataFromDocumentsDirectory(relativePath: media.name)
        }
        
        guard let unwrappedImageData = imageData else {
            return nil
        }
        
        return UIImage(data: unwrappedImageData)
    }
    
    //MARK: ButtonActions
    
    func addMediaButtonPressed(sender: UIBarButtonItem) {
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let imageData = UIImagePNGRepresentation(image) else {
            return
        }
        
        let media = Media(name: UUID().uuidString, location: Location.randomLocation())
        switch media.location {
        case .cache:
            FileManager.writeToCacheDirectory(data: imageData, relativePath: media.name)
        case .documents:
            FileManager.writeToDocumentsDirectory(data: imageData, relativePath: media.name)
        }
        
        images.append(media)
        picker.dismiss(animated: true, completion: { [weak self] in
           self?.tableView.reloadData()
        })
    }
}

