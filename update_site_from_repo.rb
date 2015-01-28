#!/usr/bin/ruby

require 'nokogiri'
require 'fileutils'

@repo_location = "./crossbridge"
@site_dir      = "./source"

# List of globs and files to include.
@files_list = [
	"#{@repo_location}/README.html",
]
@files_list.concat Dir.glob("#{@repo_location}/docs/**/*.html")


@files_list.each do |file|
	out_filename = @site_dir + file[@repo_location.length..-1] + ".erb"
	puts "Processing: #{file} to #{out_filename}"
	html = Nokogiri::HTML(File.open(file))
	contents = html.at_css("body > .container")
	raise "No contents found" unless contents
	html.at_css("header.jumbotron").unlink
	FileUtils.mkdir_p(File.dirname(out_filename))
	contents.write_xhtml_to(File.open(out_filename, "w"))
end

FileUtils.cp_r("#{@repo_location}/docs/images", "#{@site_dir}/docs/")

# Copies README.md as index.md with the prepended frontmatter.
File.open("#{@site_dir}/index.md", "w") do |file|
	file.write(<<EOF
---
body_class: "main"
---

EOF
	)
	file.write(File.read("#{@repo_location}/README.md"))
end
