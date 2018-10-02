//
//  ViewController.swift
//  JSwiftON
//
//  Created by Alex on 08/16/2017.
//  Copyright (c) 2017 Alex. All rights reserved.
//

import UIKit;

import JSwiftON;

private func query(_ q: String?) -> String?
{
    return q?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
}

class GenCell: UITableViewCell
{
    @IBOutlet weak var summaryLabel: UILabel?;
    @IBOutlet weak var titleLabel: UILabel?;

    func configure(_ item: JSONItem)
    {
        typealias DocOptionKey = NSAttributedString.DocumentReadingOptionKey;
        typealias DocType = NSAttributedString.DocumentType;
        titleLabel?.text = item["show_title"].s;
        #if true
        summaryLabel?.text = item["summary"].s;
        #else
        let html: Data = ("<!doctype html><html><head></head><body>" +
                          "<span style=\"font-family: sans-serif; " +
                          "font-style: italic;\">\(item["summary"].s ?? "")" +
                          "</span></body></html>").data(using: .utf8) ?? Data();
        do
        {
            let opts: [DocOptionKey: Any] = [.documentType: DocType.html];
            let attrText = try NSAttributedString(data: html, options: opts,
                                                  documentAttributes: nil);
            summaryLabel?.attributedText = attrText;
        }
        catch { summaryLabel?.text = item["summary"].s; NSLog("Exception"); }
        #endif
        return;
    }
}

class ViewController: UIViewController
{
    fileprivate var results: [JSONItem] = [];
    @IBOutlet fileprivate weak var table: UITableView?;
    @IBOutlet fileprivate weak var wheel: UIActivityIndicatorView?;

    override func viewDidLoad()
    {
        super.viewDidLoad();
        let x = JSONItem(NSNumber(value: Double.nan));
        NSLog("\(x.e?.description ?? "no error")");
        return;
    }
}

extension ViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ bar: UISearchBar)
    {
        guard let q: String = query(bar.text),
              let url = URL(string: ("https://netflixroulette.net/api/" +
                                     "api.php?title=\(q)")) else { return; }
        bar.text = nil;
        wheel?.startAnimating();
        table?.reloadData();
        URLSession.shared.dataTask(with: url, completionHandler:
        { (data: Data?, response: URLResponse?, error: Error?) in
            guard let d: Data = data else { return; }
            let r: JSONItem = JSwiftON.parse(d);
            if let m: String = r["message"].s
            {
                let ac = UIAlertController(title: "Oops!", message: m,
                                           preferredStyle: .alert);
                ac.addAction(UIAlertAction(title: "OK", style: .cancel));
                DispatchQueue.main.async(execute:
                {
                    self.present(ac, animated: true);
                    self.wheel?.stopAnimating();
                    return;
                });
                return;
            }
            self.results.append(r);
            DispatchQueue.main.async(execute:
            {
                self.wheel?.stopAnimating();
                self.table?.reloadData();
                return;
            });
            return;
        }).resume();
        return;
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.estimatedRowHeight = 44.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        let c = tableView.dequeueReusableCell(withIdentifier: "GenCell",
                                              for: indexPath) as? GenCell;
        c?.configure(results[indexPath.row]);
        return c ?? UITableViewCell();
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    { return results.count; }
}

extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat
    { return UITableViewAutomaticDimension; }
}
