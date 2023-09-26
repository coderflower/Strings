// 
// Update.swift
// Created on 2023/9/26
// Description 更新资源
// Copyright © 2023 Zepp Health. All rights reserved. 
// @author 蔡龙君(cailongjun@huami.com)  

import Foundation
import ArgumentParser
import Utilities
import PathKit

struct Update: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "update",
        abstract: "更新翻译资源至对应的工程",
        usage: """
            strings update --source <sourcePath> --type <zepp/mifit>
            """,
        version: "0.0.1"
    )
    
    @Option(name: [.customLong("source")], help: "需要导入的资源文件路劲")
    var sourcePath: String
    
    @Flag(help: "是否是mifit")
    var mifit = false
    
    func validate() throws {
        if sourcePath.isEmpty {
           throw ValidationError("请输入正确的资源文件路劲")
        }
    }
    
    func run() throws {
        print("mifit:\(mifit), soruce:\(sourcePath)")
        guard let projectPath = mifit ? APP.mifit.path : APP.zepp.path else {
            throw ValidationError("请先试用config 命令设置项目路劲")
        }
        print("projectPath:\(projectPath)")
        let sourceFolder = Path(sourcePath)
        
        let loader = StringsTableLoader()
        try sourceFolder.children().forEach { folder in
            let sourceTable = try loader.load(path: folder, options: [.ignoreComments, .ignoreWhitespaces])
            let targetPath = Path(projectPath.appendingPathComponent(sourceTable.module))
            let projectTable = try loader.load(path: targetPath)
            try merge(table: sourceTable, into: projectTable, targetPath: targetPath)
        }
    }
    
    func merge(table: StringsTable, into targetTable: StringsTable, targetPath: Path) throws {
        for (locale, entries) in table.entries {
            if let targets = Constant.locale_map_zh_fan_en[locale] {
                print("开始导入简繁英")
                // 暂时注释
                // try merge(entries, into: targetTable, targets: targets, targetPath: targetPath)
            }
            
            /*
            if let targets = Constant.locale_map_all[locale] {
                // 开始导入全语言
            }
            */
        }
        
        for (locale, entries) in table.dicts {
            if let targets = Constant.locale_map_zh_fan_en[locale] {
                print("开始导入简繁英")
                try mergeDict(entries, into: targetTable, targets: targets, targetPath: targetPath)
            }
            
            /*
            if let targets = Constant.locale_map_all[locale] {
                // 开始导入全语言
            }
            */
        }
    }
    
    func merge(_ entries: [StringsTable.Entry], into table: StringsTable, targets: [String], targetPath: Path) throws {
        for (locale, originEntries) in table.entries where targets.contains(locale) {
            try merge(entries, into: originEntries, targetPath: targetPath, locale: locale, name: table.name)
        }
    }
    
    func mergeDict(_ entries: [String: StringsTable.Dict], into table: StringsTable, targets: [String], targetPath: Path) throws {
        print("entries:\(entries)")
    }
    
    func merge(
        _ entries: [StringsTable.Entry],
        into originEntries: [StringsTable.Entry],
        targetPath: Path,
        locale: String,
        name: String
    ) throws {
        var origins = originEntries
        let newKeys = Set(entries.compactMap { $0.key })
        let originKeys = Set(originEntries.compactMap { $0.key })
        // 取交集
        let intersectionkeys = newKeys.intersection(originKeys)
        // 更新交集
        for key in intersectionkeys {
            if let entry = entries.first(where: { $0.key == key}),
                let index = origins.firstIndex(where: { $0.key == key }) {
                let value = origins[index].value
                origins[index].value = entry.value ?? value
            }
        }
        
        let targetFileContents = origins.map { $0.description }.joined(separator: "\n")
        let path = Path(
            targetPath.string.appendingPathComponent(locale)
                .appendingPathExtension("lproj")
                .appendingPathComponent(name)
                .appendingPathExtension("strings")
        )
        // 将更新后的内容写入原文件
        try path.write(targetFileContents, encoding: .utf8)
        print("locale\(locale): 合并并写入完成✅")
    }
    
}
