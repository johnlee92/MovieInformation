//
//  MovieViewController.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 16..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var currentMovie: Movie!
    var currentImage: UIImage!
    var currentMovieDetail: MovieDetail?
    var currentMovieComments: MovieComments?
    
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.title = self.currentMovie.title
        
    }
    
    private func getServerURL(connectWith subURL: String) -> URL? {
        let baseURL = "https://connect-boxoffice.run.goorm.io/"
        let finalURL = URL(string: baseURL + subURL)
        return finalURL
    }
    
    func loadMovieDetail(){
        
        guard let url = self.getServerURL(connectWith: "movie?id=\(self.currentMovie.id)") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?
            , error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do{
                let movieDetail: MovieDetail = try JSONDecoder().decode(MovieDetail.self , from: data)
                
                self.currentMovieDetail = movieDetail
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch(let err) {
                print(err.localizedDescription)
            }
            
        }
        dataTask.resume()
        
    }
    
    func loadMovieComments(){
        
        guard let url = self.getServerURL(connectWith: "comments?movie_id=\(self.currentMovie.id)") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?
            , error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do{
                let movieComments: MovieComments = try JSONDecoder().decode(MovieComments.self , from: data)
                
                self.currentMovieComments = movieComments
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            } catch(let err) {
                print(err.localizedDescription)
            }
            
        }
        dataTask.resume()
        
    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(16)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            if let commentsCount = self.currentMovieComments?.comments.count {
               return 1 + commentsCount
            }
            else {
               return 1
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
            
        // Information
        case 0:
            let cell: MovieInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "infoTableViewCell", for: indexPath) as! MovieInfoTableViewCell
            
            // Movie Information Cell Configuration
            
            cell.movieThumbnailImage.setImage(self.currentImage, for: UIControl.State.normal)
            cell.movieTitleLabel?.text = self.currentMovie.title
            
            if self.currentMovie.grade == 0 {
                cell.movieAgeRestrict?.image = UIImage(named: "ic_allages")
            } else {
                cell.movieAgeRestrict?.image = UIImage(named: "ic_\(self.currentMovie.grade)")
            }
            cell.movieDataLabel?.text = "\(self.currentMovie.date) 개봉"
            cell.movieReservationRate?.text = "\(self.currentMovie.reservationGrade)위 \(self.currentMovie.reservationRate)%"
            cell.movieUserRating?.text = "\(self.currentMovie.userRating)"
            
            // Movie Detail Information Configuration
            
            guard let movieDetail: MovieDetail = self.currentMovieDetail else {
                return cell
            }
            
            cell.genreRunningTimeLabel?.text = "\(movieDetail.genre)/\(movieDetail.duration)분"
            
            let withSeparator: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.numberStyle = .decimal
                return formatter
            }()
            
            let audience = withSeparator.string(from: movieDetail.audience as NSNumber)
            cell.movieTotalViewer?.text = audience
            
            
            
            // Star Visualizing
            
            if(movieDetail.userRating >= 1){
                cell.starNumber1.image = UIImage(named: "ic_star_large_half")
            }
            if(movieDetail.userRating >= 2){
                cell.starNumber1.image = UIImage(named: "ic_star_large_full")
            }
            if(movieDetail.userRating >= 3){
                cell.starNumber2.image = UIImage(named: "ic_star_large_half")
            }
            if(movieDetail.userRating >= 4){
                cell.starNumber2.image = UIImage(named: "ic_star_large_full")
            }
            if(movieDetail.userRating >= 5){
                cell.starNumber3.image = UIImage(named: "ic_star_large_half")
            }
            if(movieDetail.userRating >= 6){
                cell.starNumber3.image = UIImage(named: "ic_star_large_full")
            }
            if(movieDetail.userRating >= 7){
                cell.starNumber4.image = UIImage(named: "ic_star_large_half")
            }
            if(movieDetail.userRating >= 8){
                cell.starNumber4.image = UIImage(named: "ic_star_large_full")
            }
            if(movieDetail.userRating >= 9){
                cell.starNumber5.image = UIImage(named: "ic_star_large_half")
            }
            if(movieDetail.userRating == 10){
                cell.starNumber5.image = UIImage(named: "ic_star_large_full")
            }
            
            
            return cell
        
        // Synopsis
        case 1:
            let cell: MovieStoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storyTableViewCell", for: indexPath) as! MovieStoryTableViewCell
            
            guard let movieDetail: MovieDetail = self.currentMovieDetail else {
                return cell
            }
            
            cell.movieStoryLabel?.text = movieDetail.synopsis
            
            return cell
        
        // Makers
        case 2:
            let cell: MovieMakerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "makerTableViewCell", for: indexPath) as! MovieMakerTableViewCell
            guard let movieDetail: MovieDetail = self.currentMovieDetail else {
                return cell
            }
            
            cell.movieDirectorLabel?.text = movieDetail.director
            cell.movieActorLabel?.text = movieDetail.actor
            
            return cell

        // Comments
        case 3:
            if indexPath.row == 0 {
                
            let cell: MovieCommentHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentHeaderTableViewCell", for: indexPath) as! MovieCommentHeaderTableViewCell
            return cell
            }
            else {
                
            let cell: MovieCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! MovieCommentTableViewCell
            
            guard let movieComment: MovieComment = self.currentMovieComments?.comments[indexPath.row-1] else {
                return cell
            }
                
                
            cell.userIDLabel?.text = movieComment.writer
                
            let date = Date(timeIntervalSince1970: movieComment.timeStamp)
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringDate = dateFormatter.string(from: date)
                
            cell.commentDateLabel?.text = stringDate
            cell.commentContentLabel?.text = movieComment.contents
                
            //Star Initializing
            cell.starNumber1.image = UIImage(named: "ic_star_large")
            cell.starNumber2.image = UIImage(named: "ic_star_large")
            cell.starNumber3.image = UIImage(named: "ic_star_large")
            cell.starNumber4.image = UIImage(named: "ic_star_large")
            cell.starNumber5.image = UIImage(named: "ic_star_large")
                
            //Star Visualizing
            if(movieComment.rating >= 1){
                cell.starNumber1.image = UIImage(named: "ic_star_large_half")
            }
            if(movieComment.rating >= 2){
                cell.starNumber1.image = UIImage(named: "ic_star_large_full")
            }
            if(movieComment.rating >= 3){
                cell.starNumber2.image = UIImage(named: "ic_star_large_half")
            }
            if(movieComment.rating >= 4){
                cell.starNumber2.image = UIImage(named: "ic_star_large_full")
            }
            if(movieComment.rating >= 5){
                cell.starNumber3.image = UIImage(named: "ic_star_large_half")
            }
            if(movieComment.rating >= 6){
                cell.starNumber3.image = UIImage(named: "ic_star_large_full")
            }
            if(movieComment.rating >= 7){
                cell.starNumber4.image = UIImage(named: "ic_star_large_half")
            }
            if(movieComment.rating >= 8){
                cell.starNumber4.image = UIImage(named: "ic_star_large_full")
            }
            if(movieComment.rating >= 9){
                cell.starNumber5.image = UIImage(named: "ic_star_large_half")
            }
            if(movieComment.rating == 10){
                cell.starNumber5.image = UIImage(named: "ic_star_large_full")
            }
                
            return cell
            }
            
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath)
            return cell
            
        }
        
    }
    
    //화면 전환
    @IBAction func touchUpPosterImage(_ sender: UIButton) {
        performSegue(withIdentifier: "showPosterImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let sourceImage = self.currentImage
        
        if segue.identifier == "showPosterImage" {
            if let destViewController = segue.destination as? PosterViewController {
                destViewController.posterImage = sourceImage
                destViewController.currentMovie = self.currentMovie
            }
        }
    }
  

}
