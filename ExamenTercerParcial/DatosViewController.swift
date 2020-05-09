//
//  DatosViewController.swift
//  ExamenTercerParcial
//
//  Created by Noel Aguilera Terrazas on 09/05/20.
//  Copyright © 2020 Daniel Aguilera. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import CoreLocation

class DatosViewController: UIViewController, CLLocationManagerDelegate {
    
    var datos :DatosElement?
    let locationManager = CLLocationManager() // create Location Manager object
    
    @IBOutlet weak var imageSangre: UIImageView!
    @IBOutlet weak var lblSangre: UILabel!
    @IBOutlet weak var lblDireccion: UILabel!
    @IBOutlet weak var lblLong: UILabel!
    @IBOutlet weak var lblLat: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblApellidos: UILabel!
    @IBOutlet weak var imguser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleVisibility(status: true)
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("suh");
        AF.request("https://www.mocky.io/v2/5eb714a93100006a00c8a10f")
            .validate()
            .responseDecodable(of: DatosElement.self) { (response) in
                guard let datosElements = response.value else {
                    print(response)
                    return
                }
                DispatchQueue.main.async {
                    self.toggleVisibility(status: false)
                    self.lblNombre.text = datosElements.nombre;
                    self.lblApellidos.text = (datosElements.apellidoPaterno ?? "N/A") + " " + (datosElements.apellidoMaterno ?? "N/A")
                    let urlImage = URL(string: datosElements.imagen!)
                    self.imguser.kf.setImage(with: urlImage)
                    self.lblDireccion.text = datosElements.direccion
                    self.lblSangre.text = datosElements.tipoSangre
                    switch datosElements.tipoSangre{
                    case let str where str!.contains("AB"):
                        self.imageSangre.tintColor = UIColor.black
                        break
                    case let str where str!.contains("A"):
                        self.imageSangre.tintColor = UIColor.blue
                        break
                    case let str where str!.contains("B"):
                        self.imageSangre.tintColor = UIColor.green
                        break
                    case let str where str!.contains("O"):
                        self.imageSangre.tintColor = UIColor.red
                        break
                    case .none:
                        self.imageSangre.tintColor = UIColor.gray
                    case .some(_):
                        self.imageSangre.tintColor = UIColor.gray
                    }
                }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lblLat.text = String(format:"%f", location.latitude)
        self.lblLong.text = String(format:"%f", location.longitude)
    }

    
    func toggleVisibility(status: Bool) {
        lblNombre.isHidden = status
        lblApellidos.isHidden = status
        lblDireccion.isHidden = status
        lblLat.isHidden = status
        lblLong.isHidden = status
        lblSangre.isHidden = status
        imageSangre.isHidden = status
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
