//
//  ContentView.swift
//  CreditCardFormatter
//
//  Created by William Calkins on 5/15/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    //@ObservedObject var cardViewModel = CardViewModel()
    
    @State private var cardNumber: String = ""
    @State private var expirationDate: String = ""
    @State private var sleepAmount = 8.0
    
    var body: some View {
        VStack {
            HStack {
                TextField("Card Number", text: $cardNumber) { editing in
                    print("backing card number from VM: \(cardNumber); length: \(cardNumber.count)")
                } onCommit: {
                    print("committed change")
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.creditCardNumber)
                .keyboardType(.numberPad)
                
                ScanButton(text: $cardNumber)
                  .frame(width: 26, height: 56, alignment: .leading)
            }
           
            
            HStack {
                TextField("Exp Date", text: $expirationDate) { editing in
                    print("exp date editing \(editing)")
                } onCommit: {
                    print("committed changes")
                }
                .textContentType(.dateTime)
                .toolbar(content: {
                  ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    ScanButton(text: $expirationDate)
                  }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                Spacer()
            }
            
            HStack {
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12)
            }
            
            //ValidationView()
        }
        .padding()
    }
}

struct ValidationView: View {
    
    @State private var textToValidate: String = ""
    
    var body: some View {
        
        VStack {
            TextField("Validate Me", text: $textToValidate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.alphabet)
            ValidationView()
            ValidationView()
            ValidationView()
            ValidationView()
        }
    }
}

struct ValidationCriteriaView: View {
    
    @State private var isValid: Bool
    var validationText: String
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle.fill")
            Text(validationText)
                .font(.body)
        }
        
    }
}

final class CardViewModel: ObservableObject {
    
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    
    var backingCardNumber: String = ""
    var cardLength: Int = 0
    
    private var disposables = Set<AnyCancellable>()
    
    init() {
        //Filter just numbers
        //add a space every fourth char
        $cardNumber
            .filter {$0.isNumeric}
            .print()
            .count()
            .print()
            .assign(to: \.cardLength, on: self)
            .store(in: &disposables)
    }
    
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
