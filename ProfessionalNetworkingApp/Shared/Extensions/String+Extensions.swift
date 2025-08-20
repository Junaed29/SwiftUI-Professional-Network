// String+Extensions.swift

import Foundation

extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }

    var isValidPhone: Bool {
        let digits = self.filter { $0.isNumber }
        return digits.count >= 10 && digits.count <= 15
    }
}
