//
//  MapView.swift
//  MapMonitoring
//
//  Created by Tabassum Akter Nusrat on 23/7/25.
//
import Foundation
import SwiftUI
import MapKit

enum MapPurPose {
    case profile
    case donationPickup
}

struct MapView: View {
    
    @State var mapPurPose: MapPurPose
    @State private var selectedDetent: PresentationDetent = .fraction(0.15)
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    @StateObject private var searchViewModel = MapSearchViewModel()
    var profileViewModel: ProfileViewModel? = nil
    var donationViewModel: PostFoodViewModel? = nil
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Map(position: $position) {
              
                ForEach(searchViewModel.filteredResults, id: \.place_id) { place in
                    Marker(place.display_name, coordinate: place.coordinate)
                }

                UserAnnotation()
            }
            .onChange(of: locationManager.region) { newRegion in
                           withAnimation {
                               position = .region(newRegion)
                           }
                       }
            .sheet(isPresented: .constant(true), content: {
                VStack {
                    TextField("Search", text: $searchViewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    if searchViewModel.isSearching {
                                            ProgressView()
                                                .padding(.bottom)
                                        }
                                        
                    List(searchViewModel.filteredResults, id: \.place_id) { place in
                        VStack(alignment: .leading) {
                            Text(place.display_name)
                                .font(.headline)
                            Text("Lat: \(place.lat), Lon: \(place.lon)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            let coordinate = place.coordinate
                            position = .region(MKCoordinateRegion(center: coordinate,
                                                                  span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                            selectedDetent = .fraction(0.15)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // dismissKeyboard
                            
                            switch mapPurPose {
                            case .profile:
                                if let profileVM = profileViewModel {
                                    profileVM.location = Location(lat: coordinate.latitude, lng: coordinate.longitude)
                                    profileVM.displayName = place.display_name
                                }
                            case .donationPickup:
                                if let donationVM = donationViewModel {
                                    donationVM.location = Location(lat: coordinate.latitude, lng: coordinate.longitude)
                                    donationVM.locationdisplayName = place.display_name
                                }
                            }

                            dismiss()
                        }
                    }

                    
                    Spacer()
                }
                .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            })
        }.onMapCameraChange {context in
            visibleRegion = context.region
        }
        .onAppear {
            locationManager.requestPermission()
        }
        
    }
}

#Preview {
    //MapView()
}
