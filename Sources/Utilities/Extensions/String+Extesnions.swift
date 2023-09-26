// 
// String+Ext.swift
// Created on 2023/9/26
// Description <#⽂件描述#> 
// Copyright © 2023 Zepp Health. All rights reserved. 
// @author 蔡龙君(cailongjun@huami.com)  

import Foundation

public extension String {
    var pathExtension: String {
        (self as NSString).pathExtension
    }
    
    func appendingPathComponent(_ component: String) -> String {
        (self as NSString).appendingPathComponent(component)
    }
    
    var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }
    
    var deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }
    
    func appendingPathExtension(_ str: String) -> String {
        (self as NSString).appendingPathExtension(str) ?? "\(self).\(str)"
    }
}
