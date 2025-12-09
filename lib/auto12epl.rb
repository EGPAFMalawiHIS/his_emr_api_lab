#!/usr/bin/ruby
# frozen_string_literal: true

# Jeremy Espino MD MS
# 28-JAN-2016

class Float
  # function to round down a float to an integer value
  def round_down(n = 0)
    n < 1 ? to_i.to_f : (self - (0.5 / (10**n))).round(n)
  end
end

# Generates EPL code that conforms to the Auto12-A standard for specimen labeling
class Auto12Epl
  attr_accessor :element_font, :barcode_human_font

  DPI = 203
  LABEL_WIDTH_IN = 2.0
  LABEL_HEIGHT_IN = 0.5

  # font constants
  FONT_X_DOTS = [8, 10, 12, 14, 32].freeze
  FONT_Y_DOTS = [12, 16, 20, 24, 24].freeze
  FONT_PAD_DOTS = 2

  # element heights
  HEIGHT_MARGIN = 0.031
  HEIGHT_ELEMENT = 0.1
  HEIGHT_ELEMENT_SPACE = 0.01
  HEIGHT_PID = 0.1
  HEIGHT_BARCODE = 0.200
  HEIGHT_BARCODE_HUMAN = 0.050

  # element widths
  WIDTH_ELEMENT = 1.94
  WIDTH_BARCODE = 1.395
  WIDTH_BARCODE_HUMAN = 1.688

  # margins
  L_MARGIN = 0.031
  L_MARGIN_BARCODE = 0.25

  # stat locations
  L_MARGIN_BARCODE_W_STAT = 0.200
  L_MARGIN_W_STAT = 0.150
  STAT_WIDTH_ELEMENT = 1.78
  STAT_WIDTH_BARCODE = 1.150
  STAT_WIDTH_BARCODE_HUMAN = 1.400

  # constants for generated EPL code
  BARCODE_TYPE = '1A'
  BARCODE_NARROW_WIDTH = '2'
  BARCODE_WIDE_WIDTH = '2'
  BARCODE_ROTATION = '0'
  BARCODE_IS_HUMAN_READABLE = 'N'
  ASCII_HORZ_MULT = 1
  ASCII_VERT_MULT = 1

  def initialize(element_font = 1, barcode_human_font = 1)
    @element_font = element_font
    @barcode_human_font = barcode_human_font
  end

  # Calculate the number of characters that will fit in a given length
  def max_characters(font, length)
    dots_per_char = FONT_X_DOTS.at(font - 1) + FONT_PAD_DOTS

    num_char = ((length * DPI) / dots_per_char).round_down

    num_char.to_int
  end

  # Use basic truncation rule to truncate the name element i.e., if > maxCharacters cutoff and trail with +
  def truncate_name(last_name, first_name, middle_initial, is_stat)
    name_max_characters = if is_stat
                            max_characters(@element_font, STAT_WIDTH_ELEMENT)
                          else
                            max_characters(@element_font, WIDTH_ELEMENT)
                          end

    if concatName(last_name, first_name, middle_initial).length > name_max_characters
      # truncate last?
      last_name = "#{last_name[0..11]}+" if last_name.length > 12

      # truncate first?
      if concatName(last_name, first_name, middle_initial).length > name_max_characters && first_name.length > 7
        first_name = "#{first_name[0..7]}+"
      end
    end

    concatName(last_name, first_name, middle_initial)
  end

  def concatName(last_name, first_name, middle_initial)
    "#{last_name}, #{first_name}#{middle_initial.nil? ? '' : " #{middle_initial}"}"
  end

  def generate_small_specimen_label(last_name, first_name, gender, col_date_time, tests, acc_num, number_of_copies = print_copies)
    <<~TEXT
      N
      R216,0
      ZT
      S1
      A100,6,0,1,1,1,N,"#{first_name}, #{last_name} - #{gender}"
      B120,40,0,1A,1,2,48,N,"#{acc_num}"
      A100,100,0,1,1,1,N,"#{acc_num}"
      A100,118,0,1,1,1,N,"#{col_date_time}"
      A100,140,0,1,1,1,N,"#{tests}"
      P#{number_of_copies}
    TEXT
  end

  # The main function to generate the EPL
  def generate_epl(last_name, first_name, middle_initial, pid, dob, age, gender, col_date_time, col_name, tests, stat,
                   acc_num, schema_track, arv_number, number_of_copies = print_copies)
    # Show ARV number only if test contains 'vl' (case insensitive)
    arv_display = tests.match?(/vl/i) ? arv_number : ''
    
    <<~TEXT
      N
      R130,0
      ZT
      S1
      A100,6,0,1,1,1,N,"#{last_name} #{first_name} (#{age})"
      B100,30,0,1A,2,2,37,N,"#{acc_num}"
      A100,80,0,1,1,1,N,"#{acc_num}   #{arv_display}"
      A100,100,0,1,1,1,N,"#{col_date_time}	#{tests}"
      A80,6,1,1,1,1,R,"   #{stat}   "
      P#{number_of_copies}
    TEXT
  end

  # Add spaces before and after the stat text so that black bars appear across the left edge of label
  def pad_stat_w_space(stat)
    num_char = max_characters(@element_font, LABEL_HEIGHT_IN)
    spaces_needed = (num_char - stat.length) / 1
    space = ''
    spaces_needed.times do
      space += ' '
    end
    space + stat + space
  end

  # Add spaces between the NPID and the dob/age/gender so that line is fully justified
  def full_justify(pid, dag, font, length)
    max_char = max_characters(font, length)
    spaces_needed = max_char - pid.length - dag.length
    space = ''
    spaces_needed.times do
      space += ' '
    end
    pid + space + dag
  end

  # convert inches to number of dots using DPI
  def to_dots(inches)
    (inches * DPI).round
  end

  # generate ascii EPL
  def generate_ascii_element(x, y, rotation, font, is_reverse, text)
    "A#{x},#{y},#{rotation},#{font},#{ASCII_HORZ_MULT},#{ASCII_VERT_MULT},#{is_reverse ? 'R' : 'N'},\"#{text}\""
  end

  # generate barcode EPL
  def generate_barcode_element(x, y, height, schema_track)
    schema_track = schema_track.gsub('-', '').strip
    "B#{x},#{y},#{BARCODE_ROTATION},#{BARCODE_TYPE},#{BARCODE_NARROW_WIDTH},#{BARCODE_WIDE_WIDTH},#{height},#{BARCODE_IS_HUMAN_READABLE},\"#{schema_track}\""
  end

  def print_copies
    property = ::GlobalProperty.find_by(property: 'max.lab.order.print.copies')
    value = property&.property_value&.strip
    value || 3
  end
