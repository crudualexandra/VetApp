import SwiftUI

struct RingChart: View {
    var values: [(value: Double, color: Color)]
    
    private var total: Double {
        values.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<values.count, id: \.self) { index in
                RingSegment(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: values[index].color
                )
            }
            
            Circle()
                .fill(Theme.deepBlue)
                .frame(width: 80, height: 80)
            
            Text(total > 0 ? "\(Int(total))" : "0")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    private func startAngle(for index: Int) -> Double {
        guard total > 0 else { return 0 }
        if index == 0 { return 0 }
        
        let previousValues = values[0..<index].map { $0.value }
        let sumOfPreviousValues = previousValues.reduce(0, +)
        
        return (sumOfPreviousValues / total) * 360
    }
    
    private func endAngle(for index: Int) -> Double {
        guard total > 0 else { return 0 }
        let currentValues = values[0...index].map { $0.value }
        let sumOfCurrentValues = currentValues.reduce(0, +)
        
        return (sumOfCurrentValues / total) * 360
    }
}

struct RingSegment: View {
    var startAngle: Double
    var endAngle: Double
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.black.opacity(0.3), style: StrokeStyle(lineWidth: 20, lineCap: .round))
            
            Circle()
                .trim(from: CGFloat(startAngle / 360), to: CGFloat(endAngle / 360))
                .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
