import Foundation

extension String {
    func localised() -> String {
        NSLocalizedString(self,
                          tableName: "Localizable",
                          value: self,
                          comment: self)
    }
}
