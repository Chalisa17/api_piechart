//
//  ViewController.swift
//  SwiftyStats
//
//  Created by Brian Advent on 19.03.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import Charts
struct jsonstruct:Decodable {
    let coord:Coord
    let weather:[Weather]
    let base:String??
    let main:Main
    let wind:Wind
    let clouds:Clouds
    let dt:Int??
    let sys:Sys
    let id:Int??
    let name:String??
    let cod:Int??
    
}

struct Coord:Decodable {
    let lon: Double??
    let lat: Double??
}
struct Weather:Decodable {
    let id: Int??
    let main: String??
    let description: String??
    let icon: String??
}
struct Main:Decodable {
    let temp: Double??
    let pressure: Double??
    let humidity: Double??
    let temp_min: Double??
    let temp_max: Double??
    let sea_level: Double??
    let grnd_level: Double??
}
struct Wind:Decodable {
    let speed: Double??
    let deg: Double??
}
struct Clouds:Decodable {
    let all: Int??
}
struct Sys:Decodable {
    let message: Double??
    let country: String??
    let sunrise: Int??
    let sunset: Int??
}
class ViewController: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    var t: Double? = 0.0
    var h: Double? = 0.0
    var temp = PieChartDataEntry(value: 0)
    var humidity = PieChartDataEntry(value: 0)
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParsing()
        pieChart.chartDescription?.text = ""
        
        temp.label = "Temperature"
        
        humidity.label = "Humidity"
        
        numberOfDownloadsDataEntries = [temp, humidity]
        
        updateChartData()
        
    }

    func updateChartData() {

        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)

        let colors = [UIColor(named:"iosColor"), UIColor(named:"macColor")]
        chartDataSet.colors = colors as! [NSUIColor]

        pieChart.data = chartData


    }
    func jsonParsing(){
        
        let jsonUrlString = "https://api.openweathermap.org/data/2.5/weather?lat=55&lon=109&appid=5fc80dff1d6b90690720e95bdfac361b"
        guard let url = URL(string: jsonUrlString)else{return}
        URLSession.shared.dataTask(with: url){(data, response,err) in
            guard let data = data else{ return }
            
            do{
                let course = try JSONDecoder().decode(jsonstruct.self, from: data)
                self.temp.value = course.main.temp!!
                self.humidity.value = course.main.humidity!!
                
            }catch let jsonErr{
                print("Error ",jsonErr)
            }
            
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

