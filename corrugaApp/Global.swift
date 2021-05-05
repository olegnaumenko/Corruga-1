//
//  Global.swift
//  Corruga
//
//  Created by oleg.naumenko on 05.05.2021.
//  Copyright © 2021 oleg.naumenko. All rights reserved.
//

import Foundation


infix operator => //: AssignmentPrecedence
func => <T:AnyObject>(left:T, right:(T)->()) {
    right(left)
}

@discardableResult func apply<T>(_ it:T, f:(T)->()) -> T {
    f(it)
    return it
}

func DLog(_ format: String, _ args: CVarArg...) {
#if DEBUG
    NSLog(format, args)
#endif
}

func DLog(_ str:String) {
#if DEBUG
    NSLog(str)
#endif
}

func dprint(_ str:String) {
#if DEBUG
    print(str)
#endif
}
