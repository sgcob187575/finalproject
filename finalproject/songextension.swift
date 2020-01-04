//
//  songextension.swift
//  finalproject
//
//  Created by 陳昱豪 on 2019/12/28.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine
import SafariServices
import SwiftUI
import AVKit
struct Song: Codable {
    var artistName: String
    var trackName: String
    var previewUrl: URL
    var artworkUrl100: URL
    var trackPrice: Double?
    var collectionName: String?

}
struct Traintime: Codable {
    var DepartureTime:String
    var StationName:StationName
    var hour:Int{
        get{
            return Int(DepartureTime.components(separatedBy: ":")[0])!
        }
    }
    var minute:Int{
        get{
            return Int(DepartureTime.components(separatedBy: ":")[1])!
        }

    }
}

struct Traininfo: Codable ,Identifiable{
    let id=UUID()
    var TrainDate:String
    var OriginStopTime:Traintime
    var DestinationStopTime:Traintime
}
struct StationName: Codable {
    var Zh_tw:String
    var En:String
}


struct dataset :Identifiable{
    var id=""
    var like:Int
    var name=""
}
struct dataset2 :Identifiable{
    var id=""
    var song=""
    var mess=""
    var time:Timestamp
}

struct SongResults: Codable {
    var resultCount: Int
    var results: [Song]
}
extension String{
    func ischinese()->Bool{
        for i in self.unicodeScalars{
            if i.isASCII==false{
                return true
            }
        }
        return false
    }
}

class getData:ObservableObject{
    var didChange = PassthroughSubject<getData,Never>()
    @Published var data = [dataset](){
        didSet{
            didChange.send(self)
        }
    }
    init(){
        let db = Firestore.firestore()
        db.collection("stocks").getDocuments { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            for i in (snap!.documents){
                let like=i["like"]as!Int
                let id=i.documentID
                let name=i["name"]as!String

                DispatchQueue.main.async {
                    self.data.append(dataset(id:id,like:like,name: name))
                }
            }
        }
        db.collection("stocks").addSnapshotListener { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            for i in (snap!.documentChanges){
                if(i.type == .modified){
                    let like=i.document["like"]as!Int
                    let id=i.document.documentID
                DispatchQueue.main.async {
                    let index=self.data.firstIndex {
                        return $0.id==id
                    }
                    self.data[index!].like=like
                    }
                }
            }
        }
    }
    
}
struct SafariViewController: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
extension CGFloat {
    public func show ()-> Int {
        return Int(self)
    }
}
struct Person:Codable,Identifiable {
    var id=UUID()
    var name=""
    var account=""
    var birth:Date
    var isReg=false
}
class Peopledata : ObservableObject{
    @Published var people = [Person](){
        didSet{
            let encoder=JSONEncoder()
            if let data = try? encoder.encode(people){
                UserDefaults.standard.set(data,forKey: "people")
            }
        }
    }
    init(){
        if let data = UserDefaults.standard.data(forKey: "people"){
            let decorder=JSONDecoder()
            if let decodeData=try? decorder.decode([Person].self, from: data){
                people=decodeData
            }
        }
        if people.count==0{
                    people.append(Person(name: "", account: "", birth: Date.init()))
        }
    }
    
}
struct Photo: Codable {
    var content: String
    var imageName: String
    
    var imagePath: String {
        return PhotoData.documentsDirectory.appendingPathComponent(imageName).path
    }
}
class PhotoData: ObservableObject {

    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @Published var photos = [Photo]() {
        didSet {
            if let data = try? PropertyListEncoder().encode(photos) {
                let url = PhotoData.documentsDirectory.appendingPathComponent("photos")
                try? data.write(to: url)
            }
        }
    }
    init() {
               let url = PhotoData.documentsDirectory.appendingPathComponent("photos")
               if let data = try? Data(contentsOf: url), let array = try?  PropertyListDecoder().decode([Photo].self, from: data) {
                   photos = array
               }
           }
}

struct ImagePickerController: UIViewControllerRepresentable {
    
    @Binding var selectImage: UIImage?
    @Binding var showSelectPhoto: Bool
    
    func makeCoordinator() -> ImagePickerController.Coordinator {
        Coordinator(self)
    }
        
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var imagePickerController: ImagePickerController
        
        init(_ imagePickerController: ImagePickerController) {
            self.imagePickerController = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePickerController.showSelectPhoto = false
            imagePickerController.selectImage = info[.originalImage] as? UIImage
        }
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerController>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerController>) {
    }
    
    
}
struct player :UIViewControllerRepresentable{
    var url:URL
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) ->  AVPlayerViewController{
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: url)
        return controller
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<player>) {
        
    }
}
class getData2:ObservableObject{
    var didChange = PassthroughSubject<getData2,Never>()
    @Published var data = [dataset2](){
        didSet{
            didChange.send(self)
        }
    }
    init(){
        let db = Firestore.firestore()
       /* db.collection("message").getDocuments { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            for i in (snap!.documents){
                let id=i["id"]as!String
                let mess=i["mess"]as!String

                DispatchQueue.main.async {
                    self.data.append(dataset2(id: id, mess: mess))
                }
            }
        }*/
        db.collection("message").addSnapshotListener { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            for i in (snap!.documentChanges){
                if i.type == .added{
                    
                DispatchQueue.main.async {
                    let id=i.document.documentID
                    let song=i.document["song"]as!String
                    let mess=i.document["mess"]as!String
                    let time=i.document["time"]as!Timestamp

                    self.data.append(dataset2(id: id, song:song, mess: mess,time: time))
                    print(self.data)


                    }
                }
                if i.type == .removed{
                    
                DispatchQueue.main.async {
                    let id=i.document.documentID
                    let index=self.data.firstIndex { (data) -> Bool in
                        return data.id==id
                    }
                    self.data.remove(at: index!)

                    }
                }
            }
        }
    }
    
}
