//
//  CaloriesPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.03.2026.
//

import UIKit
import Foundation

protocol ICaloriesPresenter: AnyObject {
    
    func viewDidLoad()
    func didTapNextDay()
    func didTapPreviousDay()
    func uploadFood(image: UIImage)
}


final class CaloriesPresenter: ICaloriesPresenter {

    weak var view: CaloriesViewController?
    private let repository: ICaloriesRepository

    private var days: [CaloriesResponse] = []
    private var currentIndex: Int = 0

    init(repository: ICaloriesRepository) {
        self.repository = repository
    }

    func viewDidLoad() {
        fetchCalories()
    }

    private func fetchCalories() {
        repository.fetchCalories { [weak self] result in
            switch result {
            case .success(let response):
                self?.days = response
                self?.currentIndex = response.count - 1
                self?.updateUI()

            case .failure(let error):
                print(error)
            }
        }
    }

    private func updateUI() {
        guard !days.isEmpty,
              currentIndex >= 0,
              currentIndex < days.count else { return }

        let model = days[currentIndex]

        view?.showCalories(
            response: model,
            isNextEnabled: currentIndex < days.count - 1,
            isPrevEnabled: currentIndex > 0
        )
    }

    func didTapNextDay() {
        guard currentIndex < days.count - 1 else { return }
        currentIndex += 1
        updateUI()
    }

    func didTapPreviousDay() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        updateUI()
    }
    
    func uploadFood(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        repository.uploadNutrition(imageData: data) { result in
            switch result {
            case .success(let response):
                print("SUCCESS:", response)
                DispatchQueue.main.async {
                    self.view?.didReceiveNutrition(result: response)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
