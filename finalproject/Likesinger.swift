//
//  Likesinger.swift
//  finalproject
//
//  Created by 陳昱豪 on 2019/12/28.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct Likesinger: View {
    @State private var showWebpage = false
    @ObservedObject var data1=getData()
    @EnvironmentObject var photoData :PhotoData
    var body: some View {
        VStack{
            HStack{
                Spacer()
                if self.photoData.photos.count>0{
            Image(uiImage:UIImage(contentsOfFile: self.photoData.photos[0].imagePath)!).resizable().frame(width:60,height: 60).clipShape(Circle())
                }
                else{
                    Image(systemName: "photo")
                    .resizable().frame(width:60,height: 60).clipShape(Circle())
                    }
                
            
                Spacer()
            Text("官方網站").foregroundColor(.blue).onTapGesture {
                self.showWebpage=true
                }
                Spacer()
            }
        List{
            ForEach(data1.data.sorted { $0.like > $1.like}){ i in
            HStack{
                Spacer()
                Image(i.id).resizable().frame(width:150,height: 150).clipShape(Circle())
                Spacer()
                    Text("\(i.name)").padding().background(Color.init(red: 215/255, green: 109/255, blue: 219/255)).cornerRadius(30)
                Text("\(i.like)").padding().foregroundColor(Color.init(red: 123/255, green: 118/255, blue: 119/255)).background(Color.init(red: 1/255, green: 223/255, blue: 226/255)).cornerRadius(30).fixedSize()
                    
                Spacer()
                Image("like").resizable().frame(width:80,height: 40).onTapGesture {
                    self.presslike(id: i.id)
                }
                Spacer()
            }
        }.listRowInsets(EdgeInsets()).background(Color.init(red: 99/255, green: 8/255, blue: 1/255))
        } .sheet(isPresented: $showWebpage) {
            SafariViewController(url: URL(string: "https://www.band831.com/")!)
        }
        }
    }
    func presslike(id:String){
        let db = Firestore.firestore()
        let index=self.data1.data.firstIndex {
            return $0.id==id
        }

        let pre=data1.data[index!].like
        db.collection("stocks").document(id).setData(["like":pre+1], merge: true)
    }}

struct Likesinger_Previews: PreviewProvider {
    static var previews: some View {
        Likesinger()
    }
}

