//
//  ProductListView.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import SwiftUI
import SwiftData
import Kingfisher

struct ProductListView: View {
    
    @ObservedObject var viewModel: ProductListViewModel
    @State private var selectedProduct: Product?
    
    // Temp:- Remove / probably may be better way to handle this
    let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    var body: some View {
        NavigationSplitView {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                    
                case .error(let message, let offline):
                    VStack(spacing: 16) {
                        Text("Error: \(message)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        if offline {
                            Text("You're currently offline")
                                .foregroundColor(.orange)
                        }
                        
                        Button("Retry") {
                            Task {
                                await viewModel.fetchProducts()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    
                case .loaded:
                    List(viewModel.products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductRowView(product: product)
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.refreshProducts()
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.refreshProducts()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.state == .loading)
                }
            }
        } detail: {
            if let product = selectedProduct {
                ProductDetailView(product: product)
            } else {
                Text("Select a product")
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            if !isPreview {
                await viewModel.fetchProducts()
            }
        }
    }
}


#Preview("Products List") {
    ProductListView(
        viewModel: MockProductListViewModel.createProductsListState()
    )
}

#Preview("Loading State") {
    ProductListView(
        viewModel: MockProductListViewModel.createLoadingState()
    )
}

#Preview("Error State") {
    ProductListView(
        viewModel: MockProductListViewModel.createErrorState()
    )
}

#Preview("Offline State") {
    ProductListView(
        viewModel: MockProductListViewModel.createOfflineState()
    )
}
