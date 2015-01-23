module GenericHelpers
	# Use the title from frontmatter metadata,
	# or peek into the page to find the H1,
	# or fallback to a filename-based-title
	def discover_title(page = current_page)
		page.data.title || page.render({layout: false}).match(/<h1.*>(.*?)<\/h1>/) do |m|
			m ? m[1] : page.url.split(/\//).last.titleize
		end
	end

	#def get_locale
	#	return :fr if current_page.path.match /^fr\//
	#	return :en
	#end

	def is_current_page path
		path += "index.html" if path.match /\/$/
		 "/#{current_page.path}" == path
	end

	def id_for_path(page = current_page)
		return "page_" + page.path.gsub('/','_').gsub('.html', '')
	end

	def crumb_title(page = current_page)
		page.data.crumbtitle or discover_title page
	end

	def get_crumbs(page = current_page)
		crumbs = [page]
		crumbs.unshift crumbs.first.parent while crumbs.first.parent

		# I actually do not want the first breadcrumb.
		crumbs.shift
		# And neither for the localized page
		if crumbs.first.destination_path.match(/^..\/index/) then
			crumbs.shift
		end

		return crumbs
	end

	def site_name()
		return config[:site_name]
	end

	def project_name()
		return config[:project_name]
	end
end

