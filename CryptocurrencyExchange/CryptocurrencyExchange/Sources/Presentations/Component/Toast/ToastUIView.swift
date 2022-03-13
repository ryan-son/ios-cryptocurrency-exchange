//
//  ToastUIView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/09.
//

import UIKit

final class ToastUIView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    init(message: String) {
        label.text = message
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init coder is not implemented.")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addSubview(label)
        backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = frame.height / 2
    }
}

extension ToastUIView {
    static func show(with model: ToastModel, on view: UIView) {
        let toastView = ToastUIView(message: model.message)
        view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 20
            ),
            toastView.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.trailingAnchor,
                constant: -20
            ),
            toastView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20),
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        UIView.animate(withDuration: 0) {
            toastView.alpha = 0
            toastView.transform = CGAffineTransform(translationX: 0, y: -200)
        }
        UIView.animate(withDuration: 1) {
            toastView.alpha = 1
            toastView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + model.duration) {
            UIView.animate(
                withDuration: 1,
                animations: {
                    toastView.alpha = 0
                    toastView.transform = CGAffineTransform(translationX: 0, y: -200)
                },
                completion: { _ in
                    toastView.removeFromSuperview()
                }
            )
        }
    }
}
