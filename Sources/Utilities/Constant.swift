// 
// Constant.swift
// Created on 2023/9/26
// Description <#⽂件描述#> 
// Copyright © 2023 Zepp Health. All rights reserved. 
// @author 蔡龙君(cailongjun@huami.com)  

import Foundation

public struct Constant {
    public static let moudle_map: [String: String] = [
        "DateFormatLocalizable" : "DateFormatLocalizable",
        "EidLocalization" : "EidLocalization",
        "HMLabLocalizable" : "HMLabLocalizable",
        "HMNFCCarKeys" : "HMNFCCarKeys",
        "HMNFCCardemu" : "HMNFCCardemu",
        "HMThirdAuthLocalizable" : "HMThirdAuthLocalizable",
        "HomeLocalizable" : "HomeLocalizable",
        "HuamiLocalizable" : "HuamiLocalizable",
        "LocStringPythonTool" : "LocStringPythonTool",
        "MIDongWatchLocalizable" : "MIDongWatchLocalizable",
        "MiDongLocalizable" : "MiDongLocalizable",
        "MineLocalizable" : "MineLocalizable",
        "PublicLocalizable" : "PublicLocalizable",
        "RunLocalizable" : "RunLocalizable",
        "SimplifiedChineseLocalizable" : "SimplifiedChineseLocalizable",
        "SmartPlayLocalizable" : "SmartPlayLocalizable",
        "StarrySkyLocalizable" : "StarrySkyLocalizable",
        "UserPermissionLocalizable" : "InfoPlist",
        "WalletLocalization" : "WalletLocalization",
        "WatchNFCLocalizable" : "WatchNFCLocalizable",
        "WeatherLocalizable" : "WeatherLocalizable",
        "ZeppPayLocalization" : "ZeppPayLocalization",
    ]
    
    public static let locale_map_all = [
        "zh-Hans": ["zh-Hans", "zh-Hans-HK"],
        "zh-HK": ["zh-Hant-HK"],
        "zh-TW": ["zh-Hant"],
        "en": ["en-GB", "en-IN", "en"],
        "de-DE": ["de-DE", "de"],
        "ar-EG": ["ar"],
        "as": ["as-IN"],
        "el": ["el-GR", "el"],
        "hi": ["hi-IN"],
        "kn": ["kn-IN"],
        "ml": ["ml-IN"],
        "ms": ["ms-MY"],
        "ro": ["ro-RO", "ro"],
        "ru": ["ru"],
        "sk": ["sk-SK"],
        "ta": ["ta-IN"],
        "te": ["te-IN"],
        "ca-ES": ["ca"],
        "es": ["es", "es-MX"],
        "pt-rBR": ["pt", "pt-BR"],
        "pt": ["pt-PT"],
        "da-DK": ["da", "da-DK"],
        "fi": ["fi"],
        "nb": ["nb"],
        "nb-NO": ["nb", "nb-NO"],
        "sv-SE": ["sv", "sv-SE"],
        "sv": ["sv", "sv-SE"]
    ]

    public static let locale_map_zh_fan_en = [
        "zh-Hans": ["zh-Hans", "zh-Hans-HK"],
        "zh-HK": ["zh-Hant-HK"],
        "zh-TW": ["zh-Hant"],
        "en": [
            "ar", "as-IN",
            "bn-IN",
            "ca", "cs",
            "da", "da-DK",
            "de",
            "el", "el-GR",
            "en", "en-GB", "en-IN", "es", "es-MX",
            "fa", "fi", "fr",
            "he", "hi-IN", "hr", "hu-HU",
            "id", "it",
            "ja",
            "kn-IN", "ko",
            "ml-IN", "ms-MY",
            "nb", "nb-NO", "nl",
            "pl", "pt", "pt-PT",
            "ro-RO", "ru",
            "sk-SK", "sr", "sv", "sv-SE",
            "ta-IN", "te-IN", "th", "tr",
            "ug", "uk",
            "vi"
        ]
    ]
}
