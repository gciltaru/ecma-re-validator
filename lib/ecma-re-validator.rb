begin
  require 'awesome_print'
  require 'pry'
rescue LoadError; end

require 'regexp_parser'

module EcmaReValidator

  # JS doesn't have Unicode matching
  UNICODE_CHARACTERS = Regexp::Syntax::Token::UnicodeProperty::All

  INVALID_REGEXP = [
    # JS doesn't have \A or \Z
    :bos, :eos_ob_eol,
    # JS doesn't have lookbehinds
    :lookbehind, :nlookbehind,
    # JS doesn't have atomic grouping
    :atomic,
    # JS doesn't have possesive quantifiers
    :zero_or_one_possessive, :zero_or_more_possessive, :one_or_more_possessive,
    # JS doesn't have named capture groups
    :named_ab, :named_sq
  ]

  INVALID_TOKENS = INVALID_REGEXP + UNICODE_CHARACTERS

  def self.valid?(input)
    if input.is_a? String
      begin
        input = Regexp.new(input)
      rescue RegexpError => e
        return false
      end
    elsif !input.is_a? Regexp
      return false
    end

    tokens = Regexp::Scanner.scan(input)

    items = tokens.map { |t| t[1] }

    (items & INVALID_TOKENS).empty?
  end
end
