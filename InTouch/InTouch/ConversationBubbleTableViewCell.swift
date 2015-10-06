//
//  ConversationBubbleTableViewCell.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/4/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class ConversationBubbleTableViewCell: UITableViewCell {

    var messageLabel:UILabel!
    var bubbleView:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.bubbleView = UIView(frame: CGRectZero)
        self.bubbleView.translatesAutoresizingMaskIntoConstraints = false
        self.bubbleView.layer.cornerRadius = 4
        self.bubbleView.clipsToBounds = true
        self.contentView.addSubview(self.bubbleView)
        
        self.messageLabel = UILabel(frame: CGRectZero)
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.textColor = UIColor.whiteColor()
        self.messageLabel.numberOfLines = 0
        self.messageLabel.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightLight)
        self.bubbleView.addSubview(self.messageLabel)

        let viewsDictionary = ["bubbleView":self.bubbleView, "messageLabel":self.messageLabel]
        let metricsDictionary = ["sideMargin":7.5, "verticalMargin":6]
        
        let bubbleHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[bubbleView]-15-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(bubbleHConstraints)
        
        let bubbleVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalMargin-[bubbleView]-verticalMargin-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(bubbleVConstraints)
        
        let bubbleIHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[messageLabel]-16-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        self.bubbleView.addConstraints(bubbleIHConstraints)
        
        let bubbleIVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-18-[messageLabel]-18-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: metricsDictionary, views: viewsDictionary)
        self.bubbleView.addConstraints(bubbleIVConstraints)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
