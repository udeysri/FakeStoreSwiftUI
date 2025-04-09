//
//  ProductDetailView.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KFImage(URL(string: product.image))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text(product.productDescription)
                        .font(.body)
                        .padding(.top)
                    
                    HStack {
                        Text("Category:")
                            .font(.body)
                            .fontWeight(.bold)
                        Text(product.category.capitalized)
                    }
                    .padding(.top)
                    
                    HStack {
                        Text("Rating:")
                            .fontWeight(.bold)
                        Text("\(product.rating.rate, specifier: "%.1f")")
                        Text("(\(product.rating.count) reviews)")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ProductDetailView(product: MockDataFactory.testProducts[0])
    }
}

#Preview("Long Title") {
    NavigationView {
        ProductDetailView(product: MockDataFactory.testProducts[1])
    }
}
