//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 23/07/23.
//

import SwiftUI

struct XMarkButton: View {
  @Environment(\.isPresented) private var isPresented
  @Environment(\.dismiss) private var dismiss
  
    var body: some View {
      Button {
        if isPresented {
          dismiss()
        }
      } label: {
        Image(systemName: "xmark")
      }
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
