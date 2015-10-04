//
//  TaskCardTableViewCell.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class TaskCardTableViewCell: UITableViewCell {

    var cardView:UIView!
    var mainConstraintLabel:UILabel!
    var taskNameLabel:UILabel!
    var separator:UIView!
    var rangeAndTriggerLabel:UILabel!
    var keyColor:UIColor = UIColor(red:0, green:0.6, blue:0.89, alpha:1)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.cardView = UIView(frame: CGRectZero)
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.cornerRadius = 4
        self.cardView.clipsToBounds = true
        self.cardView.layer.borderColor = self.keyColor.CGColor
        self.cardView.backgroundColor = self.keyColor
        self.contentView.addSubview(self.cardView)
        
        self.mainConstraintLabel = UILabel(frame: CGRectZero)
        self.mainConstraintLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainConstraintLabel.numberOfLines = 1
        self.mainConstraintLabel.text = "MAIN CONSTRAINT"
        self.mainConstraintLabel.font = UIFont.systemFontOfSize(24, weight: UIFontWeightBold)
        self.mainConstraintLabel.textColor = UIColor.whiteColor()
        self.cardView.addSubview(self.mainConstraintLabel)

        self.taskNameLabel = UILabel(frame: CGRectZero)
        self.taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.taskNameLabel.numberOfLines = 1
        self.taskNameLabel.text = "TASK NAME"
        self.taskNameLabel.font = UIFont.systemFontOfSize(24, weight: UIFontWeightLight)
        self.taskNameLabel.textColor = UIColor.whiteColor()
        self.cardView.addSubview(self.taskNameLabel)
        
        self.separator = UIView(frame: CGRectZero)
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.backgroundColor = UIColor.whiteColor()
        self.cardView.addSubview(self.separator)
        
        self.rangeAndTriggerLabel = UILabel(frame: CGRectZero)
        self.rangeAndTriggerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.rangeAndTriggerLabel.numberOfLines = 0
        self.rangeAndTriggerLabel.text = "RANGE AND TRIGGER LABEL"
        self.rangeAndTriggerLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        self.rangeAndTriggerLabel.textColor = UIColor.whiteColor()
        self.cardView.addSubview(self.rangeAndTriggerLabel)
        
        let viewsDictionary = ["cardView":self.cardView, "mainConstraintLabel":self.mainConstraintLabel, "taskNameLabel":self.taskNameLabel, "separator":self.separator, "rangeAndTriggerLabel":self.rangeAndTriggerLabel]
        let metricsDictionary = ["sideMargin": 7.5, "verticalMargin":5, "cardPaddingLeftShallow":18, "cardPaddingLeftDeep":20, "cardPaddingRight":10, "cardPaddingTop":19, "cardPaddingBottom":18]
        
        let cardViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sideMargin-[cardView]-sideMargin-|", options: [NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: metricsDictionary, views: viewsDictionary)
        let cardViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalMargin-[cardView]-verticalMargin-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(cardViewHorizontalConstraints)
        self.contentView.addConstraints(cardViewVerticalConstraints)
        
        let titleLabelsHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-cardPaddingLeftShallow-[mainConstraintLabel]-7-[taskNameLabel]->=cardPaddingRight-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let separatorHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-cardPaddingLeftShallow-[separator]-cardPaddingRight-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        
        let titleLabelsVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-cardPaddingTop-[mainConstraintLabel]-5-[separator(1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsDictionary, views: viewsDictionary)
        
        let indentedViewsVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[separator(1)]-10-[rangeAndTriggerLabel]-cardPaddingBottom-|", options: [NSLayoutFormatOptions.AlignAllLeft,NSLayoutFormatOptions.AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        
        self.cardView.addConstraints(titleLabelsHorizontalConstraints)
        self.cardView.addConstraints(titleLabelsVerticalConstraints)
        self.cardView.addConstraints(separatorHorizontalConstraints)
        self.cardView.addConstraints(indentedViewsVerticalConstraints)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
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
