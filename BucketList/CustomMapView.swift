//
//  CustomMapView.swift
//  BucketList
//
//  Created by Vladimir on 02.07.2021.
//

import SwiftUI
import MapKit

struct CustomMapView: View {
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetail = false
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            
        MapView(selectedPlace: $selectedPlace, showingPlaceDetail: $showingPlaceDetail, centerCoordinate: $centerCoordinate, annotations: locations)
            .edgesIgnoringSafeArea(.all)
        
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    
                    let newLocation = CodableMKPointAnnotation()
                    newLocation.coordinate = self.centerCoordinate
                    newLocation.title = "Example location"
                    newLocation.subtitle = "Example description"
                    self.locations.append(newLocation)
                    
                    self.selectedPlace = newLocation
                    self.showingEditScreen = true
                    
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                }
            }
        }
        .alert(isPresented: $showingPlaceDetail) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                self.showingEditScreen = true
            } )
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
        
    }
    
    }

    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
            
        } catch {
            print("Unable to load saved data")
        }
    }
    
    func saveData() {
        do {
            let filename = getDocumentDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}


