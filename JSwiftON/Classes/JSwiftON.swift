//
//  JSwiftON.swift
//  JSwiftON
//
//  Created by Alex on 2017/06/29.
//

import Foundation;

/* Important note: force-unwrap is being used in these setters because crashing
   is expected behaviour if someone tries to set something to nil; the correct
   procedure is to remove the key/element rather than set a nil.
 */
public struct JSONItem: Equatable //: NSObject
{
    private enum Repr: Equatable
    {
        case a([JSONItem]);
        case b(Bool);
        case d(Date);
        case e(NSError);
        case f(Double);
        case n(NSNull);
        case o([String: JSONItem]);
        case s(String);

        static func ==(lhs: Repr, rhs: Repr) -> Bool
        {
            switch (lhs, rhs)
            {
                case let (.a(l), .a(r)): return (l == r);
                case let (.b(l), .b(r)): return (l == r);
                case let (.d(l), .d(r)): return (l == r);
                case let (.e(l), .e(r)): return (l == r);
                case let (.f(l), .f(r)): return (l == r);
                case (.n, .n): return true;
                case let (.o(l), .o(r)): return (l == r);
                case let (.s(l), .s(r)): return (l == r);
                default: break;
            }
            return false;
        }
    };

    internal static let error = JSONItem(JSwiftON.error(code: .typeMismatch,
                                                        info: nil));

    public var a: [JSONItem]?
    {
        get
        {
            switch (v) { case let .a(a): return a; default: break; }
            return nil;
        }
        set { v = .a(newValue!); return; }
    };
    public var b: Bool?
    {
        get
        {
            switch (v) { case let .b(b): return b; default: break; }
            return nil;
        }
        set { v = .b(newValue!); return; }
    };
    public var d: Date?
    {
        get
        {
            switch (v) { case let .d(d): return d; default: break; }
            return nil;
        }
        set { v = .d(newValue!); return; }
    };
    public var debugDescription: String { return description; }
    public var description: String
    {
        switch (v)
        {
            case let .a(a): return "\(a)";
            case let .b(b): return "\(b)";
            case let .d(d): return "\(d)";
            case let .e(e): return "[error: \(e)]";
            case let .f(f): return "\(f)";
            case .n: return "[null]";
            case let .o(o): return "\(o)";
            case let .s(s): return s;
        }
    };
    public var e: NSError?
    {
        get
        {
            switch (v) { case let .e(e): return e; default: break; }
            return nil;
        }
        set { v = .e(newValue!); return; }
    }
    public var f: Double?
    {
        get
        {
            switch (v) { case let .f(f): return f; default: break; }
            return nil;
        }
        set { v = .f(newValue!); return; }
    };
    public var i: Int?
    {
        get
        {
            switch (v) { case let .f(i): return Int(i); default: break; }
            return nil;
        }
        set { v = .f(Double(newValue!)); return; }
    };
    public var keys: LazyMapCollection<[String: JSONItem], String>?
    {
        switch (v) { case let .o(o): return o.keys; default: break; }
        return nil;
    }
    public var n: NSNull?
    {
        get
        {
            switch (v) { case let .n(n): return n; default: break; }
            return nil;
        }
        set { v = .n(newValue!); return; }
    };
    public var o: [String: JSONItem]?
    {
        get
        {
            switch (v) { case let .o(o): return o; default: break; }
            return nil;
        }
        set { v = .o(newValue!); return; }
    };
    public var s: String?
    {
        get
        {
            switch (v) { case let .s(s): return s; default: break; }
            return nil;
        }
        set { v = .s(newValue!); return; }
    };
    public var values: LazyMapCollection<[String: JSONItem], JSONItem>?
    {
        switch (v) { case let .o(o): return o.values; default: break; }
        return nil;
    }

    private var v: Repr;

    public subscript(_ key: String) -> JSONItem
    {
        get
        {
            switch (v)
            {
                case let .o(o):
                    return o[key] ??
                           JSONItem(JSwiftON.error(code: .keyNotFound,
                                                   info: [.key: key,
                                                          .allKeys: o.keys]));
                case let .e(e):
                    return JSONItem(JSwiftON.error(code: .chained,
                                                   info: [.ancestor: e]));
                default: break;
            }
            return .error;
        }
        set
        {
            switch (v)
            { case var .o(o): o[key] = newValue; v = .o(o); default: break; }
            return;
        }
    };
    public subscript(_ index: Int) -> JSONItem
    {
        get
        {
            switch (v)
            {
                case let .a(a):
                    if ((index > -1) && (index < a.count)) { return a[index]; }
                    else if ((index < 0) && ((a.count + index) > -1))
                    { return a[a.count + index]; }
                    else
                    {
                        return JSONItem(JSwiftON.error(code: .indexOutOfBounds,
                                                       info: [.index: index,
                                                              .size: a.count]));
                    }
                case let .e(e):
                    return JSONItem(JSwiftON.error(code: .chained,
                                                   info: [.ancestor: e]));
                default: break;
            }
            return .error;
        }
        set
        {
            switch (v)
            {
                case var .a(a):
                    if ((index > -1) && (index < a.count))
                    { a[index] = newValue; v = .a(a); }
                    else if ((index < 0) && ((a.count + index) < 1))
                    { a[a.count - index] = newValue; v = .a(a); }
                default: break;
            }
            return;
        }
    };

