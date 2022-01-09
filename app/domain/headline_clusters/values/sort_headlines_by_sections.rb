module HeadlineConnector
  module Value
    class HeadlineCluster < SimpleDelegator
      def self.sort_by_sections(headlines_entity)
        sorted = Hash.new

        headlines_entity.headlines.each do |headline_entity|
          sorted["#{headline_entity.section}"] = Array.new if sorted["#{headline_entity.section}"].nil?

          article_content = OpenStruct.new(section: headline_entity.section, 
                                           article_url: headline_entity.article_url, 
                                           title: headline_entity.title,
                                           abstract: headline_entity.abstract,
                                           img: headline_entity.img,
                                           tag: headline_entity.tag)

          # article_content[section] = headline_entity.section
          # article_content[article_url] = headline_entity.article_url
          # article_content[title] = headline_entity.title
          # article_content[abstract] = headline_entity.abstract
          # article_content[img] = headline_entity.img
          # article_content[tag] = headline_entity.tag

          sorted["#{headline_entity.section}"].push(article_content)
        end
        article_array = []
        sorted.each do |k, v|
          article_array.push(OpenStruct.new(name: k, section: v))
        end
        return OpenStruct.new(sections: article_array)
      end
    end
  end
end