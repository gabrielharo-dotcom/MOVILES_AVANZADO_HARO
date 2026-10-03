import Foundation

struct LoanResult {
    let monthlyPayment: Double
    let totalPayment: Double
}

enum LoanCalculator {
    static func calculate(principal: Double, annualRatePercent: Double, years: Int) -> LoanResult? {
        guard principal.isFinite, principal > 0,
              annualRatePercent.isFinite, annualRatePercent >= 0,
              years > 0 else { return nil }

        let (months, overflow) = years.multipliedReportingOverflow(by: 12)
        guard !overflow else { return nil }

        let monthlyRate = annualRatePercent / 100 / 12
        let monthlyPayment: Double
        if monthlyRate == 0 {
            monthlyPayment = principal / Double(months)
        } else {
            // Forma equivalente a P × r(1+r)^n / ((1+r)^n - 1).
            let denominator = 1 - pow(1 + monthlyRate, -Double(months))
            guard denominator > 0 else { return nil }
            monthlyPayment = principal * monthlyRate / denominator
        }

        let totalPayment = monthlyPayment * Double(months)
        guard monthlyPayment.isFinite, totalPayment.isFinite else { return nil }
        return LoanResult(monthlyPayment: monthlyPayment, totalPayment: totalPayment)
    }
}
