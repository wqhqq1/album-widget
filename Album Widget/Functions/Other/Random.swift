//
//  Random.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//
import Foundation

extension Range where Bound: FixedWidthInteger {
    var random: Bound { .random(in: self) }
    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random } }
}
extension ClosedRange where Bound: FixedWidthInteger  {
    var random: Bound { .random(in: self) }
    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random }
    }
}
