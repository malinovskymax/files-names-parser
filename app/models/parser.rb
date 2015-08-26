class Parser

  VALID_ID_PATTERN = /^u\d{1,15}/i
  VALID_TYPE_PATTERN = /(account)|(activity)|(position)|(security)/i
  SIMPLE_DATE_PATTERN = /\d{8}/

  VALID_FILENAME_PATTERN = /#{VALID_ID_PATTERN}_#{VALID_TYPE_PATTERN}_#{SIMPLE_DATE_PATTERN}\.*/i
  # VALID_FILENAME_PATTERN = /^u\d{1,15}_((account)|(activity)|(position)|security)_\d{8}\.*/i

  class << self

    def parse(source)
      parsed_data = {}
      Dir.foreach(source) do |item|
        if is_valid_file?(source, item)
          item.gsub!(VALID_ID_PATTERN, '')
          account = $&.capitalize
          begin
            date = Time.parse(item[SIMPLE_DATE_PATTERN]).strftime('%F')
          rescue ArgumentError
            next
          end
          parsed_data[account] ||= {}
          parsed_data[account][date] ||= []
          parsed_data[account][date] << item[VALID_TYPE_PATTERN]
        end
      end
      parsed_data.each_value { |account| account.each_value { |types| types.sort_by! { |type| type.downcase! } } }
    end

    private

    def is_valid_file?(source, filename)
      File.file?(source.join(filename)) && filename.match(VALID_FILENAME_PATTERN) ? true : false
    end

  end

end