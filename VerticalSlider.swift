import SwiftUI

//TODO изменить форму слайдера на набор вертикальных капсулей
//      каждая капсула имеет свой цвет и размер
//      0 - синий - нет боли
//      100 красный - слильная боль
//      подписи в SliderPin брать из массива структур {от..до; текст в пин; текст в описание}

struct VerticalSlider: View {
    
    @State var percentage: Float = 50
    var offsetX: CGFloat = 150
    @State private var numOfSegments: Int = 0
    let colors: [Color] = [
        Color(red: 0.72, green: 0.00, blue: 0.00),
        Color(red: 0.72, green: 0.00, blue: 0.00),
        Color(red: 0.92, green: 0.59, blue: 0.58),
        Color(red: 0.98, green: 0.82, blue: 0.76),
        Color(red: 1.00, green: 0.95, blue: 0.74),
        Color(red: 0.83, green: 0.77, blue: 0.98),
        Color(red: 0.75, green: 0.83, blue: 0.95),
        Color(red: 0.77, green: 0.87, blue: 0.96),
        Color(red: 0.75, green: 0.85, blue: 0.86),
        Color(red: 0.76, green: 0.88, blue: 0.77),
    ]
    var body: some View {
        ZStack() {
            VStack(spacing: 0){
                ForEach(0..<10) {
                    HorBar(num: $0)
                        .foregroundColor(colors[$0])
                }
            }.offset(x: -100)

                
            SliderBase(percentage: $percentage)
                
        }.offset(x: self.offsetX / 2 )
    }
}

struct SliderBase: View {
    @Binding var percentage: Float
    @State private var animated = false
    
    var body: some View {
        GeometryReader { geometry in
            
            
            
            
            SliderPin(animate: self.$animated, percentage: self.$percentage)
                .offset(x:self.animated ? CGFloat(-2*self.percentage):0,
                        y: (geometry.size.height - (geometry.size.height * CGFloat(self.percentage / 100)) - 200))
                .frame(width:250, height:  400)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                    .onEnded({ _ in
                        withAnimation() {
                            self.animated = false
                        }
                    })
                    .onChanged({ value in
                        var valY = value.location.y / 40;
                        valY = round(valY)*40;
                        withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.9)) {
                            self.animated = true
                        }
                        self.percentage = min(
                            max(0,
                                Float(100 * (geometry.size.height - valY) / geometry.size.height ))
                            , 100
                        )
                        
                    }))
            
        }
    }
}

struct SliderPin: View {
    @Binding var animate: Bool
    @Binding var percentage: Float

    var body: some View {
        ZStack {

            Capsule()
                .foregroundColor(.pink)
                .frame(width: 100, height: 40)
            Capsule()
                .foregroundColor(.white)
                .frame(width: 90, height: 30)
            Text("\(Int(percentage))")
                .foregroundColor(.black)
        }.offset(y: 20)
    }
}

struct HorBar: Shape {
    var num: Int
    
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let minx_delta = (CGFloat(num)*20 + 1)

        path.move(to: CGPoint(x: rect.minX+minx_delta, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX+minx_delta, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.minX+minx_delta, y: rect.minY))
        return path
    }
}

