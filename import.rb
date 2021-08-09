require 'front_matter_parser'
require 'kramdown'

ext = ".md"
files = Dir.glob("#{ENV['CONTENT_DIRECTORY']}/**/*#{ext}")

outDir = ENV['OUTPUT_DIRECTORY']
if !Dir.exists?(outDir)
  Dir.mkdir(outDir)
end

bikes = [
  '2006-07-21-ruby-made-me-fatter-so-i-had-to-do-something',
  '2006-08-29-tired-again',
  '2006-09-19-more-riding-and-i-feel-like-crap',
  '2006-11-16-diet',
  '2007-05-21-i-love-calfee-bikes',
  '2007-05-29-more-on-my-bike-dilema',
  '2007-05-30-logan-canyon',
  '2007-05-30-want-to-lose-weight',
  '2007-06-06-2008-trek-madone',
  '2007-06-06-i-can-feel-the-fat-finding-its-way-back-to-my-waste',
  '2007-06-07-2008-trek-madone-prices',
  '2007-06-10-more-trek-2008-madone-love',
  '2007-06-11-2008-madone-seatpost-and-trek-lovehate',
  '2007-06-11-2008-trek-madone-weight',
  '2007-06-11-differences-between-the-trek-madone-69-and-65',
  '2007-06-11-new-shimano-ultegra',
  '2007-06-11-why-trek-why',
  '2007-06-12-ride-your-bike-to-work-and-get-paid',
  '2007-06-18-gave-up-on-road-bike-going-off-road-with-santa-cruz-blur-xc',
  '2007-06-19-first-ride-on-the-new-bike-tonight',
  '2007-06-20-first-time-on-the-new-santa-cruz-blur-xc-and-near-death-experiences',
  '2007-06-23-finished-my-first-cycling-century-today',
  '2007-08-08-returning-to-my-mistress',
  '2007-08-08-rode-blacksmith-fork-canyon-tonight',
  '2007-08-10-daily-commute',
  '2007-08-25-cache-valley-century',
  '2007-10-18-olympic-cycling-considering-move-to-ogden',
  '2007-12-11-cycling-pack-mentality',
  '2008-01-14-trek-project-one-delayed',
  '2008-02-13-2008-trek-madonne-disappoints-big-time',
  '2008-02-23-2008-tour-de-france-dont-watch-it',
  '2008-03-05-login-cycling-psychopaths',
  '2008-03-19-project-one-goes-live-with-the-new-madones',
  '2008-03-20-trek-project-one-update',
  '2008-03-21-recreational-cyclists-should-not-ride-like-the-pros',
  '2008-03-26-trek-madone-lust',
  '2008-04-17-2008-trek-madone-dilema',
  '2008-04-18-bought-the-trek-madone-69',
  '2008-04-23-more-on-my-new-madone-69',
  ''

]

files.each do |file|
  if File.file?(file)
    name = File.basename(file.gsub("/index.md", ""))
    filename = "#{outDir}/#{name}.html"
    begin
      parsed = FrontMatterParser::Parser.parse_file(file)
      parsed.front_matter #=> {'title' => 'Hello World', 'category' => 'Greetings'}
      html = Kramdown::Document.new(parsed.content).to_html
      #puts "Writing #{filename}"
      File.write(filename, html)
    rescue => ex
      puts "Error in #{filename}: #{ex}"
    end
  end
end
