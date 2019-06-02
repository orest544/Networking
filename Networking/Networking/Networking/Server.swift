//
//  Server.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 1/14/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

protocol ServerInterface {
    var scheme: ServerScheme { get }
    var host: String { get }
}

enum ServerScheme: String {
    case http
    case https
}

struct Server: ServerInterface {
    var scheme: ServerScheme
    var host: String

    private init(scheme: ServerScheme, host: String) {
        self.scheme = scheme
        self.host = host
    }

    private init (_ server: ServerInterface) {
        self.init(scheme: server.scheme,
                  host: server.host)
    }
}


// Client

// Helpfull extension
extension Server {
    static var currencyServer: Server {
        return .init(CurrencyServer())
    }
    
    static var afServer: Server {
        return .init(AFServer())
    }
    
    static var googleAPIsServer: Server {
        return .init(GoogleAPIsServer())
    }
    
//    static var test: Server {
//        return .init(TestServer())
//    }
}

// Separate struct for each Server
struct CurrencyServer: ServerInterface {
    var scheme: ServerScheme {
        return .https
    }
    
    var host: String {
        return "bank.gov.ua"
    }
}

struct AFServer: ServerInterface {
    var scheme: ServerScheme {
        return .https
    }
    
    var host: String {
        return "afprodenv.airefresco.co" // PROD
        // return "aftestenv.airefresco.co" // TEST
        // return "airfresko.tk" // DEV
    }
}

struct GoogleAPIsServer: ServerInterface {
    var scheme: ServerScheme {
        return .https
    }
    
    var host: String {
        return "maps.googleapis.com"
    }
}

struct NervyServer: ServerInterface {
    var scheme: ServerScheme {
        return .http
    }
    
    var host: String {
        return "ec2-35-156-108-213.eu-central-1.compute.amazonaws.com"
    }
}

extension Server {
    static var nervy: Server {
        return .init(NervyServer())
    }
}

//struct TestServer: ServerInterface {
//    var scheme: ServerScheme {
//        return .https
//    }
//
//    var host: String {
//        return "test.com"
//    }
//}
