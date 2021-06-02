module Standardizer
  class Validator
    attr_accessor :log

    def initialize
      @log = []
    end

    # - Phone Numbers must be E.164 compliant (country code + 10 numeric digits)
    # - first_name, last_name, dob, member_id, effective_date are ALL required for each patient
    #
    #
    # Example:
    #   >> validator = Validator.new
    #   >> data = ["Serena", "Williams", "1948-04-04", "jk 909009", "2017-04-04", "2050-12-14", "+14445559876"],
    #   >> validator.is_valid?(data)
    #   => true
    #
    # Arguments:
    #   patientRecord: (Array)
    def is_valid?(patientRecord)
      memberId = patientRecord[3]
      dirtyRecord = "Incomplete patient record for memberId: #{memberId}"
      badNumber = "Invalid phone number for memberId: #{memberId}"
      if patientRecord.include?(nil) || patientRecord.include?("")
        log << dirtyRecord
        return false
      end
      phone = patientRecord[6]
      phone = [phone[0..1], phone[2..phone.length]]
      if phone[0] != "+1" || phone[1].length != 10
        log << badNumber
        false
      else
        true
      end
    end
  end
end
