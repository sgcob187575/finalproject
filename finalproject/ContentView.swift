//
//  ContentView.swift
//  finalproject
//
//  Created by 陳昱豪 on 2019/12/19.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    @State var songname="我怎麼哭了"
    @State var  peopledata=Peopledata()
    @State var photoData = PhotoData()
    var body: some View {
              TabView {
                Trainview().tabItem {
                    Text("火車")
                    Image(systemName: "tram.fill")
                }
                register().tabItem {
                    Text("身份")
                    Image(systemName: "rectangle.stack.person.crop.fill")
                }
                Likesinger()
                  .tabItem {
                      Text("八三夭")
                      Image(systemName: "hand.thumbsup.fill")
              }
              .padding(.bottom, 49)
              
              Songlistview(songname:$songname)
                  .tabItem {
                      Text("歌曲")
                      Image(systemName: "music.house")
              }
                berglas()
                                 .tabItem {
                                     Text("魔術")
                                     Image(systemName: "m.circle")
                             }
                }.environmentObject(peopledata).environmentObject(photoData)
              .overlay(MusicBar(songname:songname).offset(x: 0, y: -49), alignment: .bottom)}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Peopledata())
    }
}
