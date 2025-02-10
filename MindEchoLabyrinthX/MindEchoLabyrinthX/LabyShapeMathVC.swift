//
//  LabyShapeMathVC.swift
//  MindEchoLabyrinthX
//
//  Created by SunTory on 2025/2/10.
//

import UIKit

class LabyShapeMathVC: UIViewController {
    private let shapes: [(name: String, sides: Int)] = [
        ("Circle", 0), ("Triangle", 3), ("Square", 4), ("Pentagon", 5), ("Hexagon", 6)
    ]
    
    private let questions: [(text: String, sides: Int)] = [
            ("Tap the shape with 3 sides", 3), ("Tap the shape with 4 sides", 4),
            ("Tap the shape with 5 sides", 5), ("Tap the shape with 6 sides", 6),
            ("Tap the shape with no sides", 0), ("Which shape has equal sides and angles?", 4),
            ("Which shape resembles a stop sign?", 5), ("Tap the shape with the least sides", 0),
            ("Which shape is commonly used in architecture?", 6), ("Tap the shape that can roll", 0),
            ("Which shape is known as a polygon with 5 sides?", 5), ("Which shape can tessellate perfectly?", 4),
            ("Which shape has all equal-length sides?", 3), ("Which shape is most common in road signs?", 4),
            ("Tap the shape used for traffic yield signs", 3), ("Which shape is seen in honeycombs?", 6),
            ("Which shape is used in dice?", 4), ("Which shape is a fundamental block of geometry?", 3),
            ("Tap the shape used in playing fields?", 4), ("Which shape is often drawn in snowflakes?", 6),
            ("Which shape is used in pizza slices?", 3), ("Which shape is commonly found in soccer balls?", 6),
            ("Tap the shape found in the Olympic logo rings", 0), ("Which shape is a rectangle but with equal sides?", 4),
            ("Which shape is often used in warning signs?", 3), ("Which shape is the foundation of pyramids?", 3),
            ("Tap the shape seen in honeybee hives", 6), ("Which shape do most playing cards have?", 4),
            ("Which shape is used in traditional Japanese fans?", 0), ("Which shape forms the base of the Eiffel Tower?", 4),
            ("Which shape is used for soft drink bottle bases?", 5), ("Tap the shape used in ancient coins", 6),
            ("Which shape is a rhombus but not a square?", 4), ("Which shape is found in modern architecture domes?", 6),
            ("Which shape is essential for paper folding (origami)?", 4), ("Which shape is often used for dartboards?", 0),
            ("Tap the shape used in sports fields with goalposts", 4), ("Which shape is a variation of an ellipse?", 0)
        ]
        
