//
//  Songlistview.swift
//  finalproject
//
//  Created by 陳昱豪 on 2019/12/28.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct Songlistview: View {
    @State private var songs = [Song]()
    @State private var showMV=false
    @Binding var songname: String
    func fetchSongs() {
        if let urlStr = "https://itunes.apple.com/search?term=八三夭&media=music&country=TW&limit=200".addingPercentEncoding(withAllowedCharacters:
         .urlQueryAllowed) {
         if let url = URL(string: urlStr) {
         URLSession.shared.dataTask(with: url) { (data, response , error) in
             let decoder = JSONDecoder()
             if let data = data, let songResults = try? decoder.decode(SongResults.self, from: data) {
                 self.songs = songResults.results
             }
        self.chineseSongs()
         }.resume()
         }
        }
    }
    func chineseSongs() {
        print(self.songs.count)
        var removeindex=[Int]()
        for i in self.songs.indices{            if(self.songs[i].trackName.ischinese()==false){
            removeindex.append(i)
            }
        }
        var count=0

        for i in removeindex.indices{
            self.songs.remove(at: removeindex[i]-count)
            count+=1
        }
        
    }

    
    var body: some View {

        List(songs.indices, id: \.self) { (index)  in
            SongRow(song: self.songs[index]).onTapGesture {
                self.songname=self.songs[index].trackName
                print(self.songs[index].trackName)
            }.onLongPressGesture(minimumDuration: 1.5) {
                self.songname=self.songs[index].trackName
                self.showMV=true
            }.sheet(isPresented: self.$showMV){mvplayer(songname:self.songname)}
            }.onAppear{
            self.fetchSongs()

        }
        
    }
}
