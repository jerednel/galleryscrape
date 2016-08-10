class GalleryController < ApplicationController
	require 'open-uri'
	require 'nokogiri'

	def index

	end

	def show
		@orientation = params[:Horizontal]
		@largesize = params[:LargeImages]
		arr = params[:CTYHOCN].split("\r\n")
		scrape_imgs(arr)
	end

	def scrape_imgs(arr)
		@img_urls = Array.new
		@img_captions = Array.new
		@img_alts = Array.new
		@table_hsh = Array.new

		arr.each do |ctyhocn|
			url = "http://www3.hilton.com/en/hotels/united-kingdom/" + ctyhocn + "/index.html"

			doc = Nokogiri::HTML(open(url))
			@img_urls = doc.css('.gallery img').map{ |i| i['src'] } # array of image urls [url1, url2, url3]
			@large_img_urls = doc.css('.gallery .img').map{ |url| url }
			@img_captions = doc.css('.gallery .title').map{ |alt| alt} 
			@img_alts = doc.css('.gallery .image_alt').map{ |alt| alt } # array of image captions [caption1, caption2, caption 3]
			@table_hsh << {:ctyhocn => ctyhocn, :imgs => @img_urls, :captions => @img_captions, :large_img_urls => @large_img_urls, :alt_text => @img_alts }
			#@img_captions = @doc.css('.gallery .image_alt').map{ |alt| alt }
		end

		@table_hsh

	end
end

