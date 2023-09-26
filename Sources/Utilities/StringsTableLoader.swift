// 
// StringsTableLoader.swift
// Created on 2023/9/26
// Description 文件读取
// Copyright © 2023 Zepp Health. All rights reserved. 
// @author 蔡龙君(cailongjun@huami.com)  

import Foundation
import PathKit
import Rainbow
import Yams

public struct StringsTableLoader {
    private enum Error: String, Swift.Error, LocalizedError {
        case invalidTable
        
        var errorDescription: String? {
            switch self {
            case .invalidTable:
                return "暂不支持的table，请先在Constant.swift文件中配置印射关系"
            }
        }
    }
    
    public struct Options: OptionSet {
        public private(set) var rawValue: UInt
        public init(rawValue: UInt) { self.rawValue = rawValue }
        
        public static let ignoreWhitespaces = Options(rawValue: 1 << 0)
        public static let ignoreComments = Options(rawValue: 1 << 1)
    }
    
    public init() {
        
    }
    
    public func load(path: Path, options: [Options] = []) throws -> StringsTable {
        let module = path.string.lastPathComponent
        guard let name = Constant.moudle_map[module] else {
            throw Error.invalidTable
        }
        return try load(path: path, module: module, name: name, options: options)
    }
    
    public func load(path: Path, module: String, name: String, options: [Options]) throws -> StringsTable {
        
        var entries: [String: [StringsTable.Entry]] = [:]
        var dictEntries: [String: [String: StringsTable.Dict]] = [:]
        
        let lprojs = try path.lprojs()
        
        try lprojs.forEach { folder in
            let locale = folder.string.lastPathComponent.deletingPathExtension
            try folder.recursiveChildren().forEach { filePath in
                if filePath.string.pathExtension == "strings" {
                    entries[locale] = try load(from: filePath, options: options)
                } else if filePath.string.pathExtension == "stringsdict" {
                    _ = try load(from: filePath)
                }
            }
        }
        return StringsTable(module: module, name: name, entries: entries, dicts: dictEntries)
    }
    
    private func load(from path: Path, options: [Options]) throws -> [StringsTable.Entry] {
        let resource = try String(contentsOfFile: path.string, encoding: .utf8)
        let entries = resource.components(separatedBy: "\n").map { StringsTable.Entry(content: $0) }
        if options.contains(.ignoreWhitespaces) && options.contains(.ignoreComments) {
            return entries.filter { !$0.content.isEmpty }.filter { !(!$0.content.isEmpty && $0.key == nil) }
        } else if options.contains(.ignoreWhitespaces) {
            // 过滤掉内容为空的
            return entries.filter { !$0.content.isEmpty }
        } else if options.contains(.ignoreComments) {
            // 过滤内容不为空，但是key是nil
            return entries.filter { !(!$0.content.isEmpty && $0.key == nil) }
        } else {
            return entries
        }
    }
    
    private func load(from path: Path) throws -> OrderedDictionary<String, Any?> {
        let data = try path.read()
        var sortedDict: OrderedDictionary<String, Any?>  = OrderedDictionary()
        if let dict = try PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil
        ) as? [String : Any] {
            dict.keys.sorted().forEach { key in
                sortedDict.insert(key: key, value: dict[key])
            }
        }
        
        print("sortedDict:\(sortedDict.keys)")
        return sortedDict
    }
}


private extension OutputStream {
    func write(string: String) {
        let encodedDataArray = [UInt8](string.utf8)
        write(encodedDataArray, maxLength: encodedDataArray.count)
    }
}

extension Path {
    func lprojs() throws -> [Path] {
        try children().filter { $0.isDirectory && $0.string.pathExtension == "lproj" }
    }
}
