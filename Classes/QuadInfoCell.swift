//
//  QuadInfoCell.swift
//  kraftstoff
//
//  Created by Ingmar Stein on 03.05.15.
//
// TableView cells with four labels for information.

import UIKit

final class QuadInfoCell: UITableViewCell {

	private(set) var topLeftLabel: UILabel
	private(set) var botLeftLabel: UILabel
	private(set) var topRightLabel: UILabel
	private(set) var botRightLabel: UILabel

	var topLeftAccessibilityLabel: String?
	var botLeftAccessibilityLabel: String?
	var topRightAccessibilityLabel: String?
	var botRightAccessibilityLabel: String?

	private var cellState: UITableViewCellStateMask
	private var large: Bool

	init(style: UITableViewCellStyle, reuseIdentifier: String?, enlargeTopRightLabel: Bool) {
		cellState     = []
		large         = enlargeTopRightLabel
		botLeftLabel  = UILabel(frame: .zero)
		topLeftLabel  = UILabel(frame: .zero)
		topRightLabel = UILabel(frame: .zero)
		botRightLabel = UILabel(frame: .zero)

		super.init(style: style, reuseIdentifier: reuseIdentifier)

        topLeftLabel.backgroundColor            = .clear()
        topLeftLabel.textColor                  = .black()
        topLeftLabel.adjustsFontSizeToFitWidth  = true
		topLeftLabel.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(topLeftLabel)

        botLeftLabel.backgroundColor            = .clear()
        botLeftLabel.textColor                  = UIColor(white:0.5, alpha:1.0)
        botLeftLabel.adjustsFontSizeToFitWidth  = true
		botLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(botLeftLabel)

        topRightLabel.backgroundColor           = .clear()
        topRightLabel.textColor                 = .black()
        topRightLabel.adjustsFontSizeToFitWidth = true
        topRightLabel.textAlignment             = .right
		topRightLabel.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(topRightLabel)

        botRightLabel.backgroundColor           = .clear()
        botRightLabel.textColor                 = UIColor(white:0.5, alpha:1.0)
        botRightLabel.adjustsFontSizeToFitWidth = true
        botRightLabel.textAlignment             = .right
		botRightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(botRightLabel)

		// setup constraints
		let views = ["topLeftLabel" : topLeftLabel, "botLeftLabel" : botLeftLabel, "topRightLabel" : topRightLabel, "botRightLabel" : botRightLabel]
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[topLeftLabel]-(2)-[botLeftLabel]-(20)-|", options: [], metrics: nil, views: views))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[topLeftLabel]-(2)-[topRightLabel]-(15)-|", options: [], metrics: nil, views: views))
		contentView.addConstraint(NSLayoutConstraint(item: topLeftLabel, attribute: .lastBaseline, relatedBy: .equal, toItem: topRightLabel, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0))
		contentView.addConstraint(NSLayoutConstraint(item: botLeftLabel, attribute: .lastBaseline, relatedBy: .equal, toItem: botRightLabel, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0))
		contentView.addConstraint(NSLayoutConstraint(item: topLeftLabel, attribute: .left, relatedBy: .equal, toItem: botLeftLabel, attribute: .left, multiplier: 1.0, constant: 0.0))
		contentView.addConstraint(NSLayoutConstraint(item: topRightLabel, attribute: .right, relatedBy: .equal, toItem: botRightLabel, attribute: .right, multiplier: 1.0, constant: 0.0))

		setupFonts()

		NotificationCenter.default().addObserver(self, selector: #selector(QuadInfoCell.contentSizeCategoryDidChange(notification:)), name: Notification.Name.UIContentSizeCategoryDidChange, object: nil)

		self.accessoryType = .disclosureIndicator
    }

	deinit {
		NotificationCenter.default().removeObserver(self)
	}

	func contentSizeCategoryDidChange(notification: NSNotification!) {
		setupFonts()
	}

	private func setupFonts() {
		topLeftLabel.font                = UIFont.lightApplicationFontForStyle(UIFontTextStyleSubheadline)
		topLeftLabel.minimumScaleFactor  = 12.0/topLeftLabel.font.pointSize
		botLeftLabel.font                = UIFont.lightApplicationFontForStyle(UIFontTextStyleBody)
		botLeftLabel.minimumScaleFactor  = 12.0/botLeftLabel.font.pointSize
		topRightLabel.font               = UIFont.lightApplicationFontForStyle(large ? UIFontTextStyleHeadline : UIFontTextStyleSubheadline)
		topRightLabel.minimumScaleFactor = 12.0/topRightLabel.font.pointSize
		botRightLabel.font               = UIFont.lightApplicationFontForStyle(UIFontTextStyleBody)
		botRightLabel.minimumScaleFactor = 12.0/botRightLabel.font.pointSize
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override var accessibilityLabel: String? {
		get {
			var label = "\((topLeftAccessibilityLabel ?? topLeftLabel.text) ?? ""), \((botLeftAccessibilityLabel ?? botLeftLabel.text) ?? ""))"
			if cellState == [] {
				if let accessibilityLabel = topRightAccessibilityLabel {
					label = "\(label), \(accessibilityLabel)"
				}

				if let accessibilityLabel = botRightAccessibilityLabel {
					label = "\(label) \(accessibilityLabel)"
				}
			}

			return label
		}
		set {
		}
	}

	// Remember target state for transition
	override func willTransition(to state: UITableViewCellStateMask) {
		super.willTransition(to: state)
		cellState = state
	}

	// Reset to default state before reuse of cell
	override func prepareForReuse() {
		super.prepareForReuse()
		cellState = []
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		// hide right labels in editing modes
		UIView.animate(withDuration: 0.5) {
			let newAlpha: CGFloat = self.cellState.contains(.showingEditControlMask) ? 0.0 : 1.0
			self.topRightLabel.alpha = newAlpha
			self.botRightLabel.alpha = newAlpha
		}
	}

}
