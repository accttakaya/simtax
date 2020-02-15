require 'bigdecimal'

def debtSimulation(params)
  puts "借入額を千円単位で入力してください。(入力可能範囲：10,000千円〜1,000,000千円)"
  debtBalance          = gets.chomp.to_i * 1000
  while debtBalance < 10000000 || debtBalance > 1000000000 do
    puts "もう一度正しく入力してください。(入力可能範囲：10,000千円〜1,000,000千円)"
    debtBalance        = gets.chomp.to_i * 1000
  end

  puts "金利（年利）を％で入力してください。(入力可能範囲：0.1%〜10.0%)"
  annualInterestRate   = (gets.chomp.to_f) / 100
  while annualInterestRate < 0.001 || annualInterestRate > 0.1 do
    puts "もう一度正しく入力してください。(入力可能範囲：0.1%〜10.0%)"
    annualInterestRate = (gets.chomp.to_f) / 100
  end
  
  
  puts "返済回数（毎月1回返済）を入力してください。（入力可能範囲：12回（1年）〜600回（50年）)"
  numberOfPayments     = gets.chomp.to_i
  while numberOfPayments < 12 || numberOfPayments > 600
    puts "もう一度正しく入力してください。(入力可能範囲：12回（1年）〜600回（50年）)"
    numberOfPayments   = gets.chomp.to_i
  end


  monthlyInterestRate  = BigDecimal((annualInterestRate/12).to_s).ceil(8).to_f
  puts "月利:#{monthlyInterestRate * 100}%"

  interimCalcA         = BigDecimal(((1 + monthlyInterestRate)**numberOfPayments).to_s).floor(8).to_f
  interimCalcB         = BigDecimal((monthlyInterestRate * interimCalcA).to_s).floor(8).to_f

  monthlyRepayment     = BigDecimal(((interimCalcB/(interimCalcA-1))*debtBalance).to_s).floor(0).to_i
  puts "月々の支払額:#{monthlyRepayment.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"

  annualRepayment      = monthlyRepayment*12
  puts "年間の支払額:#{annualRepayment.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"

  totalRepayment       = monthlyRepayment*numberOfPayments
  puts "支払総額:#{totalRepayment.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"

  totalInterst         = totalRepayment-debtBalance
  puts "支払総額に占める利息額:#{totalInterst.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"

  params = {debtBalance:debtBalance,numberOfPayments:numberOfPayments,monthlyInterestRate:monthlyInterestRate,monthlyRepayment:monthlyRepayment}

  puts "毎月の借入残高を確認しますか？確認する場合はYを終了する場合はNを入力してください。"
    checkDebtBalancePerMonth = gets.chomp.to_s
    if checkDebtBalancePerMonth == "Y" then
      debtBalanceSimulation(params)
    elsif checkDebtBalancePerMonth == "N" then
      return
    else
      puts "正しく入力してください。"
    end
end

def debtBalanceSimulation(params)

  debtBalance         = params[:debtBalance]
  numberOfPayments    = params[:numberOfPayments]
  monthlyInterestRate = params[:monthlyInterestRate]
  monthlyRepayment    = params[:monthlyRepayment]

  howManyTimes               = 1
  debtBalanceAtThisMonth     = debtBalance
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

    puts "--------------------------------------"
    puts "返済回数:#{howManyTimes}回目"
    puts "今月の返済額:#{monthlyRepayment.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"
    puts "今月の返済額に占める利息額:#{interestOfThisMonth.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"
    puts "今月の返済額に占める元金:#{principalOfThisMonth.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"
    puts "今月の返済後の借入金残高:#{debtBalanceAtThisMonth.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse}円"

    howManyTimes += 1
  end
end

params = {}
while true do
  puts "借入金シミュレーションを行いますか？行う場合はYを終了する場合はNを入力してください。"
  doSimulation = gets.chomp.to_s
  if doSimulation == "Y" then
    debtSimulation(params)
  elsif doSimulation == "N" then
    exit
  else
    puts "正しく入力してください。"
  end
end

