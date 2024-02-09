//
//  ViewController.swift
//  RelatedAnimation
//
//  Created by Иван Дроботов on 09.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var rectangle = UIView()
    private lazy var slider = UISlider()
    
    private struct Constants {
        static let rectangleSideLength: CGFloat = 75
        static let rectangleTopSpacing: CGFloat = 30
        static let sliderTopSpacing: CGFloat = 150
        static let duration: TimeInterval = 0.6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    //MARK: - Style
    private func style() {
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.backgroundColor = .systemGreen
        rectangle.layer.cornerRadius = 8
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1000
        slider.addTarget(self, action: #selector(valueChanger), for: .valueChanged)
        slider.addTarget(self, action: #selector(touchSlider), for: .touchUpInside)
    }
    
    //MARK: - Layout
    private func layout() {
        view.addSubview(rectangle)
        view.addSubview(slider)
        
        //MARK: - rectangle
        NSLayoutConstraint.activate([
            rectangle.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            rectangle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.rectangleTopSpacing),
            rectangle.widthAnchor.constraint(equalToConstant: Constants.rectangleSideLength),
            rectangle.heightAnchor.constraint(equalToConstant: Constants.rectangleSideLength),
        ])
        
        //MARK: - slider
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.sliderTopSpacing),
            
        ])
    }
    
    //MARK: - Actions
    @objc private func valueChanger() {
        let currentScale = CGFloat(slider.value)/CGFloat(slider.maximumValue)
        let finalScale = currentScale * 0.5 + 1
        let newSideLength = Constants.rectangleSideLength * finalScale
        let startPoint = (slider.frame.origin.x + newSideLength / 2)
        let finalPoint = slider.frame.width + view.layoutMargins.left - newSideLength / 2
        let scaling = CGAffineTransform.identity.scaledBy(x: finalScale, y: finalScale)
        let rotation = CGAffineTransform.init(rotationAngle: CGFloat.pi/2 * currentScale)
        rectangle.center.x = finalPoint * currentScale + startPoint * (1 - currentScale)
        rectangle.transform = CGAffineTransformConcat(rotation, scaling)
    }
    
    @objc private func touchSlider(_ sender: UISlider) {
        UIView.animate(withDuration: Constants.duration) {
            sender.setValue(sender.maximumValue, animated: true)
            sender.sendActions(for: .valueChanged)
        }
    }
}
