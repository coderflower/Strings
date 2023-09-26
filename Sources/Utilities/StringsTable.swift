// 
// File.swift
// Created on 2023/9/26
// Description <#⽂件描述#> 
// Copyright © 2023 Zepp Health. All rights reserved. 
// @author 蔡龙君(cailongjun@huami.com)  

import Foundation

public struct StringsTable: Codable {    
    public let module: String
    public let name: String
    public private(set) var entries: [String: [Entry]] = [:]
    public private(set) var dicts: [String: [String: Dict]] = [:]
}


extension StringsTable {
    
    public struct Entry: Codable, CustomStringConvertible {
        
        public var description: String {
            if let key, let value {
                return "\"\(key)\" = \"\(value)\";"
            }
            return content
        }
        
        public var key: String?
        public var value: String?
        public private(set) var content: String
        
        public init(content: String) {
            // 使用正则表达式匹配键值对（支持等号前后有空格）
            let pattern = "\"([^\"]+)\"\\s*=\\s*\"([^\"]+)\";"
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
                for match in matches {
                    if let keyRange = Range(match.range(at: 1), in: content),
                       let valueRange = Range(match.range(at: 2), in: content) {
                        let key = String(content[keyRange])
                        let value = String(content[valueRange])
                        self.key = key
                        self.value = value
                        let content = "\"\(key)\" = \"\(value)\";"
                        self.content = content
                        return
                    }
                }
            }
            self.content = content
        }
        
        public init(key: String, value: String) {
            self.key = key
            self.value = value
            self.content = "\"\(key)\" = \"\(value)\";"
        }
    }
}

extension StringsTable {
    public struct Dict: Codable, Hashable {
        private struct _DictKey: CodingKey, Equatable {
            var stringValue: String
            var intValue: Int?
            
            init?(stringValue: String) {
                self.stringValue = stringValue
                self.intValue = nil
            }
            
            init?(intValue: Int) {
                self.stringValue = "\(intValue)"
                self.intValue = intValue
            }
            
            static let localizedFormatKey = _DictKey(stringValue: "NSStringLocalizedFormatKey")!
            static func pluralization(_ key: String) -> _DictKey {
                return _DictKey(stringValue: key)!
            }
        }
        
        struct PluralizationRule: Codable, Hashable {
            private enum CodingKeys: String, CodingKey {
                case zero, one, two, few, many, other
                case specType = "NSStringFormatSpecTypeKey"
                case valueType = "NSStringFormatValueTypeKey"
            }
            private static let pluralRuleType = "NSStringPluralRuleType"
            // CodingKeys should have a key/value pair of NSStringFormatSpecTypeKey/NSStringPluralRuleType
            var zero: String?
            var one: String?
            var two: String?
            var few: String?
            var many: String?
            var other: String?
            
            let valueType: String
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                //precondition(try container.decode(String.self, forKey: .formatSpecType) == type(of: self).pluralRuleType)
                self.zero = try container.decodeIfPresent(String.self, forKey: .zero)
                self.one = try container.decodeIfPresent(String.self, forKey: .one)
                self.two = try container.decodeIfPresent(String.self, forKey: .two)
                self.few = try container.decodeIfPresent(String.self, forKey: .few)
                self.many = try container.decodeIfPresent(String.self, forKey: .many)
                self.other = try container.decode(String.self, forKey: .other)
                self.valueType = try container.decode(String.self, forKey: .valueType)
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encodeIfPresent(zero, forKey: .zero)
                try container.encodeIfPresent(one, forKey: .one)
                try container.encodeIfPresent(two, forKey: .two)
                try container.encodeIfPresent(few, forKey: .few)
                try container.encodeIfPresent(many, forKey: .many)
                try container.encode(other, forKey: .other)
                try container.encode(type(of: self).pluralRuleType, forKey: .specType)
                try container.encode(valueType, forKey: .valueType)
            }
        }
        
        let formatKey: String
        let pluralizations: [String: PluralizationRule]
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: _DictKey.self)
            self.formatKey = try container.decode(String.self, forKey: _DictKey.localizedFormatKey)
            let allKeys = container.allKeys.filter {
                return $0 != _DictKey.localizedFormatKey
            }
            let elements: [(String, PluralizationRule)] = try allKeys.map { (key) in
                let pluralization = try container.decode(PluralizationRule.self, forKey: key)
                return (key.stringValue, pluralization)
            }
            self.pluralizations = Dictionary(elements, uniquingKeysWith: { (lhs, _) in return lhs })
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: _DictKey.self)
            try container.encode(formatKey, forKey: _DictKey.localizedFormatKey)
            try pluralizations.forEach {
                try container.encode($0.value, forKey: _DictKey(stringValue: $0.key)!)
            }
        }
    }
}
