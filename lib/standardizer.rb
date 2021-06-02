require_relative './standardizer/transformer.rb'
require_relative './standardizer/validator.rb'
require 'fileutils'
require 'csv'

module Standardizer
  class << self

    # Provides a valid .csv which allows the highest number of valid patient records.
    #
    # Example:
    #   >> Standardizer.peform("/Users/jhart/Desktop/standardizer/input.csv", ".")
    #   => true
    #
    # Arguments:
    #   input_csv: (String)
    #   output_dir: (String)
    def perform(input_csv, output_dir)
      begin
        patientRecords = []
        validator = Standardizer::Validator.new
        transformer = Standardizer::Transformer.new
        csv = CSV.read(input_csv)
        head = csv.shift
        csv.each do |pRecord|
          clean = transformer.transform(pRecord)
          patientRecords << clean if validator.is_valid?(clean)
        end
        report = (transformer.log + validator.log).sort
        validCsv = patientRecords.push(head).reverse.map(&:to_csv).join
        dirname = File.dirname(output_dir)
        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
        File.open("#{output_dir}/output.csv", "w+") {|f| f.write(validCsv) }
        File.open("#{output_dir}/report.txt", "w+") {|f| f.puts(report.join("\n")) }
        true
      rescue => e
        p "Standardizer Failed #{e.message}"
        false
      end
    end
  end
end