end

if __FILE__ == $PROGRAM_NAME

  auto = Auto12Epl.new

  puts auto.generate_epl('Banda', 'Mary', 'U', 'Q23-HGF', '12-SEP-1997', '19y', 'F', '01-JAN-2016 14:21', 'byGD',
                         'CHEM7,Ca,Mg', nil, 'KCH-16-00001234', '1600001234')
  puts "\n"
  puts auto.generate_epl('Banda', 'Mary', 'U', 'Q23-HGF', '12-SEP-1997', '19y', 'F', '01-JAN-2016 14:21', 'byGD',
                         'CHEM7,Ca,Mg', 'STAT CHEM', 'KCH-16-00001234', '1600001234')
  puts "\n"
  puts auto.generate_epl('Bandajustrightlas', 'Mary', 'U', 'Q23-HGF', '12-SEP-1997', '19y', 'F', '01-JAN-2016 14:21',
                         'byGD', 'CHEM7,Ca,Mg', 'STAT CHEM', 'KCH-16-00001234', '1600001234')
  puts "\n"
  puts auto.generate_epl('Bandasuperlonglastnamethatwonfit', 'Marysuperlonglastnamethatwonfit', 'U', 'Q23-HGF',
                         '12-SEP-1997', '19y', 'F', '01-JAN-2016 14:21', 'byGD', 'CHEM7,Ca,Mg', 'STAT CHEM', 'KCH-16-00001234', '1600001234')
  puts "\n"
  puts auto.generate_epl('Bandasuperlonglastnamethatwonfit', 'Mary', 'U', 'Q23-HGF', '12-SEP-1997', '19y', 'F',
                         '01-JAN-2016 14:21', 'byGD', 'CHEM7,Ca,Mg', 'STAT CHEM', 'KCH-16-00001234', '1600001234')
  puts "\n"
  puts auto.generate_epl('Banda', 'Marysuperlonglastnamethatwonfit', 'U', 'Q23-HGF', '12-SEP-1997', '19y', 'F',
                         '01-JAN-2016 14:21', 'byGD', 'CHEM7,Ca,Mg', 'STAT CHEM', 'KCH-16-00001234', '1600001234')

end
