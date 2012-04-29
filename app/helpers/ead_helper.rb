module EadHelper
  def ead_link_id(element, xpath)
    element.attribute('id') || xpath.split('/').last
  end

  def ead_increment_start(start)
    number = start[1,5].to_i + 1
    start_number = "%02d" % number
    'c' + start_number
  end

  # used for table of contents
  def ead_xpaths
    [
      ['Archdesc', '/ead/archdesc', :text ],
      ['Collection Inventory', '/ead/archdesc/dsc', :dsc]
    ]
  end

  def ead_list(list)
    ol = ['<ol>']
    list.xpath('item').map do |item|
      ol << '<li>' + item.text + '</li>'
    end
    ol << '</ol>'
    ol.join('')
  end

  def ead_paragraphs(element)
    if element
      element.xpath('p').map do |p|
        if !p.xpath('list').blank?
          p.xpath('list').map do |list|
            '<p>' + ead_list(list) + '</p>'
          end
        else
          '<p>' +  p.text + '</p>'
        end

      end
    end
  end

  def ead_text(element, xpath)
    first = element.xpath(xpath).first
    if first
      first.text
    end
  end

  # to create table of contents
  def ead_contents(document)
    xml = ead_xml(document)
    xpaths = ead_xpaths
    links = []
    xpaths.each do |pair|
      element = xml.xpath(pair[1]).first
      if element
        link_target = element.attribute('id') || pair[1].split('/').last
        #TODO add digital content
        links << link_to(pair[0], '#' + link_target) if link_target
      end
    end
    return links
  end

  def ead_xml(document)
    xml_doc = document['xml_display'].first
    xml_doc.gsub!(/xmlns=".*"/, '')
    xml_doc.gsub!('ns2:', '')
    Nokogiri::XML(xml_doc)
  end

  def dao(did, limit=4)
    dao = did.xpath('../dao')[0]
    if dao
      href = dao.attribute('href').text
      regex = /http:\/\/insight.+?Classification%20Number%7C1%7C((UA|MC|ua|mc)([0-9]{3}.){2}[0-9]{3}).+?gc=0/
      if href.match(regex)
        thumbnails, number_of_docs = classification_number_thumbnails($1, :limit => limit)
        if thumbnails
          return_string = '<div class="dao">' + thumbnails
          return_string << classification_see_more_link($1) if number_of_docs > limit
          return_string << '</div>'
        end
      else
        return ''
      end
    else
      return ''
    end
  end
  
  # def transform_ead_xml(xml)
  #   doc = Nokogiri::XML(xml.first)
  #   dsc = Nokogiri::XML(doc.xpath('//dsc').first.to_s)
  #   xslt  = Nokogiri::XSLT(File.read(File.join(Rails.root, 'lib', 'ead', 'xsl', 'dsc2.xsl')))
  #   xslt.transform(dsc).to_s.sub('<?xml version="1.0"?>', '').html_safe
  # end
  
  def standard_xpath_nots
    "[not(self::did)][not(self::c)][not(self::c02)][not(self::c03)][not(self::c04)][not(self::c05)][not(self::c06)][not(self::c07)][not(self::c08)][not(self::c09)][not(self::c10)][not(self::c11)][not(self::c12)]"
  end
  
  def dsc_xpath
    "./*/*" + standard_xpath_nots
  end
  
  def standard_xpath
    "./*[not(self::dsc)]" + standard_xpath_nots
  end
  
  def dsc_xslt
    @dsc_xslt ||= Nokogiri::XSLT(File.read(File.join(Rails.root, 'lib', 'ead', 'xsl', 'nead_dsc.xsl')))
  end
  
  def archdesc_xslt
    @archdesc_xslt ||= Nokogiri::XSLT(File.read(File.join(Rails.root, 'lib', 'ead', 'xsl', 'nead_archdesc.xsl')))
  end
  
  def transform_ead_part(part)
    doc = Nokogiri::XML(part.to_s)
    if ['c','c01', 'c02', 'c03','c04','c05','c06','c07','c08','c09','c10','c11','c12'].include? doc.xpath('./*').first.name
      xpath = dsc_xpath
      xslt = dsc_xslt
    else
      xpath = standard_xpath
      xslt = archdesc_xslt
    end
    
    parts = Nokogiri::XML(doc.xpath(xpath).first.to_s)
    if !parts.blank?
      Rails.logger.info(parts.to_s)
      transformed_doc = xslt.transform(parts).to_s.sub('<?xml version="1.0"?>', '')
      transformed_doc.html_safe
    end
  end
  
end