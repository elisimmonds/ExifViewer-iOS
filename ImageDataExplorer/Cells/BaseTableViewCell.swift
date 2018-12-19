/*
 *  BaseTableViewCell.swift
 *  ImageDataExplorer
 *
 *  Created by Eli Simmonds on 12/18/18.
 */

import UIKit

open class BaseTableViewCell: UITableViewCell {

    static func reuseID() -> String {
        return String(describing: self)
    }
}
