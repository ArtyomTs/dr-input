module Input
  class Line
    attr_reader :text, :clean_text, :start, :end, :length, :wrapped, :new_line
    attr_accessor :number

    def initialize(number, start, text, wrapped, font_style)
      @number = number
      @start = start
      @text = text
      @clean_text = text.delete_prefix("\n")
      @length = text.length
      @end = start + @length
      @wrapped = wrapped
      @new_line = text[0] == "\n"
      @font_style = font_style
    end

    def start=(val)
      @start = val
      @end = @start + @length
    end

    def wrapped?
      @wrapped
    end

    def new_line?
      @new_line
    end

    def to_s
      @text
    end

    def inspect
      "<Line##{@number} #{@start},#{@length} #{@text.gsub("\n", '\n')[0, 200]} #{@wrapped ? '\r' : '\n'}>"
    end

    def measure_to(index)
      if @text[0] == "\n"
        index < 1 ? 0 : @font_style.string_width(@text[1, index - 1].to_s)
      else
        @font_style.string_width(@text[0, index].to_s)
      end
    end

    def index_at(x)
      return @start if x <= 0

      index = -1
      width = 0
      while (index += 1) < length
        char = @text[index, 1]
        char_w = char == "\n" ? 0 : @font_style.string_width(char)
        # TODO: Test `index_at` with multiple different fonts
        char_mid = char_w / 4
        return index + @start if width + char_mid > x
        return index + 1 + @start if width + char_mid > x

        width += char_w
      end

      index + @start
    end
  end

  class LineCollection
    attr_reader :lines

    include Enumerable

    def initialize(lines = [])
      @lines = lines
    end

    def each
      @lines.each { |line| yield(line) }
    end

    def length
      @lines.length
    end

    def [](num)
      @lines[num]
    end

    def first
      @lines.first
    end

    def last
      @lines.last
    end

    def <<(line)
      @lines.append(line)
      self
    end

    def empty?
      @lines.empty?
    end

    def replace(old_lines, new_lines)
      @lines = (@lines[0, old_lines.first.number] || []) + new_lines.lines + (@lines[old_lines.last.number + 1, @lines.length] || [])

      i = new_lines.last.number
      l = @lines.length
      s = new_lines.last.end
      while (i += 1) < l
        line = @lines[i]
        line.number = i
        line.start = s
        s = line.end
      end
    end

    def modified(from_index, to_index)
      to_index, from_index = from_index, to_index if from_index > to_index
      line = line_at(from_index)
      modified_lines = []
      i = line.number
      loop do
        modified_lines << line
        break unless line.end < to_index || line.wrapped?

        line = @lines[i += 1]
      end

      LineCollection.new(modified_lines)
    end

    def text
      @lines.map(&:text).join
    end

    def line_at(index)
      @lines.detect { |line| index <= line.end } || @lines.last
    end

    def inspect
      @lines.map(&:inspect)
    end
  end

  class LineParser
    def initialize(word_wrap_chars, crlf_chars, font_style:)
      @word_wrap_chars = word_wrap_chars
      @crlf_chars = crlf_chars
      @font_style = font_style
    end

    def find_word_breaks(text)
      # @word_chars = params[:word_chars] || ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['_', '-']
      # @punctuation_chars = params[:punctuation_chars] || %w[! % , . ; : ' " ` ) \] } * &]
      # @crlf_chars = ["\r", "\n"]
      # @word_wrap_chars = @word_chars + @punctuation_chars
      words = []
      word = ''
      index = -1
      length = text.length
      mode = :leading_white_space

      while (index += 1) < length # mode = find a word-like thing
        case mode
        when :leading_white_space
          if text[index].strip == '' # leading white-space
            if @crlf_chars.include?(text[index]) # TODO: prolly need to replace \r\n with \n up front
              words << word
              word = "\n"
            else
              word << text[index] # TODO: consider how to render TAB, maybe convert TAB into 4 spaces?
            end
          else
            word << text[index]
            mode = :word_wrap_chars
          end
        when :word_wrap_chars # TODO: consider smarter handling. "something!)something" would be considered a word right now, theres an extra step needed
          if @word_wrap_chars.include?(text[index])
            word << text[index]
          elsif @crlf_chars.include?(text[index])
            words << word
            word = "\n"
            mode = :leading_white_space
          else
            word << text[index]
            mode = :trailing_white_space
          end
        when :trailing_white_space
          if text[index].strip == '' # trailing white-space
            if @crlf_chars.include?(text[index])
              words << word
              word = "\n" # converting all new line chars to \n
              mode = :leading_white_space
            else
              word << text[index] # TODO: consider how to render TAB, maybe convert TAB into 4 spaces?
            end
          else
            words << word
            word = text[index]
            mode = :word_wrap_chars
          end
        end
      end

      words << word
    end

    def perform_word_wrap(text, width, first_line_number = 0, first_line_start = 0, font_style = @font_style)
      @font_style = font_style

      words = find_word_breaks(text)
      lines = LineCollection.new
      line = ''
      i = -1
      le = words.length
      while (i += 1) < le
        word = words[i]
        if word == "\n"
          unless line == ''
            lines << Line.new(lines.length + first_line_number, first_line_start, line, false, @font_style)
            first_line_start = lines.last.end
          end
          line = word
        else
          w = @font_style.string_width((line + word).rstrip)
          if w > width
            unless line == ''
              lines << Line.new(lines.length + first_line_number, first_line_start, line, true, @font_style)
              first_line_start = lines.last.end
            end

            # break up long words
            w = @font_style.string_width(word.rstrip)
            while w > width
              r = word.length - 1
              l = 0
              m = r.idiv(2)
              w = @font_style.string_width(word[0, m].rstrip)
              loop do
                if w == width
                  # Whoa, add this
                  lines << Line.new(lines.length + first_line_number, first_line_start, word[0, m], true, @font_style)
                  first_line_start = lines.last.end
                  word = word[m, word.length]
                  break
                elsif w < width
                  if r - l <= 1
                    lines << Line.new(lines.length + first_line_number, first_line_start, word[0, r], true, @font_style)
                    first_line_start = lines.last.end
                    word = word[r, word.length]
                    break
                  end

                  # go right
                  l = m + 1
                  m = (l + r).idiv(2)
                elsif w > width
                  if r - l <= 1
                    lines << Line.new(lines.length + first_line_number, first_line_start, word[0, l], true, @font_style)
                    first_line_start = lines.last.end
                    word = word[l, word.length]
                    break
                  end

                  # go left
                  r = m - 1
                  m = (l + r).idiv(2)
                end
                w = @font_style.string_width(word[0, m].rstrip)
              end
              w = @font_style.string_width(word.rstrip)
            end
            line = word
          elsif word.start_with?("\n")
            unless line == ''
              lines << Line.new(lines.length + first_line_number, first_line_start, line, false, @font_style)
              first_line_start = lines.last.end
            end
            line = word
          else
            line << word
          end
        end
      end

      lines << Line.new(lines.length + first_line_number, first_line_start, line, false, @font_style)
    end
  end
end
