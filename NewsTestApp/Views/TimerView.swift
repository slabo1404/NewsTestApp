//
//  TimerView.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import UIKit

protocol TimerViewDelegate: AnyObject {
    func timeIsUp()
}

final class TimerView: UIView {
    // MARK: - Views
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // MARK: - Private properties
    
    private let timeformatter: DateComponentsFormatter = {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.minute, .second]
        timeFormatter.unitsStyle = .positional
        timeFormatter.zeroFormattingBehavior = .pad
        
        return timeFormatter
    }()
    private var timer: Timer?
    private var seconds = TimeInterval() {
        didSet {
            timeLabel.text = timeformatter.string(from: seconds)
        }
    }
    
    private var backgroundTaskID: UIBackgroundTaskIdentifier?
    
    // MARK: - Internal properties
    
    weak var delegate: TimerViewDelegate?
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Overriden
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
}

// MARK: - UI

private extension TimerView {
    func setupUI() {
        clipsToBounds = true
        addSubview(timeLabel)
    }
}

// MARK: - Events

extension TimerView {
    @objc private func timeUpdate() {
        if seconds > 0 {
            seconds -= 1
        } else {
            stopTimer()
            delegate?.timeIsUp()
        }
    }
}

// MARK: - Internal methods

extension TimerView {
    func startTimer(timeLimit: TimeInterval) {
        stopTimer()
        
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.stopTimer()
        }
        
        seconds = timeLimit
        let timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timeUpdate),
            userInfo: nil,
            repeats: true
        )
        self.timer = timer
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        if let taskID = backgroundTaskID, taskID != .invalid {
            UIApplication.shared.endBackgroundTask(taskID)
        }
        backgroundTaskID = .invalid
    }
}