    public init(_ input: Any)
    {
        if let k = input as? Date { self.init(k); }
        else if let k = input as? Doubleable { self.init(k); }
        else if let k = input as? NSError { self.init(k); }
        else if let k = input as? NSNull { self.init(k); }
        else if let k = input as? NSNumber { self.init(k); }
        else if let k = input as? JSONItem { self.init(k); }
        else if let k = input as? String { self.init(k); }
        else if let k = input as? [JSONItem] { self.init(k); }
        else if let k = input as? [Any] { self.init(k); }
        else if let k = input as? [String: JSONItem] { self.init(k); }
        else if let k = input as? [String: Any] { self.init(k); }
        else
        {
            self.init(JSwiftON.error(code: .notRepresentable,
                                     info: [.input: input]));
        }
        return;
    }

    public init(_ input: Date) { v = .d(input); return; }

    public init(_ input: JSONItem) { v = input.v; return; }

    public init(_ input: NSError) { v = .e(input); return; }

    public init(_ input: NSNull) { v = .n(input); return; }

    public init(_ input: NSNumber)
    {
        do
        {
            let j = try JSONSerialization.data(withJSONObject: ["k": input],
                                               options: []);
            guard let s = String(data: j, encoding: .utf8)
            else { throw JSwiftON.ErrorCodes.cannotExtract; }
            if (s.contains("true") || s.contains("false"))
            { v = .b(input.boolValue); }
            else { v = .f(input.doubleValue); }
        }
        catch
        { v = .e(JSwiftON.error(code: .cannotExtract, info: [.input: input])); }
        return;
    }

    public init(_ input: Doubleable) { v = .f(input.asDouble); return; }

    public init(_ input: String) { v = .s(input); return; }

    public init(_ input: [Any])
    { v = .a(input.map({ (item: Any) in return JSONItem(item); })); return; }

    public init(_ input: [JSONItem]) { v = .a(input); return; }

    public init(_ input: [String: Any])
    {
        var imm: [String: JSONItem] = [:];
        for (k, v): (String, Any) in input { imm[k] = JSONItem(v); }
        v = .o(imm);
        return;
    }

    public init(_ input: [String: JSONItem]) { v = .o(input); return; }

    public static func ==(lhs: JSONItem, rhs: JSONItem) -> Bool
    { return lhs.v == rhs.v; }

}

public func ==(lhs: [JSONItem], rhs: [JSONItem]) -> Bool
{
    return (lhs.count == rhs.count) && zip(lhs, rhs).reduce(true,
    { (p: Bool, i: (l: JSONItem, r: JSONItem)) -> Bool in
        return p && (i.l == i.r);
    });
}

public class JSwiftON
{
    internal typealias ErrorInfo = [ErrorKeys: Any];

    public enum ErrorCodes: Int, Error
    {
        case typeMismatch = 1;
        case cannotExtract = 2;
        case notRepresentable = 3;
        case indexOutOfBounds = 4;
        case keyNotFound = 5;
        case chained = 6;
    }

    public enum ErrorKeys: String
    {
        case allKeys = "allKeys";
        case ancestor = "ancestor";
        case key = "index";
        case index = "key";
        case input = "input";
        case size = "size";
    }

    public static let errorDomain: String = "JSwiftON";

    internal static func error(code: ErrorCodes, info: ErrorInfo?) -> NSError
    {
        return NSError(domain: errorDomain, code: code.rawValue,
                       userInfo: info);
    }

    public static func parse(_ input: Any) -> JSONItem
    {
        return parseDic(input) ?? parseString(input) ?? parseData(input) ??
               JSONItem.error;
    }

    private static func parseData(_ input: Any) -> JSONItem?
    {
        guard let data = input as? Data else { return nil; }
        var imm: Any?;
        do { imm = try JSONSerialization.jsonObject(with: data, options: []); }
        catch { return nil; }
        guard let dic = imm as? [String: Any] else { return nil; }
        return JSONItem(dic);
    }

    private static func parseDic(_ input: Any) -> JSONItem?
    {
        guard let dic = input as? [String: Any] else { return nil; }
        return JSONItem(dic);
    }

    private static func parseString(_ input: Any) -> JSONItem?
    {
        guard let d: Data = (input as? String)?.data(using: .utf8)
        else { return nil; }
        return parseData(d);
    }
}
