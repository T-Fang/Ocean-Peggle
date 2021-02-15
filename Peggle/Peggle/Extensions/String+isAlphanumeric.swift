//
//  String+isAlphanumeric.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

extension String {
    func isAlphanumeric() -> Bool {
        !isEmpty && range(of: "[^a-zA-Z0-9]",
                          options: .regularExpression) == nil
    }
}
