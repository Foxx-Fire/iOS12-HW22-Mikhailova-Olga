//
//  ExtensionResponder.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 27.05.2024.
//

import UIKit

extension UIResponder {
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    // to find first responder
    // return current first responder if it exist
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}