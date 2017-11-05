class LinkPreviewParser
	
  def self.parse(url)
    doc = Nokogiri::HTML(open(url))
    page = {}

  	page[:title] = 			give( doc.at('meta[property="og:title"]') )
    page[:description] = 	give( doc.at('meta[property="og:description"]') )
    page[:type] = 			give( doc.at('meta[property="og:type"]') )
    page[:site_name] = 		give( doc.at('meta[property="og:site_name"]') )
    page[:image] = 			give( doc.at('meta[property="og:image"]') )
    page[:permalink1] = 	give( doc.at('meta[name="twitter:url"]') )
    page[:permalink2] = 	give( doc.at('meta[property="al:web:url"]')  )
	
    # En cas d'échec, fallback sur le titre de la page
    if @page.blank? || @page[:title].blank?
      page[:title] = doc.css('title').text 
    end

    return page
  end


private

  # Renvoie le contenu du noeud de façon défensive
  def self.give(arr)
  	if  arr.present? && arr['content'].present?
  		return arr['content']
  	else
  		return nil
  	end
  end

end