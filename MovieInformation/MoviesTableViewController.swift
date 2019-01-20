//
//  MoviesTableViewController.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 15..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MoviesTableViewController: UIViewController {
    
    // MARK: - Properties
    
    let tableViewCellIndentifier: String = "tableViewCell"
    var movies: [Movie] = []
    var thumbURLList: [String] = []
    var cachedImage: [URL: UIImage] = [:]
    let showMovieInfoSegue: String = "showMovieInfo"
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMovies()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMovies()
        self.updateTitle()
    }
    
    // MARK: - Networking Methods
    
    private func getServerURL(connectWith subURL: String) -> URL? {
        let baseURL = "https://connect-boxoffice.run.goorm.io/"
        let finalURL = URL(string: baseURL + subURL)
        return finalURL
    }
    
    private func loadMovies(){
        
        guard let url = self.getServerURL(connectWith: "movies?order_type=\(UserPreference.shared.sortingOption.rawValue)") else {
            return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?
            , error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                
                let alert: UIAlertController
                alert = UIAlertController(title: "알림", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                let okAction:UIAlertAction
                okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            guard let data = data else { return }
            
            do{
                let collectionData: MovieResult = try JSONDecoder().decode(MovieResult.self , from: data)
                
                self.movies = collectionData.movies
                
                for movie in self.movies {
                    self.thumbURLList.append(movie.thumb)
                    print(self.thumbURLList)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            } catch(let err) {
                print(err.localizedDescription)
                
                let alert: UIAlertController
                alert = UIAlertController(title: "알림", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                let okAction:UIAlertAction
                okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        dataTask.resume()
        
    }
    
    // MARK: - Supporing Methods
    
    private func updateTitle(){
        
        switch UserPreference.shared.sortingOption {
        case .curation:
            self.navigationItem.title = "큐레이션"
        case .date:
            self.navigationItem.title = "개봉일순"
        default:
            self.navigationItem.title = "예매율순"
        }
    }
    
    @IBAction func touchUpSortingOptionButton(_ sender: UIBarButtonItem) {
        
        let alert: UIAlertController
        
        alert = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        

        let reservationRateAction: UIAlertAction = UIAlertAction(title: "예매율", style: .default, handler: {(alert: UIAlertAction!) in
            UserPreference.shared.sortingOption = .reservationRate
            self.navigationItem.title = "예매율순"
            self.loadMovies()
        })
        
        let curationAction: UIAlertAction = UIAlertAction(title: "큐레이션", style: .default, handler: {(alert: UIAlertAction!) in
            UserPreference.shared.sortingOption = .curation
            self.navigationItem.title = "큐레이션"
            self.loadMovies()
        })
        
        let dateAction: UIAlertAction = UIAlertAction(title: "개봉일", style: .default, handler: {(alert: UIAlertAction!) in
            UserPreference.shared.sortingOption = .date
            self.navigationItem.title = "개봉일순"
            self.loadMovies()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(reservationRateAction)
        alert.addAction(curationAction)
        alert.addAction(dateAction)
        
        self.present(alert, animated: true, completion: {self.updateTitle()})
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.showMovieInfoSegue {
            if let destViewController = segue.destination as? MovieViewController {
                let selectedMovie: Movie = (sender as? Movie)!
                destViewController.currentMovie = selectedMovie
                destViewController.currentImage = self.cachedImage[URL(string: (selectedMovie.thumb))!]
                destViewController.loadMovieDetail()
                destViewController.loadMovieComments()
            }
        }
    }
}

// MARK: - UITableViewController DataSource Methods

extension MoviesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let basicCell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellIndentifier , for: indexPath)
            as? MoviesTableViewCell else { return basicCell }
        
        let movie: Movie = self.movies[indexPath.row]
        
        //Cell Configuration
        cell.thumbnailImage.image = UIImage(named: "img_placeholder")
        cell.titleLabel?.text = movie.title
        cell.detailLabel?.text = "평점 : \(movie.userRating) 예매순위 : \(movie.reservationGrade) 예매율 : \(movie.reservationRate)"
        cell.dateLabel?.text = "개봉일 : \(movie.date)"
        if movie.grade == 0 {
            cell.ageRestrictImage?.image = UIImage(named: "ic_allages")
        } else {
            cell.ageRestrictImage?.image = UIImage(named: "ic_\(movie.grade)")
        }
        cell.thumbnailImage.image = self.cachedImage[URL(string: movie.thumb)!] ?? UIImage(named:"img_placeholder")
        
        //Image Loding
        
        let thumbURL: URL = URL(string: movie.thumb)!
        if(self.cachedImage[thumbURL] != nil){
            return cell
        }
        let imageDispatchQueue: DispatchQueue = DispatchQueue(label: "image")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        imageDispatchQueue.async {
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            guard let data: Data = try? Data(contentsOf: thumbURL) else {
                print("이미지 로드 실패")
                return
            }
            let image: UIImage? = UIImage(data: data)
            DispatchQueue.main.async {
                cell.thumbnailImage.image = image ?? UIImage(named: "img_placeholder")
            }
            self.cachedImage[thumbURL] = image
        }
        return cell
    }
}

// MARK: - UITableViewController Delegate Methods

extension MoviesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMovie: Movie = self.movies[indexPath.row]
        performSegue(withIdentifier: self.showMovieInfoSegue, sender: selectedMovie)
    }
}
