//
//  ContentView.swift
//  apple_lab11_02_SwiftUI_SwiftData
//
//  Created by Tecsup on 5/11/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]

    @State private var alumnoSeleccionado: Alumno?
    @State private var mostrarFormulario = false
    @State private var alumnoAEditar: Alumno?
    @State private var busqueda = ""

    private var alumnosFiltrados: [Alumno] {
        if busqueda.isEmpty {
            return alumnos
        }

        return alumnos.filter {
            $0.apellido.localizedCaseInsensitiveContains(busqueda)
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $alumnoSeleccionado) {
                ForEach(alumnosFiltrados) { alumno in
                    NavigationLink(value: alumno) {
                        VStack(alignment: .leading) {
                            Text("\(alumno.apellido), \(alumno.nombre)")
                                .font(.headline)

                            Text("DNI: \(alumno.dni)")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteAlumnos)
            }
            .searchable(text: $busqueda, prompt: "Buscar por apellido")
            .navigationTitle("Alumnos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }

                ToolbarItem {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                }

                ToolbarItem {
                    Button {
                        asignarCursoDemo()
                    } label: {
                        Label("Curso demo", systemImage: "book")
                    }
                }
            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Detalles del Alumno")
                        .font(.title2)

                    Text("Nombre: \(alumno.nombre)")
                    Text("Apellido: \(alumno.apellido)")
                    Text("DNI: \(alumno.dni)")
                    Text("Curso: \(alumno.curso?.nombre ?? "Sin curso")")

                    Button("Editar") {
                        alumnoAEditar = alumno
                    }
                }
                .padding()
            } else {
                Text("Selecciona un alumno")
            }
        }
        .sheet(isPresented: $mostrarFormulario) {
            NuevoAlumnoView()
        }
        .sheet(item: $alumnoAEditar) { alumno in
            EditarAlumnoView(alumno: alumno)
        }
    }

    private func deleteAlumnos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let alumno = alumnosFiltrados[index]

                if alumnoSeleccionado == alumno {
                    alumnoSeleccionado = nil
                }

                modelContext.delete(alumno)
            }
        }
    }

    private func asignarCursoDemo() {
        let curso = Curso(nombre: "Programación en Móviles")
        modelContext.insert(curso)

        for alumno in alumnos {
            alumno.curso = curso
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
