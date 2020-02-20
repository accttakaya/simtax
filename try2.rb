def thirdTaxPaymentAmount # 確定申告額
  salaryIncome                              = 10000000
  amountOfSales                             = 10000000
  otherIncomeBI                             = 2000000
  costOfSales                               = 6000000
  otherExpensesBI                           = 3000000
  rent                                      = 5000000
  otherIncomeREI                            = 1000000
  borrowingInterest                         = 1000000
  depreciation                              = 2000000
  otherExpensesREI                          = 500000
  miscellaneousDeduction                    = 0
  medicalExpensesDeduction                  = 0
  socialInsurancePremiumDeduction           = 500000
  creditDeductionForSmallBusinessMutualAid  = 0
  lifeInsuranceDeduction                    = 0
  earthquakeInsuranceDeduction              = 0
  donationDeduction                         = 0
  disabledPersonDeduction                   = 0
  widowDeduction                            = 0
  workingStudentDeduction                   = 0
  spouseDeduction                           = 0
  spouseSpecialDeduction                    = 0
  dependentDeduction                        = 0
  basicDeduction                            = 650000
  blueTaxReturnSpecialDeductionREI          = 650000
  taxCredit                                 = 0
  withholdingTaxAmount                      = 600000
  estimatedTaxPaymentAmount                 = 0

  incomeDeductionArray = [
    miscellaneousDeduction,
    medicalExpensesDeduction,
    socialInsurancePremiumDeduction,
    creditDeductionForSmallBusinessMutualAid,
    lifeInsuranceDeduction,
    earthquakeInsuranceDeduction,
    donationDeduction,
    disabledPersonDeduction,
    widowDeduction,
    workingStudentDeduction,
    spouseDeduction,
    spouseSpecialDeduction,
    dependentDeduction,
    basicDeduction,
  ]
  
  # ----------------給与所得の計算----------------
  def employmentIncome(salaryIncome)
    def employmentIncomeDeduction(salaryIncome) #給与所得控除
      if salaryIncome <= 1800000
        if salaryIncome * 0.4 <= 650000
          650000
        else
          salaryIncome * 0.4
        end
      elsif salaryIncome <= 3600000
        (salaryIncome - 1800000)* 0.3 + 720000
      elsif salaryIncome <= 6600000
        (salaryIncome - 3600000)* 0.2 + 1260000
      elsif salaryIncome <= 10000000
        (salaryIncome - 6600000)* 0.1 + 1860000
      else
        2200000
      end
    end
    salaryIncome - employmentIncomeDeduction(salaryIncome)
  end
  employmentIncome = employmentIncome(salaryIncome)


  # ----------------不動産所得の計算----------------
  def realEstateIncome(rent,otherIncomeREI,borrowingInterest,depreciation,otherExpensesREI)
    def grossIncomeREI(rent,otherIncomeREI)
      rent + otherIncomeREI
    end

    def requiredExpensesREI(borrowingInterest,depreciation,otherExpensesREI)
      borrowingInterest + depreciation + otherExpensesREI
    end

    grossIncomeREI(rent,otherIncomeREI) - requiredExpensesREI(borrowingInterest,depreciation,otherExpensesREI)
  end
  realEstateIncome = realEstateIncome(rent,otherIncomeREI,borrowingInterest,depreciation,otherExpensesREI)

  ## 青色申告特別控除
  if realEstateIncome >= blueTaxReturnSpecialDeductionREI
    blueTaxReturnSpecialDeductionBI = 0
    realEstateIncome -= blueTaxReturnSpecialDeductionREI
  elsif realEstateIncome <= blueTaxReturnSpecialDeductionREI && realEstateIncome >= 0
    blueTaxReturnSpecialDeductionBI = blueTaxReturnSpecialDeductionREI - realEstateIncome
    realEstateIncome = 0
  else
    blueTaxReturnSpecialDeductionBI = blueTaxReturnSpecialDeductionREI
    realEstateIncome
  end
    
  # ----------------事業所得の計算----------------
  def businessIncome(amountOfSales,otherIncomeBI,costOfSales,otherExpensesBI)
    def grossIncomeBI(amountOfSales,otherIncomeBI)
      amountOfSales + otherIncomeBI
    end
    def requiredExpensesBI(costOfSales,otherExpensesBI)
      costOfSales + otherExpensesBI
    end
    grossIncomeBI(amountOfSales,otherIncomeBI) - requiredExpensesBI(costOfSales,otherExpensesBI)
  end
  businessIncome = businessIncome(amountOfSales,otherIncomeBI,costOfSales,otherExpensesBI)

  ## 青色申告特別控除
  if businessIncome >= blueTaxReturnSpecialDeductionBI
    businessIncome -= blueTaxReturnSpecialDeductionBI
  elsif businessIncome <= blueTaxReturnSpecialDeductionBI && businessIncome >= 0
    businessIncome = 0
  else
    businessIncome
  end
  
  # ----------------税額の計算----------------
  taxStandard     = employmentIncome + businessIncome + realEstateIncome    #課税標準（総所得金額）
  incomeDeduction = 0                                                       #所得控除
  incomeDeductionArray.each do |factor|
    incomeDeduction += factor
  end
  taxableIncome = taxStandard - incomeDeduction                             #課税所得金額（千円未満切捨）

  def calculatedTaxAmount(taxableIncome)                                    #算出税額
    if taxableIncome <=  1950000
      taxableIncome * 0.05
    elsif taxableIncome <= 3300000
      taxableIncome * 0.1 - 97500
    elsif taxableIncome <= 6950000
      taxableIncome * 0.2 - 427500
    elsif taxableIncome <= 9000000
      taxableIncome * 0.23 - 636000
    elsif taxableIncome <= 18000000
      taxableIncome * 0.33 - 1536000
    elsif taxableIncome <= 40000000
      taxableIncome * 0.4 - 2796000
    else
      taxableIncome * 0.45 - 4796000
    end
  end
  calculatedTaxAmount = calculatedTaxAmount(taxableIncome)

  taxPaymentAmount = calculatedTaxAmount - taxCredit - withholdingTaxAmount  # 申告納税額（百円未満切捨）
  thirdTaxPaymentAmount = taxPaymentAmount - estimatedTaxPaymentAmount       # 確定申告額（百円未満切捨）
end


puts thirdTaxPaymentAmount