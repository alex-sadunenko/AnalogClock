//
//  ContentView.swift
//  Clock
//
//  Created by Alex on 27.11.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var isDark = false
    @State var currentTime = Time(sec: 15, min: 10, hour: 10)
    var reseiver = Timer.publish(every: 1, on: .current, in: .default)
        .autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Text("Analog clock")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
                Appearance(isDark: $isDark)
                    .preferredColorScheme(isDark ? .dark : .light)
            }
            .padding()
            Spacer()
            ClockFace(isDark: $isDark, currentTime: $currentTime)
        }
        .onAppear(perform: {
            getTimeComponents()
        })
        .onReceive(reseiver) { _ in
            getTimeComponents()
        }
    }
    
    private func getTimeComponents() {
        let calendar = Calendar.current
        let sec = calendar.component(.second, from: Date())
        let min = calendar.component(.minute, from: Date())
        let hour = calendar.component(.hour, from: Date())
        withAnimation(Animation.linear(duration: 0.2)) {
            currentTime = Time(sec: sec, min: min, hour: hour)
        }
   }
}

struct Time {
    var sec: Int
    var min: Int
    var hour: Int
}

struct ClockFace: View {
    
    @Binding var isDark: Bool
    @Binding var currentTime: Time
    
    var width = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(isDark ? .white : .black))
                .opacity(0.1)
            ForEach(0..<60) { second in
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: (second % 5) == 0 ? 15 : 5)
                    .offset(y: (width - 95) / 2)
                    .rotationEffect(.init(degrees: Double(second) * 6))
            }
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 2, height: (width - 120) / 2)
                    .offset(y: -(width - 120) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (width - 160) / 2)
                    .offset(y: -(width - 160) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.min) * 6))
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width - 200) / 2)
                    .offset(y: -(width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.hour) * 30))
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
            
        }
        .frame(width: width - 80, height: width - 80)
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Appearance: View {
    
    @Binding var isDark: Bool
    var body: some View {
        Button(action: { isDark.toggle() }) {
        
        Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
            .font(.system(size: 22))
            .foregroundColor(isDark ? .black : .white)
            .padding()
            .background(Color.primary)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
}
