//
//  ProductRowView.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-08.
//

import SwiftUI
import Kingfisher

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack {
            /* AsyncImage(url: URL(string: product.image)) { image in
             image
             .resizable()
             .aspectRatio(contentMode: .fit)
             } placeholder: {
             ProgressView()
             }
             .frame(maxWidth: 100, maxHeight: 150)
             */
            KFImage(URL(string: product.image))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .background(.clear)
                .frame(maxWidth: 100, maxHeight: 150)
            
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview() {
    ProductRowView(product: MockDataFactory.testProducts[0])
}
