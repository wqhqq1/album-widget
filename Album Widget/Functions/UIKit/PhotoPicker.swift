//
//  PhotoPicker.swift
//  Album Widget
//
//  Created by wqh on 2020/11/17.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @EnvironmentObject var photoData: PhotoData
    @State var index: Int
    func makeUIViewController(context: Context) -> PHPickerViewController {
        requestPermission()
        var config = PHPickerConfiguration()
        config.selectionLimit = 100
        config.filter = .images
        let controller = PHPickerViewController(configuration: config)
        controller.modalPresentationStyle = .automatic
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        return
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self.index, envObj: self._photoData)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        @EnvironmentObject var photoData: PhotoData
        @State var index: Int
        init(_ index: Int, envObj: EnvironmentObject<PhotoData>){
            self.index = index
            self._photoData = envObj
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            if results.count == 0 { return }
            for rlt in results {
                let itemProvider = rlt.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image {
                            DispatchQueue.main.async {
                                _ = self.photoData.appendPhoto(at: self.index, photos: photo(data: (image as! UIImage)))
                            }
                        }
                    }
                }
            }
        }
    }
    private func requestPermission() {
        PHPhotoLibrary.requestAuthorization() { status in
            if status == .authorized {
                return
            }
        }
    }
}
