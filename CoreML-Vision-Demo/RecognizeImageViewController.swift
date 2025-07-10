//
//  RecognizeImageViewController.swift
//  CoreML-Vision-Demo
//
//  Created by 小豌先生 on 2024/4/18.
//  Copyright © 2024 小豌先生. All rights reserved.
//

import UIKit
import Vision
import NaturalLanguage
import CoreML

class RecognizeImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片标签鉴别模型（纯手工搭建图片模型）"
        self.view.backgroundColor = .white
        let images = ["01", "02", "03"]
        for i in 0..<images.count {
            let v = UIImageView()
            let path = images[i]
            v.image = UIImage(named: path)
            v.contentMode = .scaleAspectFit
            v.frame = CGRect.init(x: 100, y: 120 + i*200, width: 120, height: 150)
            self.textRecoginzeImage(path: path) { result in
                let label = UILabel()
                label.textColor = .black
                label.text = result
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.textAlignment = .center
                label.frame = CGRect.init(x: 0, y: 280 + i*210, width: 300, height: 20)
                self.view.addSubview(label)
            }
            self.view.addSubview(v)
        }
    }

    func textRecoginzeImage(path: String, completed: @escaping ((String) -> Void)) {
        // 加载 Core ML 模型
        let configuration = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: RecognizeImageClass.init(configuration: configuration).model) else {
            fatalError("无法加载 Core ML 模型")
        }
        // 创建 UIImage 对象并加载图像
        guard let image = UIImage(named: path) else {
            fatalError("无法加载图像")
        }

        // 将图像转换为 Core ML 模型期望的输入格式
        guard let ciImage = CIImage(image: image) else {
            fatalError("无法转换图像为 CIImage")
        }

        // 创建 Vision 请求处理程序
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                fatalError("无法获取预测结果")
            }

            // 输出预测结果
            let msg = "预测结果：\(topResult.identifier), 置信度：\(topResult.confidence)"
            print("预测结果：\(topResult.identifier), 置信度：\(topResult.confidence)")
            completed(msg)
        }

        // 创建 Vision 请求处理管道
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            // 执行 Vision 请求处理
            try handler.perform([request])
        } catch {
            fatalError("无法执行 Vision 请求处理")
        }
    }


}
