//
//  ScanButton.swift
//  CreditCardFormatter
//
//  Created by William Calkins on 11/19/21.
//

import Foundation
import SwiftUI

enum ScanTypes {
    case routingNumber, bankAcctNumber, creditCard, vehicleID, notSpecified
    init() {
        self = .notSpecified
    }
}

struct ScanButton: UIViewRepresentable {
    
    @Binding var text: String
    
    let scanType = ScanTypes()
    
    func makeUIView(context: Context) -> UIButton {
        
        let textFromCamera = UIAction.captureTextFromCamera(responder: context.coordinator, identifier: nil)
        let button = UIButton(type: .custom, primaryAction: textFromCamera)
        
        button.setImage(UIImage(systemName: "camera.badge.ellipsis"), for: .normal)
        button.menu = UIMenu(children: [textFromCamera])
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: UIResponder, UIKeyInput {
        let parent: ScanButton
        
        init(_ parent: ScanButton) {
            self.parent = parent
        }
        
        var hasText = false
        
        func insertText(_ text: String) {
            parent.text = text
            //parent.title = "Add \(text)"
        }
        func deleteBackward() { }
        
    }
}

// MARK: - Preview
struct ScanButton_Previews: PreviewProvider {
    static var previews: some View {
        ScanButton(text: .constant("") )
            .previewLayout(.sizeThatFits)
    }
}
