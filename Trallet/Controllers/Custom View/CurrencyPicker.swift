//
//  CurrencyPicker.swift
//  Trallet
//
//  Created by Nicholas on 30/04/21.
//

import UIKit

class CurrencyPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Currency Dictionary
    let currencyDict: [String: String] = [
        "AED":"United Arab Emirates Dirham",
        "AFN":"Afghan Afghani",
        "ALL":"Albanian Lek",
        "AMD":"Armenian Dram",
        "ANG":"Netherlands Antillean Guilder",
        "AOA":"Angolan Kwanza",
        "ARS":"Argentine Peso",
        "AUD":"Australian Dollar",
        "AWG":"Aruban Florin",
        "AZN":"Azerbaijani Manat",
        "BAM":"Bosnia-Herzegovina Convertible Mark",
        "BBD":"Barbadian Dollar",
        "BDT":"Bangladeshi Taka",
        "BGN":"Bulgarian Lev",
        "BHD":"Bahraini Dinar",
        "BIF":"Burundian Franc",
        "BMD":"Bermudan Dollar",
        "BND":"Brunei Dollar",
        "BOB":"Bolivian Boliviano",
        "BRL":"Brazilian Real",
        "BSD":"Bahamian Dollar",
        "BTN":"Bhutanese Ngultrum",
        "BWP":"Botswanan Pula",
        "BYN":"New Belarusian Ruble",
        "BZD":"Belize Dollar",
        "CAD":"Canadian Dollar",
        "CDF":"Congolese Franc",
        "CHF":"Swiss Franc",
        "CLF":"Chilean Unit of Account (UF)",
        "CLP":"Chilean Peso",
        "CNY":"Chinese Yuan",
        "COP":"Colombian Peso",
        "CRC":"Costa Rican Colón",
        "CUC":"Cuban Convertible Peso",
        "CUP":"Cuban Peso",
        "CVE":"Cape Verdean Escudo",
        "CZK":"Czech Republic Koruna",
        "DJF":"Djiboutian Franc",
        "DKK":"Danish Krone",
        "DOP":"Dominican Peso",
        "DZD":"Algerian Dinar",
        "EGP":"Egyptian Pound",
        "ERN":"Eritrean Nakfa",
        "ETB":"Ethiopian Birr",
        "EUR":"Euro",
        "FJD":"Fijian Dollar",
        "FKP":"Falkland Islands Pound",
        "GBP":"British Pound Sterling",
        "GEL":"Georgian Lari",
        "GGP":"Guernsey Pound",
        "GHS":"Ghanaian Cedi",
        "GIP":"Gibraltar Pound",
        "GMD":"Gambian Dalasi",
        "GNF":"Guinean Franc",
        "GTQ":"Guatemalan Quetzal",
        "GYD":"Guyanaese Dollar",
        "HKD":"Hong Kong Dollar",
        "HNL":"Honduran Lempira",
        "HRK":"Croatian Kuna",
        "HTG":"Haitian Gourde",
        "HUF":"Hungarian Forint",
        "IDR":"Indonesian Rupiah",
        "ILS":"Israeli New Sheqel",
        "IMP":"Manx pound",
        "INR":"Indian Rupee",
        "IQD":"Iraqi Dinar",
        "IRR":"Iranian Rial",
        "ISK":"Icelandic Króna",
        "JMD":"Jamaican Dollar",
        "JOD":"Jordanian Dinar",
        "JPY":"Japanese Yen",
        "KES":"Kenyan Shilling",
        "KGS":"Kyrgystani Som",
        "KHR":"Cambodian Riel",
        "KMF":"Comorian Franc",
        "KRW":"South Korean Won",
        "KWD":"Kuwaiti Dinar",
        "KYD":"Cayman Islands Dollar",
        "KZT":"Kazakhstani Tenge",
        "LAK":"Laotian Kip",
        "LBP":"Lebanese Pound",
        "LKR":"Sri Lankan Rupee",
        "LRD":"Liberian Dollar",
        "LSL":"Lesotho Loti",
        "LTL":"Lithuanian Litas",
        "LVL":"Latvian Lats",
        "LYD":"Libyan Dinar",
        "MAD":"Moroccan Dirham",
        "MDL":"Moldovan Leu",
        "MGA":"Malagasy Ariary",
        "MKD":"Macedonian Denar",
        "MMK":"Myanma Kyat",
        "MNT":"Mongolian Tugrik",
        "MOP":"Macanese Pataca",
        "MRO":"Mauritanian Ouguiya",
        "MUR":"Mauritian Rupee",
        "MVR":"Maldivian Rufiyaa",
        "MWK":"Malawian Kwacha",
        "MXN":"Mexican Peso",
        "MYR":"Malaysian Ringgit",
        "MZN":"Mozambican Metical",
        "NAD":"Namibian Dollar",
        "NGN":"Nigerian Naira",
        "NIO":"Nicaraguan Córdoba",
        "NOK":"Norwegian Krone",
        "NPR":"Nepalese Rupee",
        "NZD":"New Zealand Dollar",
        "OMR":"Omani Rial",
        "PAB":"Panamanian Balboa",
        "PEN":"Peruvian Nuevo Sol",
        "PGK":"Papua New Guinean Kina",
        "PHP":"Philippine Peso",
        "PKR":"Pakistani Rupee",
        "PLN":"Polish Zloty",
        "PYG":"Paraguayan Guarani",
        "QAR":"Qatari Rial",
        "RON":"Romanian Leu",
        "RSD":"Serbian Dinar",
        "RUB":"Russian Ruble",
        "RWF":"Rwandan Franc",
        "SAR":"Saudi Riyal",
        "SBD":"Solomon Islands Dollar",
        "SCR":"Seychellois Rupee",
        "SDG":"Sudanese Pound",
        "SEK":"Swedish Krona",
        "SGD":"Singapore Dollar",
        "SHP":"Saint Helena Pound",
        "SLL":"Sierra Leonean Leone",
        "SOS":"Somali Shilling",
        "SRD":"Surinamese Dollar",
        "STD":"São Tomé and Príncipe Dobra",
        "SVC":"Salvadoran Colón",
        "SYP":"Syrian Pound",
        "SZL":"Swazi Lilangeni",
        "THB":"Thai Baht",
        "TJS":"Tajikistani Somoni",
        "TMT":"Turkmenistani Manat",
        "TND":"Tunisian Dinar",
        "TOP":"Tongan Pa\'anga",
        "TRY":"Turkish Lira",
        "TTD":"Trinidad and Tobago Dollar",
        "TWD":"New Taiwan Dollar",
        "TZS":"Tanzanian Shilling",
        "UAH":"Ukrainian Hryvnia",
        "UGX":"Ugandan Shilling",
        "USD":"United States Dollar",
        "UYU":"Uruguayan Peso",
        "UZS":"Uzbekistan Som",
        "VEF":"Venezuelan Bolívar Fuerte",
        "VND":"Vietnamese Dong",
        "VUV":"Vanuatu Vatu",
        "WST":"Samoan Tala",
        "XAF":"CFA Franc BEAC",
        "XCD":"East Caribbean Dollar",
        "XDR":"Special Drawing Rights",
        "XOF":"CFA Franc BCEAO",
        "XPF":"CFP Franc",
        "YER":"Yemeni Rial",
        "ZAR":"South African Rand",
        "ZMW":"Zambian Kwacha"
    ]
    
    public var currencyDelegate: CurrencyPickerDelegate? {
        didSet {
            arrCurrency = Array(currencyDict)
            arrCurrency.sort { leftKey, rightKey in
                return leftKey.key < rightKey.key
            }
        }
    }
    
    var arrCurrency: [Dictionary<String, String>.Element]!
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCurrency.count + 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "-- Currency --"
        default:
            return "\(arrCurrency[row-1].key) - \(arrCurrency[row-1].value)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let safeDelegate = currencyDelegate {
            let selectedCode = row == 0 ? "" : arrCurrency[row-1].key 
            safeDelegate.pickerDidSelectRow(selected: selectedCode)
        }
    }
}

protocol CurrencyPickerDelegate {
    func pickerDidSelectRow(selected currencyCode: String)
}
