
require 'net/http'
require 'uri'
require 'open-uri'

def is_valid_image_url?(url)
  og_url = url
  puts url
  puts "\n"
  url = URI(url)
  # url = URI.parse(url)
  # http = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https')
  # out =  http.head(url.request_uri)
  # out =  get(url)
  # out = http.get_response(url)
  # contents = open(or_url) {|f| f.read }
  # puts contents
  out = Net::HTTP.get(url)
  http = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https')
  out = http.head(url.request_uri)
  puts out['Content-Type']
  puts "yeeta skeeta"
  print_dict(out)
  # puts out.body
  if out['Content-Type'].to_s.include? 'text/html' then
    puts "YEEEEEEEEEEEEEEEEEEEEEEEEEt"
    raw_url = out['location']
    puts raw_url
    url = URI(raw_url)
    http = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https')
    out = http.head(url.request_uri)
    print_dict(out)
    out = Net::HTTP.get(url)
    print out
    # out = Net::HTTP.get_response(url)
    # print_dict(out)
    # puts out
    # out = Net::HTTP.get(url)
    
    # puts out
    # out.each do |key, value|
      # puts key.to_s + ':' + value
    # end
    # out = http.get_response(url)
    # puts out
    # print_dict(out)
    # print_dict(out)
  end
end

def is_direct_image_link?(url, image_extensions=['jpeg', 'jpg', 'png'])
  url = URI(url)
  http = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https')
  res_header = http.head(url.request_uri)
  
  is_image = false
  for image_extension in image_extensions do
    header_checker = "image/#{image_extension}"
    contains_checker = res_header['Content-Type'].to_s.include? header_checker
    is_image = is_image || contains_checker
  end
  return is_image
end  

def print_dict(dict_to_print)
  dict_to_print.each do |key, value|
    puts key.to_s + ' : ' + value
  end
end

def is_google_drive_link?(url)
  google_drive_prefix = "https://drive.google.com/"
  url[0..google_drive_prefix.length] == google_drive_prefix
  puts url[0..google_drive_prefix.length]
end

test_url = "https://www.smashbros.com/images/og/link.jpg"
# test_url = "https://drive.google.com/open?id=12gYWVnvY_A0v66hY-9zFQMzoZ-j4Tsqf"
# is_google_drive_link? test_url
# test_url = 'https://drive.google.com/open?id=12gYWVnvY_A0v66hY-9zFQMzoZ-j4Tsqf'
# test_url = 'https://drive.google.com/uc?id=12gYWVnvY_A0v66hY-9zFQMzoZ-j4Tsqf&export=view'
# is_valid_image_url?(test_url)

is_direct_image_link? test_url  
