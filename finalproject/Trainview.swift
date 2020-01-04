//
//  Trainview.swift
//  finalproject
//
//  Created by 陳昱豪 on 2020/1/3.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import CryptoKit
struct Trainview: View {
    @State private var trains = [Traininfo]()
    @State private var trainoffset:CGFloat=1000
    var body: some View {
        VStack{

            Text("火車回家時間").font(Font.system(size: 30)).padding().background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 254/255, green: 216/255, blue: 213/255), Color.init(red: 203/255, green: 239/255, blue: 246/255)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))).frame(width: 300, height: 150).onAppear{
                withAnimation ( Animation.linear(duration: 3)){
                    self.trainoffset = self.trainoffset-1700
                }
            }
            ForEach(trains.filter({
            return ($0.OriginStopTime.hour==getnowhour())||($0.OriginStopTime.hour==getnowhour()+1)
        }).sorted {
            if $0.OriginStopTime.hour==$1.OriginStopTime.hour{
                return $0.OriginStopTime.minute < $1.OriginStopTime.minute}
            else{
                return $0.OriginStopTime.hour < $1.OriginStopTime.hour
            }
            
        }) { (train)  in
            TrainRow(starttrain: train.OriginStopTime,endtrain: train.DestinationStopTime)

            }
            Image("火車").offset(x:trainoffset)
            Spacer()
            }.onAppear{
                self.fetchTrain(date:self.getnowtime(), start: "0900", end: "1040")

        }
    }
    func getnowtime() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let time = dateFormater.string(from: Date())
        return time
    }
    func getnowhour() -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH"
        let time = Int(dateFormater.string(from: Date()))!
        return time
    }

    func getTimeString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormater.locale = Locale(identifier: "en_US")
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormater.string(from: Date())
        return time
    }
    func fetchTrain(date:String,start:String,end:String) {
        let query="https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/DailyTimetable/OD/"+start+"/to/"+end+"/"+date+"?$top=70&$format=JSON"
        if let urlStr = query.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed){
            
            if let url = URL(string: urlStr) {
                let APP_ID = "a3da73a6a8f04faa8b9d81c50e3c1801"
                let APP_KEY = "NlDv3IXo_jZ8z_4phPfn21jRbZw"

                let xdate = getTimeString()
                let signDate = "x-date: \(xdate)"
                let key = SymmetricKey(data: Data(APP_KEY.utf8))
                let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
                let base64HmacString = Data(hmac).base64EncodedString()
                let authorization = """
                hmac username="\(APP_ID)", algorithm="hmac-sha256", headers="x-date", signature="\(base64HmacString)"
                """
                var request = URLRequest(url: url)
                request.setValue(xdate, forHTTPHeaderField: "x-date")
                request.setValue(authorization, forHTTPHeaderField: "Authorization")

                request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
                URLSession.shared.dataTask(with: request) { (data, response , error) in
                    let decoder = JSONDecoder()
                    if let data = data, let trainResults = try? decoder.decode([Traininfo].self, from: data) {
                        self.trains = trainResults
                    }
                    else{
                        print("error")
                    }
                }.resume()
            }
        }
    }
    struct Trainview_Previews: PreviewProvider {
        static var previews: some View {
            Trainview()
        }
    }
}
