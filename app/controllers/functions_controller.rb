

class FunctionsController < ApplicationController
  def index
  end

  def show
    @number = params[:id]
    @function = Function.new
  end


  def result
    @debtSimulation = debtSimulation
  end


  # -Algorithm--------------------------------------------
  def debtSimulation
    require 'bigdecimal'
    function                 = params[:function].permit(:debtBalance, :annualInterestRate, :numberOfPayments)
    debtBalance              = function[:debtBalance].to_i * 1000
    annualInterestRate       = function[:annualInterestRate].to_f / 100
    numberOfPayments         = function[:numberOfPayments].to_i

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
end


