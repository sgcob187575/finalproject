//
//  mvplayer.swift
//  finalproject
//
//  Created by 陳昱豪 on 2019/12/29.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
struct mvplayer: View {
    
    var songname:String
    @ObservedObject  var data2=getData2()
    @State private var mess=""
    @State private var deleid=""

    let formatter1 = DateFormatter()
    var body: some View {
        VStack(alignment: .leading){
            player(url:  Bundle.main.url(forResource: "MV/" + songname, withExtension: "mp4")!).frame(height:UIScreen.main.bounds.height/3)
            List(data2.data.filter({ (data) -> Bool in
                return data.song == self.songname
            }) .sorted { $0.time.dateValue() < $1.time.dateValue()}){ i in
                HStack{
                    Text(self.formatter1.string(from: i.time.dateValue()))
                    Text("\(i.mess)")
                }.contextMenu{
                    Button(action: {self.dele(id: i.id)}, label: {Text("delete")})
                    
                }
            }
            Spacer()
            HStack{
                TextField("", text: $mess).padding().overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 3))
                Text("送出").padding().overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.yellow, lineWidth: 3)).onTapGesture {
                    self.send(song: self.songname,mess:self.mess)
                    self.mess=""
                }
            }
    }.onAppear{
    self.formatter1.dateFormat = "y MMM d HH:mm:"
    }
    
    }
    func send(song:String,mess:String){
        let db = Firestore.firestore()
        db.collection("message").addDocument(data: ["time":Timestamp(),"song":song,"mess":mess])
    }
    func dele(id:String){
        let db = Firestore.firestore()
        db.collection("message").document(id).delete()    }


}
struct mvplayer_Previews: PreviewProvider {
    static var previews: some View {
        mvplayer(songname: "想見你")
    }
}
