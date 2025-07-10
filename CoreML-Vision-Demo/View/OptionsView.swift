//
//  OptionsView.swift
//  CoreML-Vision-Demo
//
//  Created by 小豌先生 on 2024/4/20.
//  Copyright © 2024 小豌先生. All rights reserved.
//

import SwiftUI

class SelectionModel: ObservableObject {
    @Published var selection: Int = 0
}

struct PickerView: View {
    @ObservedObject var selectionModel: SelectionModel
    
    var body: some View {
        Picker("选择一个模型", selection: $selectionModel.selection) {
            Text("mobileNet2模型").font(.system(size: 18)).tag(0)
            Text("resent50模型").font(.system(size: 18)).tag(1)
            Text("squeezeNet 模型").font(.system(size: 18)).tag(2)
            Text("我的自定义模型").font(.system(size: 18)).tag(3)
        }
        .pickerStyle(WheelPickerStyle())
    }
}
