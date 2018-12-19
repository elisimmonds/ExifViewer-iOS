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
    
    init(title: String?, data: NSDictionary?) {
        self.title = title
        self.exifDictionary = data
    }
}

public class ImageDetailViewController: UIViewController {
    let tableView = UITableView()
    var exifDict: NSDictionary?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(data: DetailData) {
        self.init()
        
        self.exifDict = data.exifDictionary
        self.title = data.title
        
        print(exifDict)
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
}

extension ImageDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exifDict = exifDict else { return }
        
        let key = exifDict.allKeys[indexPath.row] as? String
        if let value = exifDict[key] as? NSDictionary {
            let detailData = DetailData(title: key, data: value)
            let detailController = ImageDetailViewController(data: detailData)
            self.navigationController?.pushViewController(detailController, animated: true)
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
        
        if let key = exifDict.allKeys[indexPath.row] as? String {
            if let _ = exifDict[key] as? NSDictionary {
                cell.set(primary: key, secondary: nil)
                cell.accessoryType = .disclosureIndicator
            } else {
                let valueString = exifDict.stringFor(key: key)
                cell.set(primary: key, secondary: valueString)
                cell.isUserInteractionEnabled = false
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
