require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody'],
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end

end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def clean_phone_number(phone_number)
  phone_number.gsub!(/\W/, '')
  if phone_number.length == 10
    phone_number = phone_number
  elsif phone_number.length == 11 && phone_number[0] == '1'
    if phone_number[0] == '1'
      phone_number = phone_number[1..10]
    end
  else
    phone_number = 'bad number'
  end
  phone_number
end

puts 'Event Manager Initialized!'


contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new(template_letter)
hours_count = Hash.new(0)
days_of_week = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
  phone_number = clean_phone_number(row[:homephone])

  reg_time = row[:regdate]
  reg_time = Time.strptime(reg_time, '%m/%d/%Y %H:%M')

  reg_hr = reg_time.hour
  hours_count[reg_hr] += 1

  reg_day = reg_time.wday
  days_of_week[reg_day] += 1

end

hours_count = hours_count.sort_by { |_, value| -value}.to_h
days_of_week = days_of_week.sort_by { |_, value| -value}.to_h
puts hours_count
puts days_of_week
puts 'Event Manager Finished!'
