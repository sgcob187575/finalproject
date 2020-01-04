import SwiftUI
struct MyButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      
  }

}
struct berglas: View {
    @State private var card:String="牌背"
    @State private var nowDate=Date()
    var timer:Timer{
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
            self.nowDate=Date()
        }
    }
    var second: Int {
        Calendar.current.component(.second, from: nowDate)
    }
    func countDownString(nowDate: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar
            .dateComponents([.hour, .minute, .second]
                ,from: nowDate)
        return String(format: "%02d:%02d:%02d",
                      components.hour ?? 00,
                      components.minute ?? 00,
                      components.second ?? 00)
    }
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Text(countDownString(nowDate: nowDate)).foregroundColor(Color.white)
                    .onAppear(perform: {
                        _ = self.timer
                    }).padding()
            }
            Spacer()
            HStack (spacing:0){
                VStack(spacing:0){
                Button(action: {
                    self.card=String(self.second%13)+"H"
                }, label: {
                    cardimage(card: card, ali: .topLeading)

                }).buttonStyle(MyButtonStyle())
                Button(action: {
                        self.card=String(self.second%13)+"C"

                    }, label: {
                        cardimage(card: card, ali: .bottomLeading)

                    }).buttonStyle(MyButtonStyle())
                }
                VStack(spacing:0){
                Button(action: {
                    self.card=String(self.second%13)+"S"

                }, label: {
                    cardimage(card: card, ali: .topTrailing)
                    }).buttonStyle(MyButtonStyle())

                Button(action: {
                        self.card=String(self.second%13)+"D"

                    }, label: {
                        cardimage(card: card, ali: .bottomTrailing)

                        })  .buttonStyle(MyButtonStyle())
                    }
            }
            Spacer()
    }.background(Image("背景"))
}
}
struct berglas_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct cardimage: View {
    var card:String
    var ali:Alignment
    var body: some View {
        ((Image(card).renderingMode(.original).resizable().scaledToFit().frame(width:320)).scaledToFill().frame(width:310,height: 480).clipped().cornerRadius(20)).frame(width:155,height: 240,alignment: ali).clipped().contentShape(TapShape())
        
    }
    struct TapShape : Shape {
           func path(in rect: CGRect) -> Path {
               return Path(CGRect(x: 0, y: 0, width: 155, height: 240))
           }
       }
}
