//
//  DetailRubriquesViewController.swift
//  MyCine
//
//  Created by Gbaha Patrick Cazon on 22/01/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import UIKit

class DetailRubriquesViewController: UITableViewController {
    var rubriques: Rubriques?
    var filmData: [Film] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        guard let r = rubriques else { fatalError("No film provided")}
        configure(with: r)
        // Do any additional setup after loading the view.
    }
    private func configure(with rubriques: Rubriques) {
        print(rubriques.id)
        let request = URLRequest(url: NSURL(string: "https://api.themoviedb.org/3/genre/\(rubriques.id)/movies?api_key=59573a66a7496ba950f43835c493e9d0")! as URL)
        print(request)
        
        do {
            let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            print(jsonSerialized)
            if let json = jsonSerialized, let films = json["results"] as? [[String:Any]]{
                // print(films)
                for film in films {
                    if let id = film["id"] as? Int, let title = film["title"] as? String, let description = film["overview"] as? String, let image = film["poster_path"] as? String{
                        //print(title)
                        let filmList = Film(id:id, titre:title,description: description, image:image)
                        filmData.append(filmList)
                        
                        
                        
                    }
                }
                //tableView.reloadData()
                
            }
        }
        catch{
            print(error)
        }
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filmData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataRubrique", for: indexPath)
        
        let film = filmData[indexPath.row]
        
        cell.textLabel?.text = film.titre
        
        return cell

        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailRubriqueFilm" {
            guard let destVC = segue.destination as? DetaiFilmViewController else { fatalError("bad type, expected DetaiFilmViewController") }
            
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            let currentFilm = filmData[indexPath.row]
            destVC.film = currentFilm
            
            
        }
    }
 

}
