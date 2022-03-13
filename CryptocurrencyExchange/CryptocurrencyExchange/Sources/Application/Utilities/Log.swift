//
//  Log.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/05.
//

import Foundation

class Log {
    static func debug(
        _ msg: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🟢 [\(Date())] [\(fileName)] \(funcName)(\(line)) : \(msg)")
        #endif
    }
    
    static func info(
        _ msg: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ){
        #if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🔵 [\(Date())] [\(fileName)] \(funcName)(\(line)) : \(msg)")
        #endif
    }
    
    static func error(
        _ msg: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ){
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🔴 [\(Date())] [\(fileName)] \(funcName)(\(line)) : \(msg)")
    }
}
