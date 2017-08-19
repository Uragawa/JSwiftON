//
//  Doubleable.swift
//  JSwiftON
//
//  Created by Alex on 2017/08/18.
//
//

import Foundation;

public protocol Doubleable { var asDouble: Double { get }; }

extension Double: Doubleable
{ public var asDouble: Double { return self; }; }

extension Float: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension Int: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension Int8: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension Int16: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension Int32: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension Int64: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension UInt: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension UInt8: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension UInt16: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension UInt32: Doubleable
{ public var asDouble: Double { return Double(self); }; }

extension UInt64: Doubleable
{ public var asDouble: Double { return Double(self); }; }
