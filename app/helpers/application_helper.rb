module ApplicationHelper
	
	def sanitize text
		CGI::unescapeHTML(text.gsub(/<\/?[^>]*>/,""))
	end

end
