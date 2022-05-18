import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWitchError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=13743cc924d5c0f3a7abc0bbab6322f7&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequesrt(with: urlString)
    }
    
    func fechWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequesrt(with: urlString)
    }

    func performRequesrt(with urlString: String){
        // 1. Create URL
        if let url = URL(string: urlString){
            // 2. Create URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url){ (data, response, error) in
                
                if error != nil{
                    delegate?.didFailWitchError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decorder = JSONDecoder()
        do {
            let decordedData = try decorder.decode(WeatherData.self, from: weatherData)
            let id = decordedData.weather[0].id
            let temp = decordedData.main.temp
            let name = decordedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
        }
        catch{
            delegate?.didFailWitchError(error: error)
            return nil
        }
       
    }

    }

