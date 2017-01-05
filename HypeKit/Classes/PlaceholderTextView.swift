//
//  PlaceholderTextView.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

class PlaceholderTextView: UITextView {
    fileprivate var observingTextChange = false
    fileprivate var editing = false

    override var contentOffset: CGPoint {
        didSet {
            if !contentShouldBeScrollable && contentOffset.y > 0 {
                contentOffset.y = 0
            }
        }
    }

    /// The regular UITextView will scroll the
    /// content up, even when the text view is large enough to hold the
    /// content without scrolling.  Override that behavior.
    /// contentShouldBeScrollable is used by the contentOffset override.
    fileprivate var contentShouldBeScrollable: Bool {
        get { return ceil(contentSize.height) > ceil(frame.height) }
    }


    override var text: String! {
        get { return super.text }
        set {
            if !editing && newValue == "" {
                super.text = placeholder
            } else {
                super.text = newValue
            }
            adjustFontAndTextColor()
        }
    }
    fileprivate var _placeholder: String = ""

    var placeholder: String {
        get { return _placeholder }
        set {
            let currentValue = _placeholder
            _placeholder = newValue

            if text == currentValue {
                text = newValue
            }

            if newValue != "" {
                if !observingTextChange {
                    NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
                    NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing(_:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
                    NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing(_:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
                    observingTextChange = true
                }
            } else if observingTextChange {
                NotificationCenter.default.removeObserver(self)
                observingTextChange = false
            }
        }
    }

    fileprivate var _regularFont: UIFont?
    fileprivate var settingFontInternally = false

    override var font: UIFont? {
        get { return super.font }
        set {
            if !settingFontInternally {
                _regularFont = newValue
            }

            super.font = newValue
        }
    }

    fileprivate var _regularTextColor: UIColor?
    fileprivate var settingTextColorInternally = false

    override var textColor: UIColor? {
        get { return super.textColor }
        set {
            if !settingTextColorInternally {
                _regularTextColor = newValue
            }

            super.textColor = newValue
        }
    }

    fileprivate var _placeholderFont: UIFont?

    var placeholderFont: UIFont? {
        get { return _placeholderFont ?? _regularFont }
        set {
            _placeholderFont = newValue

            if text == placeholder {
                settingFontInternally = true
                font = placeholderFont
                settingFontInternally = false
            }
        }
    }

    fileprivate var _placeholderTextColor: UIColor?

    var placeholderTextColor: UIColor? {
        get { return _placeholderTextColor ?? _regularTextColor }
        set {
            _placeholderTextColor = newValue

            if text == placeholder {
                settingTextColorInternally = true
                textColor = placeholderTextColor
                settingTextColorInternally = false
            }
        }
    }

    var textWithoutPlaceholder: String {
        get { return (text != placeholder) ? text : "" }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        _regularFont = super.font

        if text == "" {
            text = placeholder
        }

        settingTextColorInternally = true
        settingFontInternally = true

        if text == placeholder {
            textColor = placeholderTextColor
            font = placeholderFont
        }

        settingTextColorInternally = false
        settingFontInternally = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _regularFont = super.font

        if text == "" {
            text = placeholder
        }

        settingTextColorInternally = true
        settingFontInternally = true

        if text == placeholder {
            textColor = placeholderTextColor
            font = placeholderFont
        }

        settingTextColorInternally = false
        settingFontInternally = false
    }

    deinit {
        if observingTextChange {
            NotificationCenter.default.removeObserver(self)
        }
    }

    internal func textDidChange(_ notification: Notification) {
        adjustFontAndTextColor()
    }

    internal func textDidBeginEditing(_ notification: Notification) {
        editing = true

        if text == placeholder {
            text = ""
        }

    }

    internal func textDidEndEditing(_ notification: Notification) {
        editing = false

        text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if text == "" {
            text = placeholder
        }
    }

    fileprivate func adjustFontAndTextColor() {
        settingFontInternally = true
        settingTextColorInternally = true

        if !editing && text == placeholder {
            textColor = placeholderTextColor
            font = placeholderFont
        } else {
            textColor = _regularTextColor
            font = _regularFont
        }

        settingFontInternally = false
        settingTextColorInternally = false

    }




}
