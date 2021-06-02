require 'minitest/autorun'
require 'standardizer'

class StandardizerTest < Minitest::Test

  def test_transformation
    it = Standardizer::Transformer.new
    input = ["Serena", " Williams", "4/4/1948", "jk 909009", "11/11/17", "12/14/2050", "444-555-9876"]
    expected = ["Serena", "Williams", "1948-04-04", "jk 909009", "2017-11-11", "2050-12-14", "+14445559876"]
    assert_equal expected, it.transform(input)
  end

  def test_validation
    it = Standardizer::Validator.new
    input = ["Serena", "Williams", "1948-04-04", "jk 909009", "2017-04-04", "2050-12-14", "+14445559876"]
    assert_equal it.is_valid?(input), true
    input = ["Serena", "Williams", "1948-04-04", nil, "2017-04-04", "2050-12-14", "+14445559876"]
    assert_equal it.is_valid?(input), false
    input = ["Serena", "Williams", "1948-04-04", "jk 909009", "2017-04-04", "2050-12-14", "4445559876"]
    assert_equal it.is_valid?(input), false
  end
end
