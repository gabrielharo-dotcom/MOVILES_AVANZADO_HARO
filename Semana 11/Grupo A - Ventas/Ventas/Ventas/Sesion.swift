//
//  Sesion.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import Foundation
import CoreData

class Sesion {
    static let shared = Sesion()

    var usuario: Usuario?

    var esSupervisor: Bool {
        usuario?.rol == "Supervisor"
    }

    private init() {}
}
