//
//  ContentView.swift
//  BetterRest
//
//  Created by Angelo Cammaroto on 24/05/21.
//

import SwiftUI

struct ContentView: View {
    
    static var defaultWakeUpTime :Date  {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeUpTime
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    func calculateBedTime() {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
            showingAlert = true
        } catch {
            
            alertTitle = "Woops"
            alertMessage = "Something goes wrong!"
            showingAlert = true
        }
        
    }
    
    @State private var value = 0
       let colors: [Color] = [.orange, .red, .gray, .blue,
                              .green, .purple, .pink]

       func incrementStep() {
           value += 1
           if value >= colors.count { value = 0 }
       }

       func decrementStep() {
           value -= 1
           if value < 0 { value = colors.count - 1 }
       }
    var body: some View {
        
        
        VStack(alignment:.leading) {
            
            Image("header")
                .resizable()
                .frame(width: .infinity, height: 280)
                .edgesIgnoringSafeArea(.all)
            
            
            
            
                Section(header:Text("When do you want to wake up?").font(.headline)) {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    
                }.padding(.leading, 10).colorInvert()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep").font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                        
                    }
                    
                }.padding().colorInvert()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffe intake").font(.headline).colorInvert()
                    
                    
                    
                    Stepper(value: $coffeeAmount, in: 1...20, step: 1){
                        if(coffeeAmount == 1) {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")}
                    }.foregroundColor(.black)
                    .colorInvert()
                    
                }.padding()
                
                
                
                HStack {
                    Spacer()
                    Button("Calculate Bet Time") {
                        calculateBedTime()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(40)
                    .colorInvert()
                    
                    Spacer()
                }
         
            
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(  Color(red:13/255, green: 10/255, blue: 19/255).edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            
        })
    }
    
    
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .previewDevice("iPhone 12 Pro")
        }
    }
    
}
