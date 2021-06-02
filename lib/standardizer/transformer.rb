require 'date'

module Standardizer
  class Transformer
    attr_accessor :log

    def initialize
      @log = []
    end

    # - Trim extra white space for all fields
    # - Transform phone_numbers to E.164 format (All Numbers should be US e.g. +1)
    # - Transform ALL dates to ISO8601 format (YYYY-MM-DD)
    #
    # Example:
    #   >> transformer = Transformer.new
    #   >> data = ["Serena", "Williams", "1948-4-4", "jk 909009", "11/11/17", "12/14/2050", "+1 444-555-9876"],
    #   >> transformer.transform(data)
    #   => ["Serena", "Williams", "1948-04-04", "jk 909009", "2017-04-04", "2050-12-14", "+14445559876"],
    #
    # Arguments:
    #   patientRecord: (Array)
    def transform(patientRecord)
      clean = []
      memberId = patientRecord[3]
      patientRecord.each_with_index do |record, index|
        clean << record && next if record == nil || record == ""
        data = record.strip
        case index
        when 2, 4, 5
          isNineteens = lambda { |yr| yr >= 21 && yr <= 99 }
          isTwoThousands = lambda { |yr| yr >= 10 && yr <= 21 }
          isBackwards = lambda { |dateBlock| dateBlock[0].to_i > dateBlock[2].to_i }
          dateBlock = data.split("/") if data.include?("/")
          dateBlock = data.split("-") if data.include?("-")            
          unless dateBlock
            clean << "invalid date"
            log << "unknown date format for memberId: #{memberId}"
            next
          end
          dateBlock.reverse! if isBackwards.call(dateBlock)
          yr = dateBlock[2].to_i
          dateBlock[2] = "20" + yr.to_s if isTwoThousands.call(yr)
          dateBlock[2] = "19" + yr.to_s if isNineteens.call(yr)
          dateBlock = dateBlock.join("-")
          data = Date.strptime(dateBlock, '%m-%e-%Y').to_s
        when 6
          cleanNumber = data.gsub!(/[^0-9A-Za-z]/, "") || data
          data = cleanNumber.length == 11 ? "+" + cleanNumber : "+1" + cleanNumber
        end
        clean << data
      end
      clean
    end
  end
end
