class AboutController < ApplicationController

  def show
    @number = params[:id]
    @about = About.new
  end

  def result3
    @debtSimulation = debtSimulation
  end

  def result1
    @taxSimulation1  = taxSimulation[0]
    @taxSimulation2  = taxSimulation[1]
    @taxSimulation3  = taxSimulation[2]
    @taxSimulation4  = taxSimulation[3]
    @taxSimulation5  = taxSimulation[4]
    @taxSimulation6  = taxSimulation[5]
    @taxSimulation7  = taxSimulation[6]
  end


  # -Algorithm（借入金返済シミュレーション）--------------------------------------------
  def debtSimulation
    require 'bigdecimal'
    about                    = params[:about].permit(:debtBalance, :annualInterestRate, :numberOfPayments)
    debtBalance              = about[:debtBalance].to_i * 1000
    annualInterestRate       = about[:annualInterestRate].to_f / 100
    numberOfPayments         = about[:numberOfPayments].to_i

    monthlyInterestRate      = BigDecimal((annualInterestRate/12).to_s).ceil(8).to_f
    interimCalcA             = BigDecimal(((1 + monthlyInterestRate)**numberOfPayments).to_s).floor(8).to_f
    interimCalcB             = BigDecimal((monthlyInterestRate * interimCalcA).to_s).floor(8).to_f
    monthlyRepayment         = BigDecimal(((interimCalcB/(interimCalcA-1))*debtBalance).to_s).floor(0).to_i
    annualRepayment          = monthlyRepayment*12
    totalRepayment           = monthlyRepayment*numberOfPayments
    totalInterst             = totalRepayment-debtBalance

    howManyTimes             = 1
    debtBalanceAtThisMonth   = debtBalance
    debtSimulationResults    = [
      debtBalance:debtBalance,
      annualInterestRate:annualInterestRate,
      numberOfPayments:numberOfPayments,
      monthlyInterestRate:monthlyInterestRate,
      monthlyRepayment:monthlyRepayment,
      annualRepayment:annualRepayment,
      totalRepayment:totalRepayment,
      totalInterst:totalInterst
    ]
    while howManyTimes <= numberOfPayments do
    
      if howManyTimes == numberOfPayments
        interestOfThisMonth    = BigDecimal((debtBalanceAtThisMonth * monthlyInterestRate).to_s).floor(0).to_i
        principalOfThisMonth   = debtBalanceAtThisMonth
        debtBalanceAtThisMonth = debtBalanceAtThisMonth - principalOfThisMonth
        monthlyRepayment       = interestOfThisMonth + principalOfThisMonth
      else
        interestOfThisMonth    = BigDecimal((debtBalanceAtThisMonth * monthlyInterestRate).to_s).floor(0).to_i
        principalOfThisMonth   = monthlyRepayment - interestOfThisMonth
        debtBalanceAtThisMonth = debtBalanceAtThisMonth - principalOfThisMonth
      end
      debtSimulationResult = { 
        howManyTimes:howManyTimes,
        monthlyRepayment:monthlyRepayment,
        interestOfThisMonth:interestOfThisMonth,
        principalOfThisMonth:principalOfThisMonth,
        debtBalanceAtThisMonth:debtBalanceAtThisMonth
      }

      debtSimulationResults << debtSimulationResult
      howManyTimes += 1
    end
    return debtSimulationResults
  end


  # -Algorithm（税金シミュレーション）-------------------------------------------------
  
  def taxSimulation # 確定申告額
    about = params.require(:about).permit(
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
      :blueTaxReturnSpecialDeductionREI,
      :taxCredit, 
      :withholdingTaxAmount, 
      :estimatedTaxPaymentAmount,
    )
    # salaryIncome                              = about[:salaryIncome].to_i
    # amountOfSales                             = about[:amountOfSales].to_i
    # otherIncomeBI                             = about[:otherIncomeBI].to_i
    # costOfSales                               = about[:costOfSales].to_i
    # otherExpensesBI                           = about[:otherExpensesBI].to_i
    # rent                                      = about[:rent].to_i
    # otherIncomeREI                            = about[:otherIncomeREI].to_i
    # borrowingInterest                         = about[:borrowingInterest].to_i
    # depreciation                              = about[:depreciation].to_i
    # otherExpensesREI                          = about[:otherExpensesREI].to_i
    # miscellaneousDeduction                    = about[:miscellaneousDeduction].to_i
    # medicalExpensesDeduction                  = about[:medicalExpensesDeduction].to_i
    # socialInsurancePremiumDeduction           = about[:socialInsurancePremiumDeduction].to_i
    # creditDeductionForSmallBusinessMutualAid  = about[:creditDeductionForSmallBusinessMutualAid].to_i
    # lifeInsuranceDeduction                    = about[:lifeInsuranceDeduction].to_i
    # earthquakeInsuranceDeduction              = about[:earthquakeInsuranceDeduction].to_i
    # donationDeduction                         = about[:donationDeduction].to_i
    # disabledPersonDeduction                   = about[:disabledPersonDeduction].to_i
    # widowDeduction                            = about[:widowDeduction].to_i
    # workingStudentDeduction                   = about[:workingStudentDeduction].to_i
    # spouseDeduction                           = about[:spouseDeduction].to_i
    # spouseSpecialDeduction                    = about[:spouseSpecialDeduction].to_i
    # dependentDeduction                        = about[:dependentDeduction].to_i
    # basicDeduction                            = about[:basicDeduction].to_i
    # blueTaxReturnSpecialDeductionREI          = about[:blueTaxReturnSpecialDeductionREI].to_i
    # taxCredit                                 = about[:taxCredit].to_i
    # withholdingTaxAmount                      = about[:withholdingTaxAmount].to_i
    # estimatedTaxPaymentAmount                 = about[:estimatedTaxPaymentAmount].to_i
  
  # kari
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
  miscellaneousDeduction                    = 10000
  medicalExpensesDeduction                  = 20000
  socialInsurancePremiumDeduction           = 500000
  creditDeductionForSmallBusinessMutualAid  = 30000
  lifeInsuranceDeduction                    = 15000
  earthquakeInsuranceDeduction              = 10000
  donationDeduction                         = 20000
  disabledPersonDeduction                   = 30000
  widowDeduction                            = 40000
  workingStudentDeduction                   = 20000
  spouseDeduction                           = 60000
  spouseSpecialDeduction                    = 50000
  dependentDeduction                        = 300000
  basicDeduction                            = 650000
  blueTaxReturnSpecialDeductionREI          = 650000
  taxCredit                                 = 100000
  withholdingTaxAmount                      = 600000
  estimatedTaxPaymentAmount                 = 100000
  # kari
    
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

    taxSimulation = [
      [employmentIncome,businessIncome,realEstateIncome,incomeDeductionArray],
      [
        [0,1950000,3300000,6950000,9000000,18000000,40000000,50000000],
        [calculatedTaxAmount(0),calculatedTaxAmount(1950000),calculatedTaxAmount(3300000),calculatedTaxAmount(6950000),calculatedTaxAmount(9000000),calculatedTaxAmount(18000000),calculatedTaxAmount(40000000),calculatedTaxAmount(50000000)]
      ],
      [calculatedTaxAmount, taxCredit, withholdingTaxAmount, estimatedTaxPaymentAmount],
      [
        [salaryIncome,grossIncomeBI(amountOfSales,otherIncomeBI),grossIncomeREI(rent,otherIncomeREI)],
        [employmentIncomeDeduction(salaryIncome),requiredExpensesBI(costOfSales,otherExpensesBI),requiredExpensesREI(borrowingInterest,depreciation,otherExpensesREI)],
        [employmentIncome,businessIncome,realEstateIncome]
      ],
      incomeDeductionArray,
      [taxCredit,withholdingTaxAmount,estimatedTaxPaymentAmount],
      [taxStandard.to_i,(calculatedTaxAmount-taxCredit).to_i,((calculatedTaxAmount-taxCredit)*100/taxStandard).to_i]
    ]
    
  end
  
end
