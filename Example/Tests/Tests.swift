// https://github.com/Quick/Quick

import Quick;
import Nimble;

import JSwiftON;

class JSwiftONSpec: QuickSpec
{
    override func spec()
    {
        describe("Basic constructors")
        {
            it("represents Bool")
            { expect(JSONItem(true).b) == true; }
            it("represents Date")
            {
                expect(JSONItem(Date(timeIntervalSince1970: 1.0)).d) ==
                    Date(timeIntervalSince1970: 1.0);
            }
            it("represents Doubleable")
            {
                expect(JSONItem(1.0).f == 1.0) == true;
                expect(JSONItem(523).i == 523) == true;
                expect(JSONItem(UInt(6)).i == 6) == true;
            }
            it("represents NSError")
            {
                expect(JSONItem(NSError(domain: "", code: 666,
                                        userInfo: nil)).e?.code) == 666;
            }
            it("represents NSNull")
            { expect(JSONItem(NSNull()).n != nil) == true; }
            it("represents NSNumber")
            {
                expect(JSONItem(NSNumber(value: true)).b) == true;
                expect(JSONItem(NSNumber(value: 34)).i) == 34;
                expect(JSONItem(NSNumber(value: Double.nan)).e != nil) == true;
            }
            it("represents String")
            { expect(JSONItem("ciao").s) == "ciao"; }
            it("rejects NaN")
            {
                expect(JSONItem(Double.nan).e != nil) == true;
                expect(JSONItem(Double.signalingNaN).e != nil) == true;
            }
            it("rejects infinity")
            { expect(JSONItem(Double.infinity.negated()).e != nil) == true; }
        }
        describe("Copy constructor")
        {
            it("copies itself")
            { expect(JSONItem(JSONItem("arrivederci")).s) == "arrivederci"; }
        }
        describe("Final optionals")
        {
            it("only returns a value compatible with the inner type")
            {
                expect(JSONItem(true).d == nil) == true;
                expect(JSONItem(true).b != nil) == true;
                expect(JSONItem(Date()).e == nil) == true;
                expect(JSONItem(Date()).d != nil) == true;
                expect(JSONItem(NSError(domain: "", code: 1,
                                        userInfo: nil)).n == nil) == true;
                expect(JSONItem(NSError(domain: "", code: 1,
                                        userInfo: nil)).e != nil) == true;
                expect(JSONItem(NSNull()).f == nil) == true;
                expect(JSONItem(NSNull()).n != nil) == true;
                expect(JSONItem(1).s == nil) == true;
                expect(JSONItem(1).f != nil) == true;
                expect(JSONItem(false).i == nil) == true;
                expect(JSONItem(2.0).i != nil) == true;
                expect(JSONItem("ciao").b == nil) == true;
                expect(JSONItem("ciao").s != nil) == true;
                expect(JSONItem([]).o == nil) == true;
                expect(JSONItem([]).a != nil) == true;
                expect(JSONItem([:]).a == nil) == true;
                expect(JSONItem([:]).o != nil) == true;
            }
        }
        describe("Equatability")
        {
            it("implements Equatable")
            {
                expect(JSONItem(false) == JSONItem(false)) == true;
                expect(JSONItem(5) == JSONItem(5.0)) == true;
                expect(JSONItem(Date(timeIntervalSince1970: 0.1)) ==
                       JSONItem(Date(timeIntervalSince1970: 0.1))) == true;
                expect(JSONItem(NSError(domain: "", code: 1, userInfo: nil)) ==
                       JSONItem(NSError(domain: "", code: 1,
                                        userInfo: nil))) == true;
                expect(JSONItem("buongiorno") != JSONItem("buonasera")) == true;
                expect(JSONItem(true) != JSONItem("true")) == true;
                expect(JSONItem(NSNull()) == JSONItem(NSNull())) == true;
            }
            it("implements == for arrays")
            {
                let a: [Any] = [1, "1", 2, 3.0, 5, Int8(8), 13, Float(21)];
                let j: [JSONItem] = a.map(
                { (e: Any) -> JSONItem in return JSONItem(e); });
                let k: [JSONItem] = j.reversed();
                let l: [JSONItem] = Array(j.dropFirst(1));
                let m: [JSONItem] = k.reversed();
                expect(j != k) == true;
                expect(j != l) == true;
                expect(j == m) == true;
            }
        }
        describe("Array constructors")
        {
            it("represents [Any]")
            {
                let a: [Any] = [1, "1", 2, 3.0, 5, Int16(8), 13, Float(21),
                                Date(timeIntervalSince1970: 34.0),
                                NSError(domain: "", code: 55, userInfo: nil),
                                NSNull(), JSONItem("89")];
                expect(JSONItem(a).a) == a.map(
                { (e: Any) -> JSONItem in
                    return JSONItem(e);
                });
            }
            it("represents [JSONItem]")
            {
                let a: [Any] = [1, "1", 2, 3.0, 5, Int32(8), 13, Float(21)];
                let j: [JSONItem] = a.map(
                { (e: Any) -> JSONItem in return JSONItem(e); });
                expect(JSONItem(j).a) == j;
            }
        }
        describe("Dictionary constructors")
        {
            it("represents [String: Any]")
            {
                let d: [String: Any] = ["f": 1, "i": "1", "b": 2, "o": 3.0,
                                        "n": 5, "a": Int64(8), "c": 13,
                                        "ci": Float(21)];
                expect(JSONItem(d).o) == d.reduce([:],
                { (old: [String: JSONItem],
                   p:(k: String, v: Any)) -> [String: JSONItem] in
                    var dic: [String: JSONItem] = old;
                    dic[p.k] = JSONItem(p.v);
                    return dic;
                });
            }
            it("represents [String: JSONItem]")
            {
                let d: [String: Any] = ["f": 1, "i": "1", "b": 2, "o": 3.0,
                                        "n": 5, "a": UInt8(8), "c": 13,
                                        "ci": Float(21)];
                let j: [String: JSONItem] = d.reduce([:],
                { (old: [String: JSONItem],
                   p:(k: String, v: Any)) -> [String: JSONItem] in
                    var dic: [String: JSONItem] = old;
                    dic[p.k] = JSONItem(p.v);
                    return dic;
                });
                expect(JSONItem(j).o) == j;
            }
        }
        describe("Subscripts")
        {
            it("chains subscripts")
            {
                let d: [String: Any] = ["f": 1, "i": "1", "b": 2, "o": 3.0,
                                        "n": 5, "a": UInt16(8),
                                        "cci": [1, 1, 2, 3, 5, 8, 13, 21]];
                expect(JSONItem(d)["cci"][4].i) == 5;
            }
            it("supports Python-like negative array subscripts")
            {
                let a: [Any] = [1, "1", 2, 3.0, 5, UInt32(8), 13, Float(21)];
                expect(JSONItem(a)[-1].f) == 21.0;
                expect(JSONItem(a)[-9].e != nil) == true;
            }
            it("tracks subscript errors")
            {
                typealias Codes = JSwiftON.ErrorCodes;
                typealias Keys = JSwiftON.ErrorKeys;
                let d: [String: Any] = ["f": 1, "i": "1", "b": 2, "o": 3.0,
                                        "n": 5, "a": UInt64(8),
                                        "cci": [1, 1, 2, 3, 5, 8, 13, 21]];
                let e: NSError? = JSONItem(d)["cci"][10][3]["leo"].e;
                expect(e?.userInfo[Keys.size] as?
                       Int) == (d["cci"] as? [Int])?.count;
                expect(e?.userInfo[Keys.nesting] as? Int) == 2;
                expect(JSONItem(4)["e"][2].e?.code) ==
                    Codes.typeMismatch.rawValue;
                expect(JSONItem(4)[1]["x"].e?.code) ==
                    Codes.typeMismatch.rawValue;
                expect(JSONItem([:])["e"][2].e?.code) ==
                    Codes.keyNotFound.rawValue;
                expect(JSONItem([])[1]["x"].e?.code) ==
                    Codes.indexOutOfBounds.rawValue;
            }
        }
        return;
    }
}
