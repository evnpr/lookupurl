require 'uri'
require 'httparty'
require 'nokogiri'

class LookUpUrl
  attr_accessor :title, :description, :host, :url, :image_url
  def crawl_url(link) 
            url = link

            @url = url
            @host = URI.parse(url).host

            begin
                # get the url content
                response = HTTParty.get(url)
                # /get the url content
                
                
                # nokogiri in action
                doc = Nokogiri::HTML(response)

                #----- description ----
                @description = ""
                doc.xpath("//meta[@name='description']/@content").each do |attr|
                    @description = attr.value
                end
                if @description == ""
                    doc.xpath("//p").each do |attr|
                        @description = attr.text
                        break
                    end
                end
                if @description == ""
                    doc.xpath("//meta[@name='description']/@content").each do |attr|
                        @description = ""
                        @description = attr.value
                    end
                end
                if @description == ""
                    doc.xpath("//meta[@property='og:description']/@content").each do |attr|
                        @description = ""
                        @description = attr.value
                    end
                end
                #----- /description --------
                #----- images --------
                images = []
                doc.xpath("//img/@src").each do |attr|
                    images << attr.value if attr.value.include? ".jp" or  attr.value.include? ".png"
                end
                doc.xpath("//meta[@property='og:image']/@content").each do |attr|
                    if attr.value.include? ".jp" or  attr.value.include? ".png"
                        images = []
                        images << attr.value 
                    end
                end
                image = images.first
                #----- /images --------
                #
                #----- title --------
                if doc.at_css("title")
                    @title = doc.at_css("title").text
                else
                    @title = nil
                end
                #----- /title --------
                # /nokogiri in action
                #
                
                # rescue
            rescue
                @title = @host
                @description = @url
                return false
            end
            # end rescue
            if image == "" || image == nil
               @image_url = ""
            else
               @image_url = image.force_encoding('iso-8859-1').encode('utf-8')
            end
            if @title == "" || @title == nil
                @title = @host
            else
                @title = @title.force_encoding('iso-8859-1').encode('utf-8').to_s[0..100]
            end
            if @description == "" || @description == nil
                @description = @url
            else
                @description = @description.force_encoding('iso-8859-1').encode('utf-8')
            end
  end
end
