//
//  Curso.swift
//  apple_lab11_02_SwiftUI_SwiftData
//
//  Created by Tecsup on 5/11/26.
//

import Foundation
import SwiftData

@Model
class Curso {
    var nombre: String

    @Relationship(deleteRule: .nullify, inverse: \Alumno.curso)
    var alumnos: [Alumno] = []

    init(nombre: String) {
        self.nombre = nombre
    }
}
