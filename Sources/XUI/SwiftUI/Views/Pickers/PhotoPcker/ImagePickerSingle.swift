//
//  File.swift
//  
//
//  Created by Aung Ko Min on 18/7/23.
//

import SwiftUI

public struct ImagePickerView: UIViewControllerRepresentable {
    
    let sourceType: UIImagePickerController.SourceType
    let onPicked: (XAttachment) -> Void
    @Environment(\.dismiss) var dismiss
    
    public init(sourceType: UIImagePickerController.SourceType, onPicked: @escaping (XAttachment) -> Void) {
        self.sourceType = sourceType
        self.onPicked = onPicked
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = context.coordinator
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            vc.sourceType = sourceType
        }
        vc.mediaTypes = ["public.image", "public.movie"]
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(self)
    }
}

public final class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var parent: ImagePickerView
    
    init(_ control: ImagePickerView) {
        parent = control
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            do {
                let imageURL = try uiImage.resize(600).temporaryLocalFileUrl(id: UUID().uuidString, quality: 0.5)
                if let imageURL {
                    let attachment = XAttachment(url: imageURL.absoluteString, type: .photo)
                    parent.onPicked(attachment)
                }
            } catch {
                print(error)
            }
        } else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            let attachment = XAttachment(url: videoURL.absoluteString, type: .video)
            parent.onPicked(attachment)
        }
        parent.dismiss()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.dismiss()
    }
}



public class DirUtil: NSObject {
    
    class func application() -> String {
        return Bundle.main.resourcePath!
    }
    
    class func application(_ component: String) -> String {
        var path = application()
        path = (path as NSString).appendingPathComponent(component)
        return path
    }
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func application(_ component1: String, and component2: String) -> String {
        var path = application()
        path = (path as NSString).appendingPathComponent(component1)
        path = (path as NSString).appendingPathComponent(component2)
        return path
    }
}

public extension DirUtil {
    class func document() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    class func document(_ components: [String]) -> String {
        var path = document()
        components.forEach { component in
            path = (path as NSString).appendingPathComponent(component)
        }
        createIntermediate(path)
        return path
    }
}

public extension DirUtil {
    class func cache() -> String {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    class func cache(_ component: String) -> String {
        var path = cache()
        path = (path as NSString).appendingPathComponent(component)
        createIntermediate(path)
        return path
    }
}

public extension DirUtil {
    private class func createIntermediate(_ path: String) {
        let directory = (path as NSString).deletingLastPathComponent
        if !exist(directory) {
            create(directory)
        }
    }
    
    private class func create(_ directory: String) {
        try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
    }
    
    private class func exist(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}


public struct FileUtil {
    
    public static var documentDirectory: URL? {
        url(for: .documentDirectory)
    }
    public static var cachesDirectory: URL? {
        url(for: .cachesDirectory)
    }
    
    public static var temporaryDirectory: URL {
        .init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }
    
    public static func url(for searchPathDirectory: FileManager.SearchPathDirectory) -> URL? {
        try? FileManager.default.url(for: searchPathDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    public static func temp(id: String? = nil, ext: String) -> String {
        let name = id ?? UUID().uuidString
        let file = "\(name).\(ext)"
        return DirUtil.cache(file)
    }
    
    public static func exist(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    public static func remove(_ path: String) {
        try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
    }
    
    public static func copy(from source: String, to dest: String, _ overwrite: Bool) {
        if overwrite { remove(dest) }
        if !exist(dest) {
            try? FileManager.default.copyItem(atPath: source, toPath: dest)
        }
    }
    public static func created(_ path: String) -> Date {
        let attributes = try! FileManager.default.attributesOfItem(atPath: path)
        return attributes[.creationDate] as! Date
    }
    
    public static func modified(_ path: String) -> Date {
        let attributes = try! FileManager.default.attributesOfItem(atPath: path)
        return attributes[.modificationDate] as! Date
    }
    
    public static func size(_ path: String) -> Int64 {
        let attributes = try! FileManager.default.attributesOfItem(atPath: path)
        return attributes[.size] as! Int64
    }
    
    public static func diskFree() -> Int64 {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let attributes = try! FileManager.default.attributesOfFileSystem(forPath: path)
        return attributes[.systemFreeSize] as! Int64
    }
}
