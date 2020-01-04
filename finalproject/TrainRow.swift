//
//  TrainRow.swift
//  finalproject
//
//  Created by 陳昱豪 on 2020/1/3.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct TrainRow: View {
    var starttrain:Traintime
    var endtrain:Traintime
    var body: some View {
        HStack(spacing: 0){
            
            Spacer()
            VStack{
            Text(starttrain.StationName.Zh_tw)
                Text(starttrain.StationName.En).fixedSize()

            }
            HStack(spacing: 0){
            if(starttrain.hour>9){
                Text("\(starttrain.hour):")
            }
            else{Text("0")+Text("\(starttrain.hour):")}
            if(starttrain.minute>9){
                Text("\(starttrain.minute)")
            }
            else{Text("0")+Text("\(starttrain.minute):")}
                }.frame(width: 70).fixedSize()
            Image("箭頭").resizable().frame(width: 70, height: 30)
            HStack(spacing: 0){
            if(endtrain.hour>9){
                Text("\(endtrain.hour):")
            }
            else{Text("0")+Text("\(endtrain.hour):")}
            if(endtrain.minute>9){
                Text("\(endtrain.minute)")
            }
            else{Text("0")+Text("\(endtrain.minute)")}
                
                }.frame(width: 70).fixedSize()
            VStack{
            Text(endtrain.StationName.Zh_tw)
                Text(endtrain.StationName.En).fixedSize()

            }
            Spacer()
            

        }
    }
}

struct TrainRow_Previews: PreviewProvider {
    static var previews: some View {
        TrainRow(starttrain: Traintime(DepartureTime: "13:15",StationName:StationName(Zh_tw: "基隆", En: "keelong") ), endtrain: Traintime(DepartureTime: "14:15", StationName:StationName(Zh_tw: "樹林", En: "shulin") ))
    }
}
