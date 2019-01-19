//
//  MoviesCollectionViewController.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 15..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MoviesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var movies: [Movie] = []
    var thumbURLList: [String] = []
    var cachedImage: [URL: UIImage] = [:]
    
    struct Const {
        static let collectionViewCellIdentifier = "collectionViewCell"
        static let showMovieInfoSegue: String = "showMovieInfo"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMovies()
        self.updateSorting()
    }
    
    
    private func getServerURL(connectWith subURL: String) -> URL? {
        let baseURL = "https://connect-boxoffice.run.goorm.io/"
        let finalURL = URL(string: baseURL + subURL)
        return finalURL
        
    }
    
    func updateSorting(type: UserPreference.Sorting? = nil){
        if let type = type {
            UserPreference.shared.sortingOption = type
        }
        self.navigationItem.title = UserPreference.shared.sortingOption.titleString
    }
    
    func loadMovies(){
        
        guard let url = self.getServerURL(connectWith: "movies?order_type=\(UserPreference.shared.sortingOption.rawValue)") else { return }
        
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?
            , error: Error?) in
            
            if let error = error {
                
                let alert: UIAlertController
                alert = UIAlertController(title: "알림", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                let okAction:UIAlertAction
                okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                print(error.localizedDescription)
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
                    self.collectionView.reloadData()
                }
                
                
            } catch(let err) {
                
                let alert: UIAlertController
                alert = UIAlertController(title: "알림", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                let okAction:UIAlertAction
                okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                print(err.localizedDescription)
            }
            
        }
        dataTask.resume()
        
    }
    
    @IBAction func touchUpSortingOptionButton(_ sender: UIBarButtonItem) {
        
        let alert: UIAlertController
        
        alert = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        let reservationRateAction: UIAlertAction = UIAlertAction(title: "예매율",
                                                                 style: .default,
                                                                 handler: {(alert: UIAlertAction!) in
            self.updateSorting(type: .reservationRate)
            self.loadMovies()
        })
        
        let curationAction: UIAlertAction = UIAlertAction(title: "큐레이션",
                                                          style: .default,
                                                          handler: {(alert: UIAlertAction!) in
            self.updateSorting(type: .curation)
            self.loadMovies()
        })
        
        let dateAction: UIAlertAction = UIAlertAction(title: "개봉일",
                                                      style: .default,
                                                      handler: {(alert: UIAlertAction!) in
            self.updateSorting(type: .date)
            self.loadMovies()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(reservationRateAction)
        alert.addAction(curationAction)
        alert.addAction(dateAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MoviesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.collectionViewCellIdentifier, for: indexPath) as! MoviesCollectionViewCell
        
        let movie: Movie = self.movies[indexPath.row]
       
        //Cell Configuration
        cell.thumbnailImage.image = UIImage(named: "img_placeholder")
        cell.titleLabel?.text = movie.title
        cell.detailLabel?.text = "\(movie.reservationGrade)위(\(movie.userRating)) / \(movie.reservationRate)%"
        cell.dateLabel?.text = movie.date
        //cell.thumbnailImage.image = cachedImage[URL(string: movie.thumb)!] ?? UIImage(named: "img_placeholder")
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

    // 화면 전환
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie: Movie = self.movies[indexPath.item]
        performSegue(withIdentifier: Const.showMovieInfoSegue, sender: selectedMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Const.showMovieInfoSegue {
            if let destViewController = segue.destination as? MovieViewController {
                let selectedMovie: Movie = (sender as? Movie)!
                destViewController.currentMovie = selectedMovie
                destViewController.currentImage = self.cachedImage[URL(string: (selectedMovie.thumb))!]
                print(destViewController.currentImage)
                destViewController.loadMovieDetail()
                destViewController.loadMovieComments()
            }
        }
    }

}
