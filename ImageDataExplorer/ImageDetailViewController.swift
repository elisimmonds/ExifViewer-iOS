/*
 *  ImageDetailViewController.swift
 *  ImageDataExplorer
 *
 *  Created by Eli Simmonds on 12/18/18.
 */

import UIKit
import SnapKit

public struct DetailData {
    var title: String?
    var exifDictionary: NSDictionary?
    var sortedKeys: [String]?
    
    init(title: String?, data: NSDictionary?) {
        self.title = title
        self.exifDictionary = data
        self.sortedKeys = (self.exifDictionary?.allKeys as? [String])?.sorted {
            if $0.contains("{") && $1.contains("{") { return $0 < $1 }
            if $0.contains("{") { return true }
            if $1.contains("{") { return false }
            
            return $0 < $1
        }
    }
}

public class ImageDetailViewController: UIViewController {
    let tableView = UITableView()
    var exifDict: NSDictionary?
    var sortedKeys: [String]?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(data: DetailData) {
        self.init()
        
        self.exifDict = data.exifDictionary
        self.sortedKeys = data.sortedKeys
        self.title = data.title
        
        print(exifDict as Any)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    private func setupSubviews() -> Void {
        self.tableView.register(DataItemCell.self, forCellReuseIdentifier: DataItemCell.reuseID())
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func pushDetailControllerWith(key: String, dict: NSDictionary) -> Void {
        let detailData = DetailData(title: key, data: dict)
        let detailController = ImageDetailViewController(data: detailData)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

extension ImageDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exifDict = exifDict else { return }
        guard let sortedKeys = sortedKeys else { return }
        
        let key = sortedKeys[indexPath.row]
        if let value = exifDict[key] as? NSDictionary {
            pushDetailControllerWith(key: key, dict: value)
        } else if let value = exifDict[key] as? [NSDictionary] {
            if let firstDict = value.first {
                pushDetailControllerWith(key: key, dict: firstDict)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let exifDict = exifDict {
            return exifDict.count
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DataItemCell.reuseID()) as? DataItemCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Cannot dequeue cell"
            return cell
        }
        guard let exifDict = exifDict else { return UITableViewCell() }
        guard let sortedKeys = sortedKeys else { return UITableViewCell() }
        
        // get key
        let key = sortedKeys[indexPath.row]
        // check if value is a dictionary or string
        if let _ = exifDict[key] as? NSDictionary {
            cell.set(primary: key, secondary: nil)
            cell.accessoryType = .disclosureIndicator
        } else if let dictArray = exifDict[key] as? [NSDictionary] {
            if dictArray.count == 1 {
                cell.set(primary: key, secondary: nil)
                cell.accessoryType = .disclosureIndicator
            }
        } else {
            let valueString = exifDict.stringFor(key: key)
            cell.set(primary: key, secondary: valueString)
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
