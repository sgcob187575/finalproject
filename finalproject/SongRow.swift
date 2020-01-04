
import SwiftUI
import KingfisherSwiftUI
struct SongRow: View {
    var song:Song
    var body: some View {
        HStack{
            
            KFImage(song.artworkUrl100).renderingMode(.original).resizable().scaledToFit().frame(width: 80, height: 80).clipShape(Circle())
            VStack(alignment: .
            leading
            ){
                Text(song.trackName)
                    .foregroundColor(Color.primary)
                Text(song.artistName)
                    .foregroundColor(Color.primary)
                
            }
            Spacer()
        }    }
}

struct SongRow_Previews: PreviewProvider {
    static var previews: some View {
        SongRow(song:Song(artistName: "八三夭", trackName: "馬子狗", previewUrl: URL(string:"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview123/v4/79/1a/7c/791a7c2b-1f04-f028-7417-904a72447906/mzaf_3011716718120675797.plus.aac.p.m4a")!, artworkUrl100: URL(string:"https://is5-ssl.mzstatic.com/image/thumb/Music123/v4/20/b0/b4/20b0b419-9104-06c4-2286-9c9c67bf248e/source/100x100bb.jpg")!)).previewLayout(.fixed(width: 300, height: 70))
    }
}

