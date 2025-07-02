//
//  TextFieldExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 19/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField{
    func applyColorTheme(){
        let color = UIColor.getAppThemeColor()
        self.selectedTitleColor = color
        self.tintColor = color
        self.selectedTitleColor = color
        self.selectedLineColor = color
    }
}


class CustomUITextField: SkyFloatingLabelTextField {

        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            // Disable all editing menu actions like copy/paste
            return false
        }

        override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
            return []
        }

        override func caretRect(for position: UITextPosition) -> CGRect {
            return .zero
        }

        override var inputAssistantItem: UITextInputAssistantItem {
            let item = super.inputAssistantItem
            item.leadingBarButtonGroups = []
            item.trailingBarButtonGroups = []
            return item
        }

        // 🚫 Disables double-tap and long press gestures after UIKit adds them
        override func didMoveToWindow() {
            super.didMoveToWindow()
            disableSystemGestures()
        }

        private func disableSystemGestures() {
            self.gestureRecognizers?.forEach { recognizer in
                if recognizer is UITapGestureRecognizer || recognizer is UILongPressGestureRecognizer {
                    recognizer.isEnabled = false
                }
            }
        }
    }


