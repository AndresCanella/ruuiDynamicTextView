//
//  ruuiDynamicTextView.swift
//  react
//
//  Created by Andres Canella on 3/23/16.
//  Copyright © 2016 andres Canella. All rights reserved.
//

import Foundation

class ruuiDynamicTextView: UITextView {
    weak var dynamicDelegate: ruuiDynamicTextViewDelegate?
    var minHeight: CGFloat!
    var maxHeight: CGFloat?
    private var contentOffsetCenterY: CGFloat!
    
    init(frame: CGRect, offset: CGFloat = 0.0) {
        super.init(frame: frame, textContainer: nil)
        minHeight = frame.size.height
        
        //center first line
        let size = self.sizeThatFits(CGSizeMake(self.bounds.size.width, CGFloat.max))
        contentOffsetCenterY = (-(frame.size.height - size.height * self.zoomScale) / 2.0) + offset
        
        //listen for text changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged), name: UITextViewTextDidChangeNotification, object: nil)
        
        //update offsets
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Use content size if more than min size, compensate for Y offset
        var height = max(self.contentSize.height - (contentOffsetCenterY * 2.0), minHeight)
        var updateContentOffsetY: CGFloat?
        //Max Height
        if maxHeight != nil && height > maxHeight {
            //Cap at maxHeight
            height = maxHeight!
        } else {
            //constrain Y to prevent odd skip and center content to view.
            updateContentOffsetY = contentOffsetCenterY
        }
        //update frame if needed & notify delegate
        if self.frame.size.height != height {
            self.frame.size.height = height
            dynamicDelegate?.dynamicTextViewDidResizeHeight(self, height: height)
        }
        //constrain Y must be done after setting frame
        if updateContentOffsetY != nil {
            self.contentOffset.y = updateContentOffsetY!
        }
    }
    
    func textChanged() {
        let caretRect = self.caretRectForPosition(self.selectedTextRange!.start)
        let overflow = caretRect.size.height + caretRect.origin.y - (self.contentOffset.y + self.bounds.size.height - self.contentInset.bottom - self.contentInset.top)
        if overflow > 0 {
            //Fix wrong offset when cursor jumps to next line un explisitly
            let seekEndY = self.contentSize.height - self.bounds.size.height
            if self.contentOffset.y != seekEndY {
                self.contentOffset.y = seekEndY
            }
        }
    }
}

protocol ruuiDynamicTextViewDelegate: NSObjectProtocol {
    func dynamicTextViewDidResizeHeight(textview: ruuiDynamicTextView, height: CGFloat)
}