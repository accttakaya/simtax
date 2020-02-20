class Function < ApplicationRecord

  include ActiveModel::Model
  
  attr_accessor :debtBalance, 
    :annualInterestRate,
    :numberOfPayments

  
  validates :debtBalance, :annualInterestRate, :numberOfPayments, presence: true

end
