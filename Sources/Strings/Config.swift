// 
// Config.swift
// Created on 2023/9/26
// Description 配置工程路径
// Copyright © 2023 Zepp Health. All rights reserved. 
// @author 蔡龙君(cailongjun@huami.com)  

import Foundation
import ArgumentParser
import Rainbow
import Utilities


enum APP: String, ExpressibleByArgument {
    case mifit
    case zepp
    
    var path: String? {
        UserDefaults.standard.string(forKey: rawValue)
    }
}

struct Config: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "config",
        abstract: "配置需要执行翻译Task的工程路劲，如xxx/xx/Localizable",
        version: "0.0.1"
    )
    
    @Option(name: [.customLong("app")], help: "工程")
    var app: APP
    
    @Option(name: [.customLong("path")], help: "工程路径")
    var path: String
    
    
    func validate() throws {
        guard path.lastPathComponent == "Localizable" else {
            throw ValidationError("请配置到工程目录Localizable的路径")
        }
    }
    
    mutating func run() throws {
        UserDefaults.standard.set(path, forKey: app.rawValue)
        print(">>>".green, "配置: \(app.rawValue.green) 路径: \(path.green) 成功🚀")
    }
}
