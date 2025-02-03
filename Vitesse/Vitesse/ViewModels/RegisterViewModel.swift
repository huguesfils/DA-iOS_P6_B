//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Hugues Fils Caparos on 03/02/2025.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
}