    private var correctShape: (name: String, sides: Int)?
    private var currentQuestion: (text: String, sides: Int)?
    private var timer: Timer?
    private var timeLeft = 10
    private var score = 0
    private var isGamePaused = true
    private var usedQuestions: Set<Int> = []
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.text = "Score: 0"
        return label
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play Game", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
    private var shapeButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shape Math Challenge"
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(scoreLabel)
        view.addSubview(questionLabel)
        view.addSubview(timerLabel)
        view.addSubview(answerLabel)
        view.addSubview(startButton)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -100),
            
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            timerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startButton.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 180),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setupShapeButtons()
    }
    
    private func setupShapeButtons() {
        // Remove existing shape buttons
        shapeButtons.forEach { $0.removeFromSuperview() }
        shapeButtons.removeAll()
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        let gridSize = 2
        let spacing: CGFloat = 10
        let buttonSize = (UIScreen.main.bounds.width * 0.9 - CGFloat(gridSize + 1) * spacing) / CGFloat(gridSize)
        
        // Get the correct shape for the current question
        guard let currentQuestion = currentQuestion,
              let correctShape = shapes.first(where: { $0.sides == currentQuestion.sides }) else { return }
        
        // Create array of options including the correct answer and 3 random different shapes
        var availableShapes = shapes.filter { $0.name != correctShape.name }
        availableShapes.shuffle()
        var optionShapes = [correctShape] + availableShapes.prefix(3)
        optionShapes.shuffle()
        
        // Create buttons for each option
        for (index, shape) in optionShapes.enumerated() {
            let row = index / gridSize
            let column = index % gridSize
            
            let button = UIButton()
            button.setTitle(shape.name, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.addTarget(self, action: #selector(shapeButtonTapped(_:)), for: .touchUpInside)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 2
            
            let size = buttonSize * 0.4
            let path = UIBezierPath()
            
            switch shape.sides {
            case 0:
                path.addArc(withCenter: CGPoint(x: buttonSize/2, y: buttonSize/2),
                           radius: size/2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            case 3:
                let height = size * sin(.pi / 3)
                let startPoint = CGPoint(x: buttonSize/2, y: buttonSize/2 - height/2)
                path.move(to: startPoint)
                path.addLine(to: CGPoint(x: buttonSize/2 - size/2, y: buttonSize/2 + height/2))
                path.addLine(to: CGPoint(x: buttonSize/2 + size/2, y: buttonSize/2 + height/2))
                path.close()
            case 4:
                path.move(to: CGPoint(x: buttonSize/2 - size/2, y: buttonSize/2 - size/2))
                path.addLine(to: CGPoint(x: buttonSize/2 + size/2, y: buttonSize/2 - size/2))
                path.addLine(to: CGPoint(x: buttonSize/2 + size/2, y: buttonSize/2 + size/2))
                path.addLine(to: CGPoint(x: buttonSize/2 - size/2, y: buttonSize/2 + size/2))
                path.close()
            default:
                let center = CGPoint(x: buttonSize/2, y: buttonSize/2)
                path.move(to: CGPoint(x: center.x + size/2, y: center.y))
                for i in 1...shape.sides {
                    let angle = CGFloat(i) * 2 * .pi / CGFloat(shape.sides)
                    let point = CGPoint(
                        x: center.x + size/2 * cos(angle),
                        y: center.y + size/2 * sin(angle)
                    )
                    path.addLine(to: point)
                }
                path.close()
            }
            
            shapeLayer.path = path.cgPath
            button.layer.addSublayer(shapeLayer)
            
            containerView.addSubview(button)
            button.frame = CGRect(
                x: CGFloat(column) * (buttonSize + spacing),
                y: CGFloat(row) * (buttonSize + spacing),
                width: buttonSize,
                height: buttonSize
            )
            
            shapeButtons.append(button)
        }
    }
    
    @objc private func startGame() {
        isGamePaused = false
        score = 0
        scoreLabel.text = "Score: 0"
        startButton.setTitle("Pause Game", for: .normal)
        timeLeft = 10
        usedQuestions.removeAll()
        updateTimerLabel()
        selectRandomQuestion()
        startTimer()
    }
    
    private func selectRandomQuestion() {
        if usedQuestions.count >= questions.count {
            usedQuestions.removeAll()
        }
        
        let availableQuestions = questions.enumerated().filter { !usedQuestions.contains($0.offset) }
        
        if let randomQuestion = availableQuestions.randomElement() {
            usedQuestions.insert(randomQuestion.offset)
            currentQuestion = randomQuestion.element
            if let question = currentQuestion {
                questionLabel.text = question.text
                correctShape = shapes.first(where: { $0.sides == question.sides })
                setupShapeButtons() // Rebuild shape buttons for new question
            }
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
        } else {
            score = max(0, score - 3)
            scoreLabel.text = "Score: \(score)"
            if let correctShape = correctShape {
                answerLabel.text = "Time's up! The correct answer was \(correctShape.name)"
                answerLabel.textColor = .red
                answerLabel.isHidden = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.answerLabel.isHidden = true
                self.selectRandomQuestion()
                self.timeLeft = 10
            }
        }
    }
    
    private func updateTimerLabel() {
        timerLabel.text = "Time: \(timeLeft)s"
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func shapeButtonTapped(_ sender: UIButton) {
        guard let selectedShape = sender.title(for: .normal),
              let correctShape = correctShape,
              !isGamePaused else { return }
        
        if selectedShape == correctShape.name {
            score += 10
            answerLabel.text = "Correct! The answer is \(correctShape.name)"
            answerLabel.textColor = .green
        } else {
            score = max(0, score - 5)
            answerLabel.text = "Wrong! The correct answer was \(correctShape.name)"
            answerLabel.textColor = .red
        }
        answerLabel.isHidden = false
        scoreLabel.text = "Score: \(score)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.answerLabel.isHidden = true
            self.selectRandomQuestion()
            self.timeLeft = 10
        }
    }
}

