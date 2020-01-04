//
//  MusicBar.swift
//  finalproject
//
//  Created by 陳昱豪 on 2019/12/28.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import AVFoundation
struct MusicBar: View {
    var songname: String
    @State var isPlay = false
       let player = AVQueuePlayer()
       @State var looper: AVPlayerLooper?
       
       var body: some View {
           HStack {
               Text(songname)
                   .bold()
                   .foregroundColor(.black)
               
               Spacer()
               Button(action: {
                //self.item = AVPlayerItem(url:  Bundle.main.url(forResource: "music/"+self.songname, withExtension: "mp3")!)
                self.looper = AVPlayerLooper(player: self.player, templateItem: .init(url: Bundle.main.url(forResource: "music/"+self.songname, withExtension: "mp3")!))
                   self.isPlay.toggle()
                   if self.isPlay {
                       self.player.play()
                   } else {
                       self.player.pause()
                   }
               }) {
                   Image(systemName: isPlay ? "pause.fill" : "play.fill")
                       .imageScale(.large)
                       .foregroundColor(.white)
               }
               
           }
           .padding()

           .background(Color.init(red: 152/255, green: 224/255, blue: 229/255).opacity(0.5))
       }}


