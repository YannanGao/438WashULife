

import UIKit

public class MonthTitleLabel: UILabel {
    
    public var viewConfiguration: MonthTitleViewConfig = CalendarConfig.default {
        didSet {
            setConfig(viewConfiguration)
        }
    }
    
    public func setMonth(_ month: Int, year: Int) {
        var formattedText = viewConfiguration.monthTitleStyle.symbols[month - 1]
        if viewConfiguration.monthTitleIncludesYear {
            formattedText += " \(year)"
        }
        text = formattedText
    }
    
    private func setConfig(_ config: MonthTitleViewConfig) {
        font = config.monthTitleFont
        textColor = config.monthTitleTextColor
        textAlignment = config.monthTitleAlignment
        backgroundColor = config.monthTitleBackgroundColor
    }
    
}
