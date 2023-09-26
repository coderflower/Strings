// 
// URL+Extensions.swift
// Created on 2023/9/26
// Description <#⽂件描述#> 
// Copyright © 2023 Zepp Health. All rights reserved. 
// @author 蔡龙君(cailongjun@huami.com)  

import Foundation

extension Foundation.URL {
    public var tableName: String? {
        var url = self
        if ["strings", "stringsdict"].contains(url.pathExtension) {
            url.deletePathExtension()
            return url.lastPathComponent
        }
        return nil
    }
    
    public var locale: String? {
        var url = self
        if ["strings", "stringsdict"].contains(url.pathExtension) {
            url.deleteLastPathComponent()
        }
        if url.pathExtension == "lproj" {
            url.deletePathExtension()
            return url.lastPathComponent
        }
        return nil
    }
    
    public var resourceDirectory: Foundation.URL {
        var dir = self
        if dir.pathExtension == "strings" || dir.pathExtension == "stringsdict" {
            dir.deleteLastPathComponent()
        }
        if dir.pathExtension == "lproj" {
            dir.deleteLastPathComponent()
        }
        return dir
    }
    
    var lprojURLs: [Foundation.URL] {
        let directories = try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: []).filter { (url) -> Bool in
            return url.pathExtension == "lproj"
        }
        return directories ?? []
    }
    
    func stringsFiles(tableName: String) -> [Foundation.URL] {
        return files(tableName: tableName, ext: "strings")
    }
    
    func stringsDictFiles(tableName: String) -> [Foundation.URL] {
        return files(tableName: tableName, ext: "stringsdict")
    }
    
    private func files(tableName: String, ext: String) -> [Foundation.URL] {
        return lprojURLs.compactMap { (lprojURL) in
            let url = lprojURL.appendingPathComponent(tableName).appendingPathExtension(ext)
            guard let reachable = try? url.checkResourceIsReachable(), reachable == true else { return nil }
            return url
        }
    }
    
    func stringsURL(tableName: String, locale: Locale) throws -> Foundation.URL {
        return try fileURL(tableName: tableName, locale: locale, ext: "strings", create: true)
    }
    
    func stringsDictURL(tableName: String, locale: Locale) throws -> Foundation.URL {
        return try fileURL(tableName: tableName, locale: locale, ext: "stringsdict", create: true)
    }
    
    private func fileURL(tableName: String, locale: Locale, ext: String, create: Bool) throws -> Foundation.URL {
        let lprojURL = appendingPathComponent("\(locale.identifier).lproj", isDirectory: true)
        if create {
            try FileManager.default.createDirectory(at: lprojURL, withIntermediateDirectories: true, attributes: nil)
        }
        let fileURL = lprojURL.appendingPathComponent(tableName).appendingPathExtension(ext)
        return fileURL
    }
}
