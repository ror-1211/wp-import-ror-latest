# Wp-import
This is a Ruby script I used to import markdown files and images into Wordpress. It isn't polished or production code but it worked
for what I needed it to do. It does have code specific to my usage so use it at your own peril. It does have a few examples of how to interact with the Wordpress API using Ruby.

## Usage
Copy .env.example to .env and ensure the values in the .env file are set in your environment.

You will need to get an Wordpress API key.

Once it's setup run
`ruby import.rb`

## Background
I got tired of writing code for my blog and gravitated back to Wordpress for the sake of simplicity.
If you want to read more there's a longer store about it all on [my blog - https://justinball.com/2021/11/15/around-and-back-to-wordpress/](https://justinball.com/2021/11/15/around-and-back-to-wordpress/)