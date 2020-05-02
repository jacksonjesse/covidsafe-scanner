//
//  ActivityIndicator.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 27/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    @Environment(\.colorScheme) var colourScheme
    
    var style: UIActivityIndicatorView.Style = .medium
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = colourScheme == .dark ? UIColor.white : UIColor.black
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

#if DEBUG
struct ActivityIndicator_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
            ActivityIndicator(isAnimating: .constant(true), style: .medium)
        }
    }
}
#endif
