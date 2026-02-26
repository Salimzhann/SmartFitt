//
//  ExerciseDetailsPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 22.02.2026.
//

import Foundation


protocol IExerciseDetailsPresenter: AnyObject {
    
    func viewDidLoad()
}


final class ExerciseDetailsPresenter: IExerciseDetailsPresenter {
    
    private let repository: IWorkoutRepository
    private let exerciseID: Int
    weak var view: IExerciseDetailsView?
    
    init(repository: IWorkoutRepository, exerciseID: Int) {
        self.repository = repository
        self.exerciseID = exerciseID
    }
    
    func viewDidLoad() {
        repository.fetchDetailInformation(exerciseID: exerciseID) { [weak self] data in
            switch data {
            case .success(let response):
                if let url = URL(string: response.videoUrl) {
                    self?.view?.configureVideo(url: url)
                } else {
                    self?.view?.configureVideo(url: nil)
                }
                self?.view?.fetchData(data: response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
