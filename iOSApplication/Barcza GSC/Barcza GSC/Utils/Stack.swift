//
//  Stack.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 08. 04..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

public class Stack<T>{
    private var stack = [T]()
    private var size: Int
    
    init(){ size = 0 }
    
    init(_ stack: Stack){
        size = 0
        let arr = stack.stackToArray()
        arr.forEach { self.push($0) }
    }
    
    public func push(_ param: T){
        stack.append(param)
        size += 1
    }
    
    public func pop() -> T?{
        if size > 0{
            size -= 1
            return stack.remove(at: size)
        }
        return nil
    }
    
    public func getSize() -> Int{ return size }
    public func stackToArray() -> [T]{ return stack }
    public func isEmpty() -> Bool{ return size == 0 }
    
    public func reveal(){
        for i in stack{
            print(i)
        }
    }
}
