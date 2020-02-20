class About < ApplicationRecord

  include ActiveModel::Model
  
  # ローンシミュレーションのための変数定義
  attr_accessor :debtBalance, :annualInterestRate, :numberOfPayments

  # タックスシミュレーションのための変数定義
  ## 所得控除
  attr_accessor :miscellaneousDeduction,
    :medicalExpensesDeduction, 
    :socialInsurancePremiumDeduction, 
    :creditDeductionForSmallBusinessMutualAid, 
    :lifeInsuranceDeduction, 
    :earthquakeInsuranceDeduction,
    :donationDeduction, 
    :disabledPersonDeduction, 
    :widowDeduction, 
    :workingStudentDeduction,
    :spouseDeduction, 
    :spouseSpecialDeduction, 
    :dependentDeduction, 
    :basicDeduction

  ## 税額計算
  attr_accessor :taxCredit, :withholdingTaxAmount, :estimatedTaxPaymentAmount

  ## 給与所得計算
  attr_accessor :salaryIncome

  ## 事業所得計算
  attr_accessor :amountOfSales, :otherIncomeBI, :costOfSales, :otherExpensesBI

  ## 不動産所得計算
  attr_accessor :rent, :otherIncomeREI, :borrowingInterest, :depreciation, :otherExpensesREI

  ## 青色申告特別控除額
  attr_accessor :blueTaxReturnSpecialDeductionREI
  
  validates :debtBalance, 
  :annualInterestRate, 
  :numberOfPayments, 
  :miscellaneousDeduction, 
  :medicalExpensesDeduction, 
  :socialInsurancePremiumDeduction, 
  :creditDeductionForSmallBusinessMutualAid, 
  :lifeInsuranceDeduction, 
  :earthquakeInsuranceDeduction,
  :donationDeduction, 
  :disabledPersonDeduction, 
  :widowDeduction, 
  :workingStudentDeduction,
  :spouseDeduction, 
  :spouseSpecialDeduction, 
  :dependentDeduction, 
  :basicDeduction,
  :taxCredit, 
  :withholdingTaxAmount, 
  :estimatedTaxPaymentAmount,
  :salaryIncome,
  :amountOfSales, 
  :otherIncomeBI, 
  :costOfSales, 
  :otherExpensesBI,
  :rent, 
  :otherIncomeREI, 
  :borrowingInterest, 
  :depreciation, 
  :otherExpensesREI,
  :blueTaxReturnSpecialDeductionREI,  presence: true

end
