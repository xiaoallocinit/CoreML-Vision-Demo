//
//  ViewController.swift
//  CoreML-Vision-Demo
//
//  Created by 小豌先生 on 2024/4/18.
//  Copyright © 2024 小豌先生. All rights reserved.
//

import UIKit
import Vision
import NaturalLanguage
import CoreML

class ViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    var dataArr = ["图片标签鉴别模型（纯手工搭建图片模型）", "图片模型比对"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "CoreML-Vision-Demo"
        self.view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "MyCell")
        cell.textLabel?.text = dataArr[indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(RecognizeImageViewController(), animated: true)
        }
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(ResnetImageViewController(), animated: true)
        }
    }
}

