//
//  register.swift
//  finalproject
//
//  Created by 陳昱豪 on 2019/12/28.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct register: View {
    @State private var name = ""
    @State private var account=""
    @State private var selectDate = Date()
    @State private var isReg=false
    @State private var scale: CGFloat = 1
    @State private var bright: Double = 0.2
    @State private var showSelectPhoto = false
    @State private var selectImage: UIImage?
    @EnvironmentObject var people:Peopledata
    @State private var showAlert = false
    @EnvironmentObject var photoData :PhotoData
    let today=Date()
    let startdate=Calendar.current.date(byAdding: .year,value: -100, to: Date())!
    var body: some View {
        NavigationView {
            VStack{
                photoblend(scale: self.scale, bright: self.bright,selectImage: self.$selectImage,showSelectPhoto: self.$showSelectPhoto).offset(y:-50)
                Form {
                    scaleslider(scale:self.$scale)
                    brightslider(bright: self.$bright)
                    filedname(name: self.$name)
                    DatePicker("生日",selection: self.$selectDate,in: self.startdate...self.today, displayedComponents: .date)
                    Toggle("是否已加入夭怪村",isOn: $isReg)
                    if isReg{
                        TextField("妖怪村帳號", text: $account).padding().overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 2))
                    }
                }.offset(y:-50)
            }.navigationBarItems(trailing: Button("save", action: {self.people.people[0]=Person(name: self.name, account: self.account, birth: self.selectDate,isReg:self.isReg)
                self.showAlert=true
                if self.selectImage != nil {
                    let imageName = UUID().uuidString
                    let url = PhotoData.documentsDirectory.appendingPathComponent(imageName)
                    try? self.selectImage?.jpegData(compressionQuality: 0.9)?.write(to: url)
                    let photo = Photo(content: self.name, imageName: imageName)
                    self.photoData.photos.insert(photo, at: 0)
                    
                }
            })).alert(isPresented: self.$showAlert) { () -> Alert in
                return Alert(title: Text("儲存成功"))
            }
        }.onAppear{
            if self.people.people.count>0{
            self.name=self.people.people[0].name
            self.account=self.people.people[0].account
            self.selectDate=self.people.people[0].birth
                self.isReg=self.people.people[0].isReg
            }
            if self.photoData.photos.count>0{ self.selectImage=UIImage(contentsOfFile: self.photoData.photos[0].imagePath)!}
        }
    }
}

struct register_Previews: PreviewProvider {
    static var previews: some View {
        register()
    }
}
struct filedname: View {
    @Binding var name:String
    var body: some View {
        TextField("你的名字", text: self.$name)
            .padding().overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 3))
    }
}


struct brightslider: View {
    @Binding var bright:Double
    var body: some View {
        Slider(value: $bright,in:0...1,step:0.01,minimumValueLabel: Image(systemName: "sun.max.fill").imageScale(.small),maximumValueLabel:Image(systemName: "sun.max.fill").imageScale(.large) ){
            Text("")
        }.accentColor(.yellow)
    }
}

struct scaleslider: View {
    @Binding var scale:CGFloat
    var body: some View {
        Slider(value: $scale, in: 0...1,step: 0.05, minimumValueLabel: Text("小"), maximumValueLabel:Text("大")){
            Text("")
            
        }.accentColor(.green)
    }
}

struct photoblend: View {
    var scale:CGFloat
    var bright:Double
    @Binding var selectImage: UIImage?
    @Binding var showSelectPhoto:Bool
    var body: some View {
        ZStack{
            if selectImage != nil {
                        ZStack{
                Image("logo2").renderingMode(.original).scaleEffect(self.scale).brightness(self.bright).frame(width:400,height: 150)
                            Image(uiImage: selectImage!).renderingMode(.original).resizable().scaledToFit().frame(width:400,height: 200).scaleEffect(self.scale).brightness(self.bright).frame(width:400,height: 150).blendMode(.screen)


                }
            } else {
                Image(systemName: "photo")
                    .resizable().onTapGesture {
                                        self.showSelectPhoto = true

                    }.sheet(isPresented: $showSelectPhoto) {
                        ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)
                    }
            }
        }
            /*Image("logo").scaleEffect(self.scale).brightness(self.bright).frame(width:400,height: 150)
            Image(members[selectfavo]).scaleEffect(self.scale).brightness(self.bright).frame(width:400,height: 150)
                .blendMode(.screen)*/
        
    }
}
