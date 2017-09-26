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
                expect(JSONItem(18.99).f == 18.99) == true;
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
        describe("Setters")
        {
            var x = JSONItem(1);
            x.a = [JSONItem(1), JSONItem(2), JSONItem(3)];
            expect(x.a) == [JSONItem(1), JSONItem(2), JSONItem(3)];
            x.b = false;
            expect(x.b) == false;
            x.d = Date(timeIntervalSince1970: 3.0);
            expect(x.d) == Date(timeIntervalSince1970: 3.0);
            x.e = NSError(domain: "", code: 112358, userInfo: nil);
            expect(x.e) == NSError(domain: "", code: 112358, userInfo: nil);
            x.f = 18.99;
            expect(x.f) == 18.99;
            x.i = 42;
            expect(x.i) == 42;
            x.n = NSNull();
            expect(x.n != nil) == true;
            x.o = ["q": JSONItem(1), "w": JSONItem(2), "e": JSONItem(3)];
            expect(x.o) == ["q": JSONItem(1), "w": JSONItem(2),
                            "e": JSONItem(3)];
            x.s = "andiamo";
            expect(x.s) == "andiamo";
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
                expect(JSONItem([] as Any).o == nil) == true;
                expect(JSONItem([]).a != nil) == true;
                expect(JSONItem([:] as Any).a == nil) == true;
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
                expect(JSONItem([1, 2, 3]) == JSONItem([1, 2, 3])) == true;
                expect(JSONItem(["a": 1, "b": 2]) ==
                       JSONItem(["b": 2, "a": 1])) == true;
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
        describe("Key/value interface")
        {
            let dkeys: [String] = ["f", "i", "b", "o", "n", "a", "cci"];
            let dvalues: [Any] = [1, "1", 2, 3.0, 5, UInt64(8),
                                  [1, 1, 2, 3, 5, 8, 13, 21]];
            let d: [String: Any] = ["f": 1, "i": "1", "b": 2, "o": 3.0,
                                    "n": 5, "a": UInt64(8),
                                    "cci": [1, 1, 2, 3, 5, 8, 13, 21]];
            it("retrieves keys")
            {
                var keys: [String] = [];
                for k: String in JSONItem(d).keys { keys.append(k); }
                expect(keys.count) == dkeys.count;
                for v: Any in dkeys
                {
                    guard let i: Int = keys.index(where:
                    { (n: Any) -> Bool in
                        return JSONItem(n) == JSONItem(v);
                    }) else { continue; }
                    keys.remove(at: i);
                }
                expect(keys.isEmpty) == true;
                expect(JSONItem(1).keys.isEmpty) == true;
            }
            it("retrieves values")
            {
                var values: [Any] = [];
                for v: Any in JSONItem(d).values { values.append(v); }
                expect(values.count) == dvalues.count;
                for v: Any in dvalues
                {
                    guard let i: Int = values.index(where:
                    { (n: Any) -> Bool in
                        return JSONItem(n) == JSONItem(v);
                    }) else { continue; }
                    values.remove(at: i);
                }
                expect(values.isEmpty) == true;
                expect(JSONItem(1).values.isEmpty) == true;
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
            it("has functional subscript setters")
            {
                let d: [String: Any] = ["f": 1, "i": "1", "b": 2, "o": 3.0,
                                        "n": 5, "a": UInt64(8),
                                        "cci": [1, 1, 2, 3, 5, 8, 13, 21]];
                var j = JSONItem(d);
                j["f"] = JSONItem(true);
                expect(j["f"].b) == true;
                j["i"]["b"] = JSONItem(2);
                expect(j["i"].o?["b"] == nil) == true;
                j["cci"][-1] = JSONItem(34);
                expect(j["cci"][7].i) == 34;
                j["cci"][7] = JSONItem(21);
                expect(j["cci"][-1].i) == 21;
                j[0] = JSONItem("fibo");
                expect(j[0].e != nil) == true;
            }
        }
        describe("String Descriptions")
        {
            it("prints \"description\" for all kinds of backing")
            {
                expect(JSONItem(true).description) == "true";
                let d1 = Date(timeIntervalSince1970: 1.0);
                expect(JSONItem(d1).description) == d1.description;
                expect(JSONItem(18.99).description) == "18.99";
                expect(JSONItem(523).description) == "523";
                expect(JSONItem(UInt(6)).description) == "6";
                let e = NSError(domain: "", code: 666, userInfo: nil);
                expect(JSONItem(e).description.hasPrefix("[error")) == true;
                expect(JSONItem(NSNull()).description) == "[null]";
                expect(JSONItem(NSNumber(value: true)).description) == "true";
                expect(JSONItem(NSNumber(value: 34)).description) == "34";
                let nsnan = NSNumber(value: Double.nan);
                expect(JSONItem(nsnan).description.hasPrefix("[error")) == true;
                expect(JSONItem("ciao").description) == "ciao";
                let a: [JSONItem] = [JSONItem(1), JSONItem(2), JSONItem(3)];
                expect(JSONItem(a).description) == "\(["1", "2", "3"])";
                let o: [String: JSONItem] = ["q": JSONItem(1),
                                             "w": JSONItem(2)];
                expect(JSONItem(o).description) == "\(["q": "1", "w": "2"])";
            }
            it("prints \"debugDescription\" for all kinds of backing")
            {
                expect(JSONItem(true).debugDescription) == "true";
                let d1 = Date(timeIntervalSince1970: 1.0);
                expect(JSONItem(d1).debugDescription) == d1.description;
                expect(JSONItem(18.99).debugDescription) == "18.99";
                expect(JSONItem(523).debugDescription) == "523";
                expect(JSONItem(UInt(6)).debugDescription) == "6";
                let e = NSError(domain: "", code: 666, userInfo: nil);
                let pfx: String = "[error";
                expect(JSONItem(e).debugDescription.hasPrefix(pfx)) == true;
                expect(JSONItem(NSNull()).debugDescription) == "[null]";
                let nstrue = NSNumber(value: true);
                expect(JSONItem(nstrue).debugDescription) == "true";
                expect(JSONItem(NSNumber(value: 34)).debugDescription) == "34";
                let nsnan = NSNumber(value: Double.nan);
                expect(JSONItem(nsnan).debugDescription.hasPrefix(pfx)) == true;
                expect(JSONItem("ciao").debugDescription) == "ciao";
                let a: [JSONItem] = [JSONItem(1), JSONItem(2), JSONItem(3)];
                expect(JSONItem(a).debugDescription) == "\(["1", "2", "3"])";
                let o: [String: JSONItem] = ["q": JSONItem(1),
                                             "w": JSONItem(2)];
                let jo = JSONItem(o);
                expect(jo.debugDescription) == "\(["q": "1", "w": "2"])";
            }
        }
        describe("Deep Unwrapping")
        {
            it("recursively unwraps JSONItem")
            {
                let date13 = Date(timeIntervalSince1970: 13.0);
                let d: [String: Any] = ["f": true, "i": "1", "b": 2, "o": 3.0,
                                        "n": Date(timeIntervalSince1970: 5.0),
                                        "a": NSError(domain: "", code: 8,
                                                     userInfo: nil),
                                        "cci": [1, NSError(domain: "", code: 1,
                                                           userInfo: nil),
                                                NSNull(), 3.0, false, "8",
                                                date13, 21],
                                        "leo": ["nar": [NSNull(), 1, 1, 2, 3,
                                                        ["do": NSNull()],
                                                        [5, 8]]]];
                let j = JSONItem(d);
                expect(JSONItem(j.dictionary())) == j;
                expect(JSONItem(JSONItem(1).array()) == JSONItem([])) == true;
                expect(JSONItem(JSONItem(1).dictionary()) ==
                       JSONItem([:])) == true;
            }
        }
        describe("External Parser")
        {
            it("parses dictionaries")
            { expect(JSwiftON.parse(["q": 1, "w": 2, "e": 3])["w"].i) == 2; }
            it("parses strings")
            {
                let json: String = "{\"q\": 1, \"w\": 2, \"e\": 3}";
                expect(JSwiftON.parse(json)["w"].i) == 2;
            }
            it("rejects garbage")
            {
                let levi: String = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5I" +
                                   "GJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbm" +
                                   "d1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWx" +
                                   "zLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQs" +
                                   "IHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsa" +
                                   "WdodCBpbiB0aGUgY29udGludWVkIGFuZCBpbmRlZm" +
                                   "F0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGd" +
                                   "lLCBleGNlZWRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ug" +
                                   "b2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=";
                expect(JSwiftON.parse(Data(base64Encoded: levi, options: []) ??
                                      Data()).e) != nil;
                expect(JSwiftON.parse(UIView(frame: .zero)).e) != nil;
            }
        }
        return;
    }
}
