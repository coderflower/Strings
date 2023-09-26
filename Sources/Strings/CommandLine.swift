// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation

@main
struct Strings: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "strings",
        abstract: "国际化小工具",
        version: "0.01",
        subcommands: [Config.self, Update.self],
        defaultSubcommand: Config.self
    )
}

