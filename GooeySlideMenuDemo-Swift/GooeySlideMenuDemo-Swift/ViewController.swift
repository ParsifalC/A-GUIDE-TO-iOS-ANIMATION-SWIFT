//
//  ViewController.swift
//  GooeySlideMenuDemo-Swift
//
//  Created by Kitten Yang on 1/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

let cellIdentifier = "demoCell"
class ViewController: UIViewController {

    var menu: GooeySlideMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        let menuOptions = MenuOptions(
            titles:["首页","消息","发布","发现","个人","设置"],
            buttonHeight: 40.0, menuColor: UIColor(red: 0.0, green: 0.722, blue: 1.0, alpha: 1.0),
            blurStyle: .dark,
            buttonSpace: 30.0,
            menuBlankWidth: 50.0,
            menuClickBlock: { (index,title,titleCounts) in
                print("index:\(index) title:\(title), titleCounts:\(titleCounts)")
        })
        menu = GooeySlideMenu(options: menuOptions)
    }

    @IBAction func didButtonTapped(_ sender: AnyObject) {
        menu?.trigger()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let demoCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        demoCell.textLabel?.text = "NO.\(indexPath.row+1)"
        return demoCell
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
