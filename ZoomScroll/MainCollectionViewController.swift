import SwiftUI
import UIKit

class MainScrollViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var containerView: UIView!
    private var elementViews: [UIView] = []
    private let elementHeight: CGFloat = 125
    private let elementSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        createElements()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func createElements() {
        var previousElement: UIView?
        
        for i in 0..<50 {
            let elementContainer = createElementView(index: i)
            containerView.addSubview(elementContainer)
            elementViews.append(elementContainer)
            
            elementContainer.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                elementContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                elementContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                elementContainer.heightAnchor.constraint(equalToConstant: elementHeight)
            ])
            
            if let previous = previousElement {
                // Position below the previous element
                elementContainer.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: elementSpacing).isActive = true
            } else {
                // First element - position at top with margin
                elementContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
            }
            
            previousElement = elementContainer
        }
        
        // Constrain the last element to the bottom of the container
        if let lastElement = elementViews.last {
            lastElement.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        }
    }
    
    private func createElementView(index: Int) -> UIView {
        let container = UIView()
        
        let circleView = UIView()
        circleView.backgroundColor = .systemBlue
        circleView.layer.cornerRadius = 50
        circleView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(circleView)
        
        let label = UILabel()
        label.text = "Test \(index + 1)"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(elementTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.tag = index
        
        NSLayoutConstraint.activate([
            // Circle constraints - centered horizontally in the row
            circleView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            circleView.topAnchor.constraint(equalTo: container.topAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 100),
            circleView.heightAnchor.constraint(equalToConstant: 100),
            
            // Label constraints
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 0),
            label.widthAnchor.constraint(equalTo: container.widthAnchor)
        ])
        
        return container
    }
    
    @objc private func elementTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        
        let detailVC = DetailViewController()
        
        if #available(iOS 18.0, *) {
            detailVC.preferredTransition = .zoom { context in
                // Return the tapped view for better zoom transition
                return tappedView
            }
        }
        
        present(detailVC, animated: true)
    }
}

struct UIViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainScrollViewController {
        MainScrollViewController()
    }

    func updateUIViewController(_ uiViewController: MainScrollViewController, context: Context) { }
} 
