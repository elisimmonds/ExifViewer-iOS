/*
 *  NSDictionaryExtension.swift
 *  ImageDataExplorer
 *
 *  Created by Eli Simmonds on 12/18/18.
 */

import Foundation

extension NSDictionary {
//    func stringFor(key: String) -> String? {
//        guard let value = self[key] else { return nil }
//
//        if let value = value as? String {
//            return value
//        }
//        else if let value = value as? Int {
//            return String(value)
//        }
//        else if let value = value as? Double {
//            return String(value)
//        }
//        else if let value = value as? NSDictionary {
//            if value.count == 1 {
//                return value.allKeys[0] as? String
//            }
//        }
//        else if let valueArr = value as? [Any] {
//            if valueArr.count == 1 {
//                return String(describing: valueArr.first)
//            }
//        }
//        return nil
//    }
    func stringFor(key: String) -> String {
        guard let value = self[key] else { return "NONE" }
        
        if let valueArray = value as? [Any] {
            var arrString: String = ""
            for index in 0..<valueArray.count {
                if index == 0 {
                    arrString = "\(valueArray[index])"
                } else {
                    arrString += ", \(valueArray[index])"
                }
            }
            return arrString
        }
        
        return "\(value)"
    }
}
