import SwiftUI

struct SliderView: View {
    @State var percentage: Float = 50
    let screenSize: CGRect = UIScreen.main.bounds
    var body: some View {
        VerticalSlider(offsetX:  screenSize.width * 0.7)
            .frame(width:250, height:  400)
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView()
    }
}
