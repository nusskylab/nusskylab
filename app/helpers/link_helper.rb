
require 'net/http'
require 'uri'
require 'open-uri'

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
  gdrive_prefix = "https://drive.google.com/"
  is_gdrive_link = url[0..gdrive_prefix.length - 1] == gdrive_prefix
  return is_gdrive_link
end

def get_google_drive_view_link(url)
  raise "not a google drive link" unless is_google_drive_link? url
  gdrive_id = url.to_s.scan(/id=.*/)[0].to_s
  if gdrive_id.include? "&"
    gdrive_id = (gdrive_id.split('&'))[0]
    gdrive_id = gdrive_id.to_s.scan(/id=.*/)[0].to_s
  end
  
  gdrive_view_link = "https://drive.google.com/uc?#{gdrive_id}&export=view"
  puts gdrive_view_link
  return gdrive_view_link
end

def is_valid_link?(url)
  # puts url
  url = URI.parse(url.to_s)
  req = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https')
  res = Net::HTTP.get_response(url)
  valid_link = (res.code[0] == "2") || (res.code[0] == "3")
  # puts res.body
  return valid_link
end

direct_url = "https://www.smashbros.com/images/og/link.jpg"
# test_url = "https://drive.google.com/open?id=12gYWVnvY_A0v66hY-9zFQMzoZ-j4Tsqf"
# is_google_drive_link? test_url
test_url = 'https://drive.google.com/open?id=12gYWVnvY_A0v66hY-9zFQMzoZ-j4Tsqf'
# test_url = 'https://drive.google.com/uc?id=12gYWVnvY_A0v66hY-9zFQMzoZ-j4Tsqf&export=view'
# is_valid_image_url?(test_url)

deleted_test_url = 'https://drive.google.com/open?id=1cxFm-oQ8WQygVB-Mj7IixP0QveMH77eL'

# is_direct_image_link? test_url  
# is_google_drive_link? test_url
gdrive_link = get_google_drive_view_link(test_url)
is_valid_link?(gdrive_link)
