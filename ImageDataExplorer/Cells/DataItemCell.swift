/*
 *  DataItemCell.swift
 *  ImageDataExplorer
 *
 *  Created by Eli Simmonds on 12/18/18.
 */

import UIKit
import SnapKit

public class DataItemCell: BaseTableViewCell {
    let primaryLabel = UILabel() // left justified label
    let secondaryLabel = UILabel() // right justified label
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setupSubviews() -> Void {
        self.contentView.addSubview(primaryLabel)
        self.contentView.addSubview(secondaryLabel)
        
        self.primaryLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstantValue.verticalCellOffset)
            make.bottom.equalToSuperview().inset(ConstantValue.verticalCellOffset)
            make.left.equalToSuperview().offset(ConstantValue.horizontalOffset)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
        }
        
        self.secondaryLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstantValue.verticalCellOffset)
            make.bottom.equalToSuperview().inset(ConstantValue.verticalCellOffset)
            make.right.equalToSuperview().inset(ConstantValue.horizontalOffset)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
        }
        
        primaryLabel.textColor = .black
        secondaryLabel.textColor = .black
        
        primaryLabel.sizeToFit()
        secondaryLabel.sizeToFit()
        secondaryLabel.numberOfLines = 0
        secondaryLabel.lineBreakMode = .byWordWrapping
        secondaryLabel.textAlignment = .right
    }
    
    public func set(primary: String, secondary: String?) -> Void {
        primaryLabel.text = primary
        if let secondary = secondary {
            secondaryLabel.text = secondary
        }
    }
}
