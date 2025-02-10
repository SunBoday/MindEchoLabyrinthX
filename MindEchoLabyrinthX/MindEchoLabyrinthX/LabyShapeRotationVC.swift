//
//  LabyShapeRotationVC.swift
//  MindEchoLabyrinthX
//
//  Created by SunTory on 2025/2/10.
//

import UIKit

class LabyShapeRotationVC: UIViewController {
    private let shapes: [(name: String, sides: Int)] = [
        ("Triangle", 3), ("Square", 4), ("Pentagon", 5), ("Hexagon", 6)
    ]
    
    private var correctShape: (name: String, sides: Int)?
    private var timer: Timer?
    private var timeLeft = 60
    private var currentAngle: CGFloat = 0
    private var score = 0
    
    private let shapeView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Identify the shape!"
        label.textColor = .white
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 30, bottom: 12, right: 30)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
    private var shapeButtons: [UIButton] = []
    
    override func viewDidLoad() {
        
        self.title = "Shape Rotation Challenge"
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(questionLabel)
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(shapeView)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            shapeView.widthAnchor.constraint(equalToConstant: 200),
            shapeView.heightAnchor.constraint(equalToConstant: 200),
            
            timerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        setupShapeButtons()
    }
    
    private func setupShapeButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        let topStackView = UIStackView()
        let bottomStackView = UIStackView()
        [topStackView, bottomStackView].forEach {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 15
        }
        
        for (index, shape) in shapes.enumerated() {
            let button = UIButton()
            button.setTitle(shape.name, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 20
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)
            button.addTarget(self, action: #selector(shapeButtonTapped(_:)), for: .touchUpInside)
            shapeButtons.append(button)
            
            if index < 2 {
                topStackView.addArrangedSubview(button)
            } else {
                bottomStackView.addArrangedSubview(button)
            }
        }
        
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(bottomStackView)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc private func startGame() {
        score = 0
        timeLeft = 60
        updateScore()
        updateTimer()
        selectRandomShape()
        startTimer()
        startButton.setTitle("Restart", for: .normal)
    }
    
    private func selectRandomShape() {
        correctShape = shapes.randomElement()
        if let correctShape = correctShape {
            questionLabel.text = "Which shape is this?"
            drawShape(sides: correctShape.sides)
            rotateShape()
        }
    }
    
    private func drawShape(sides: Int) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))
        let image = renderer.image { context in
            let rect = CGRect(x: 35, y: 35, width: 130, height: 130)
            UIColor.white.setStroke()
            UIColor.clear.setFill()
            
            let path = UIBezierPath()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = rect.width / 2
            
            for i in 0..<sides {
                let angle = (CGFloat(i) * 2 * .pi / CGFloat(sides)) - (.pi / 2)
                let point = CGPoint(
                    x: center.x + radius * cos(angle),
                    y: center.y + radius * sin(angle)
                )
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.close()
            path.lineWidth = 4
            path.stroke()
        }
        shapeView.image = image
    }
    
    private func rotateShape() {
        currentAngle = CGFloat([0, 90, 180, 270].randomElement()!)
        UIView.animate(withDuration: 0.5) {
            self.shapeView.transform = CGAffineTransform(rotationAngle: self.currentAngle * .pi / 180)
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1
            updateTimerLabel()
            updateScore()
        } else {
            questionLabel.text = "Time's up! Game Over. Your final score: \(score)"
            stopTimer()
            showRestartButton()
        }
    }
    
    private func updateTimerLabel() {
        timerLabel.text = "Time: \(timeLeft)s"
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateScore() {
        timerLabel.text = "Time: \(timeLeft)s | Score: \(score)"
    }
    
    private func showRestartButton() {
        let restartButton = UIButton(type: .system)
        restartButton.setTitle("Play Again", for: .normal)
        restartButton.setTitleColor(.white, for: .normal)
        restartButton.backgroundColor = .systemBlue
        restartButton.layer.cornerRadius = 15
        restartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        restartButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 30, bottom: 12, right: 30)
        restartButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restartButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func shapeButtonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.title(for: .normal),
              let correctShape = correctShape else { return }
        
        if buttonTitle == correctShape.name {
            score += 10
            questionLabel.text = "Correct! Well done!"
        } else {
            score -= 5
            questionLabel.text = "Wrong! It was a \(correctShape.name)"
        }
        updateScore()
        
        // Wait for 1 second to show the result, then show next shape
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.timeLeft > 0 {
                self.selectRandomShape()
            }
        }
    }
}
