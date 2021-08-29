require 'base64'
require 'front_matter_parser'
require 'kramdown'
require 'httparty'
require 'byebug'

WEBSITE = "https://justinball.com"
# WEBSITE = "https://www.thebikecrank.com"
POSTS_PATH = "/wp-json/wp/v2/posts"
POST_URL = "#{WEBSITE}#{POSTS_PATH}"

CATEGORIES_PATH = "/wp-json/wp/v2/categories"
CATEGORIES_URL = "#{WEBSITE}#{CATEGORIES_PATH}"

USERS_PATH = "/wp-json/wp/v2/user"
USERS_URL = "#{WEBSITE}#{USERS_PATH}"

AUTHOR_ID = 1

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
  '2008-04-24-visited-my-new-madone-this-morning',
  '2008-04-24-weather-in-logan-not-conducive-to-new-bike',
  '2008-04-26-first-ride-on-the-new-madone',
  '2008-04-26-winter-was-hard-on-us-both',
  '2008-04-29-first-real-ride-on-the-new-trek-madone-69',
  '2008-06-15-eat-and-ride',
  '2008-07-02-riding-to-work-again',
  '2008-08-22-ways-to-not-make-use-of-your-health-insurance-cyclist-vs-rattlesnake',
  '2008-08-27-appreciate-the-little-things',
  '2008-08-27-found-some-stuff',
  '2008-09-01-cycling-reduces-your-risk-of-cancer',
  '2008-09-04-trek-xxx-lite-handlebars-single-use-item',
  '2008-09-08-why-cyclists-shave-their-legs-the-most-disgusting-post-i-will-ever-make',
  '2008-09-20-trek-project-one-launched',
  '2008-10-17-my-bike-wreck-could-have-been-worse',
  '2008-11-05-more-stuff-you-shouldnt-hit-on-a-bike',
  '2008-12-19-new-diet',
  '2009-01-18-a-very-sexy-madone',
  '2009-02-20-the-pro-bikers-dont-do-this',
  '2009-03-17-first-ride-of-the-season',
  '2009-08-23-snakeversary',
  '2009-10-15-justin-and-joels-epic-mountain-bike-adventure',
  '2010-05-07-men-in-tights',
  '2010-07-25-cervelo-eride-came-to-logan',
  '2010-08-12-polar-cs600-error-169',
  '2010-08-13-cycling-is-for-old-guys',
  '2011-07-10-cycling-in-teton-valley-driggs-id',
  '2012-09-12-great-ride-up-blacksmith-fork-canyon',
  '2012-09-27-logan-river-trail',
  '2012-10-01-blacksmith-fork-canyon',
  '2012-10-04-logan-canyon-bridger-lookout',
  '2012-10-04-providence-canyon',
  '2013-01-14-mountain-biking-oahu',
  '2014-01-01-my-morning-coffee',
  '2014-03-14-beautiful-day-had-to-blow-off-work-for-a-ride',
  '2014-04-10-i-put-on-a-little-fat-its-kinda-sexy',
  '2014-06-20-biking-and-raising-money',
  '2014-06-29-we-are-amazing-riding-the-ms150',
  '2014-07-08-crossed-4000-miles-for-the-year-tonight',
  '2015-05-04-mountain-bike-gear-ratios-1x-vs-2x-setup',
]

def process
  current_categories = list_categories

  ext = ".md"
  files = Dir.glob("#{ENV['CONTENT_DIRECTORY']}/**/*#{ext}")

  outDir = ENV['OUTPUT_DIRECTORY']
  if !Dir.exists?(outDir)
    Dir.mkdir(outDir)
  end

  files.each do |file|
    if File.file?(file)
      name = File.basename(file.gsub("/index.md", ""))
      filename = "#{outDir}/#{name}.html"
      begin
        parsed = FrontMatterParser::Parser.parse_file(file)
        html = Kramdown::Document.new(parsed.content).to_html
        puts "Writing #{filename}"
        File.write(filename, html)
        post_to_wp(parsed.front_matter, html, current_categories)
      rescue => ex
        puts "Error in #{filename}: #{ex}"
      end
    end
  end
end

def list_posts
  puts "Getting: #{POST_URL}"
  HTTParty.get(POST_URL)
end

def list_categories
  puts "Getting: #{CATEGORIES_URL}"
  HTTParty.get(CATEGORIES_URL + "?hide_empty=false")
end

def create_category(name)
  body = {
    "name" => name,
  }
  do_post(CATEGORIES_URL, body)
end

def find_category_ids(categories, current_categories)
  ids = []
  categories.each do |category|
    if found = current_categories.find{ |c| c["name"].downcase == category.downcase }
      ids << found["id"]
    else
      result = create_category(category)
      if result["code"] == "term_exists"
        ids << result["data"]["term_id"]
      else
        ids << result["id"]
      end
    end
  end

end

# developer.wordpress.org/rest-api/reference/posts/#create-a-post
def post_to_wp(front_matter, html, current_categories)
  category_ids = find_category_ids(front_matter["categories"], current_categories)
  body = {
    "title" => front_matter["title"],
		"status" => "publish", # ok, we do not want to publish it immediately
		"content" => html,
		"categories" => category_ids.join(","), # category ID
		"tags" => front_matter["tags"].join(","), # string, comma separated
		"date" => front_matter["date"], # YYYY-MM-DDTHH:MM:SS
		"slug" => front_matter["permalink"].split("/").last, # part of the URL usually
    "author" => AUTHOR_ID,
  }
  puts do_post(POST_URL, body)
end

def do_post(url, body)
  auth = {
    username: ENV['API_USERNAME'],
    password: ENV['API_PASSWORD'],
  }

  options = {
    body: body,
    basic_auth: auth,
  }

  puts "Posting to #{url} with #{options}"
  response = HTTParty.post(url, options)
end

# process
