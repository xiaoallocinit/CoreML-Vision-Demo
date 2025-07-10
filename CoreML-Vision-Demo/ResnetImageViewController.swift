//
//  ResnetImageViewController.swift
//  CoreML-Vision-Demo
//
//  Created by 小豌先生 on 2024/4/18.
//  Copyright © 2024 小豌先生. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision
import SwiftUI
import Combine

class ResnetImageViewController: UIViewController {
    // 声明一个存储订阅者的集合
    var cancellables = Set<AnyCancellable>()
    let selectionModel = SelectionModel()
    let image = UIImage(named: "02")!
    var resultMSG = ""
    
    lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.image = image
        return v
    }()
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 15)
        l.text = ""
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "4个图片模型比对"
        view.backgroundColor = .white
        addOptionView()
        let scale = image.size.width / image.size.height
        
        imageView.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.width / scale / 2)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(tapGesture)
        
        label.frame = CGRect(x: 0, y: 300 + imageView.frame.height + 50, width: view.frame.width, height: 100)
        view.addSubview(label)
    }
    
    func addOptionView() {
        // 创建SwiftUI视图
        let pickerView = UIHostingController(rootView: PickerView.init(selectionModel: self.selectionModel))

        // 设置视图控制器的属性
        pickerView.view.frame = CGRect(x: view.frame.width/2 - 150, y: 100, width: 300, height: 200)
        pickerView.view.backgroundColor = .white

        // 将SwiftUI视图添加到当前视图控制器的视图中
        self.addChild(pickerView)
        self.view.addSubview(pickerView.view)
        pickerView.didMove(toParent: self)
        
        // 监听selectionModel的变化
        selectionModel.$selection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selection in
                self?.handleImageSelectionChange()
            }
            .store(in: &cancellables)
        
        
    }
    
    @objc func chooseImage() {
        let pickerVc = UIImagePickerController()
        pickerVc.sourceType = .photoLibrary
        pickerVc.allowsEditing = false
        pickerVc.delegate = self
        pickerVc.modalPresentationStyle = .fullScreen
        pickerVc.modalTransitionStyle = .coverVertical
        self.present(pickerVc, animated: true, completion: nil)
    }
    
    
    func handleImageSelectionChange() {
        guard let ciImage = CIImage(image: self.imageView.image!)
            else { fatalError("can't create CIImage from UIImage") }
        self.textRecoginzeImage(ciImage: ciImage) { msg in
            self.label.text = msg
        }
    }
    
    func textRecoginzeImage(ciImage: CIImage, completed: @escaping ((String) -> Void)) {
        // 加载 Core ML 模型
        let configuration = MLModelConfiguration()
        let index = self.selectionModel.selection
        var modelML = try? MobileNetV2.init(configuration: configuration).model
        var name = "MobileNetV2模型"
        switch index {
        case 0:
            modelML = try? MobileNetV2.init(configuration: configuration).model
        case 1:
            modelML = try? Resnet50.init(configuration: configuration).model
            name = "Resnet50模型"
        case 2:
            modelML = try? SqueezeNet.init(configuration: configuration).model
            name = "SqueezeNet模型"
        case 3:
            modelML = try? RecognizeImageClass.init(configuration: configuration).model
            name = "我的自定义模型"
        default:
            break
        }
        guard let modelML = modelML, let model = try? VNCoreMLModel(for: modelML) else {
            fatalError("无法加载 Core ML 模型")
        }

        // 创建 Vision 请求处理程序
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                fatalError("无法获取预测结果")
            }

            // 输出预测结果
            let msg = "\(name)预测结果：\(topResult.identifier), \n置信度：\(topResult.confidence)"
            print("\(msg)")
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

extension ResnetImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            else { fatalError("no image from image picker") }
        guard let ciImage = CIImage(image: uiImage)
            else { fatalError("can't create CIImage from UIImage") }
        imageView.image = uiImage
        self.textRecoginzeImage(ciImage: ciImage) { msg in
            self.label.text = msg
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
