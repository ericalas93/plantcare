//
//  SwiftUIView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import SwiftUI

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
}

func getDegree(last: Date, next: Date) -> Double {
    let today = Date()
    let totalDistance =  DateInterval(start: last, end: next).duration
    let tillTodayDistance =  DateInterval(start: last, end: today).duration

    if totalDistance == 0 {
        return 0
    }
    let percent = tillTodayDistance / totalDistance
    let degree = percent * 360

    return degree
}


func getCircleColours(degree: Double) -> (foregroundColor: Color, backgroundColor: Color) {
    if Int(degree) < 270 {
        return (foregroundColor: Color("GreenDark"), backgroundColor: Color("GreenLight"))
    }
    
    return (foregroundColor: Color("PinkDark"), backgroundColor: Color("PinkLight"))
}

func getLabel(next: Date, degree: Double) -> String {
    if Int(degree) < 270 {
        return "on: \(getDateString(date: next))"
    }
    
    return "Needed"
}

struct PlantRingView: View {
    var last : Date
    var next : Date
    var title : String
    var Icon : Image

    var body: some View {
        let degree = getDegree(last: last, next: next)
        let (foregroundColor, backgroundColor) = getCircleColours(degree: degree)
        let label = getLabel(next: next, degree: degree)

        VStack {
            Text(title.uppercased())
                .font(Font.system(size: 20).bold())
            Text(label)
                .font(Font.system(size: 12))
                .foregroundColor(.secondary)
            ZStack {
                Arc(startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
                    .stroke(backgroundColor, lineWidth: 5)
                Arc(startAngle: .degrees(0), endAngle: .degrees(degree), clockwise: true)
                    .stroke(foregroundColor, lineWidth: 5)
                Icon
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 20))
            }
            .frame(width: 50, height: 50, alignment: .center)

        }
    }
}

struct PlantRingView_Previews: PreviewProvider {
    static var previews: some View {
        let last = Calendar.current.date(byAdding: .day, value: -5, to: Date())
        let next =  Calendar.current.date(byAdding: .day, value: 10, to: Date())
        let icon = Image(systemName: "drop")
        PlantRingView(last: last!, next: next!, title: "Water", Icon: icon)
    }
}
