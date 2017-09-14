require_relative 'thesaurus_service'

class WordsAPI < ThesaurusService

  def initialize
    @name = 'Words API'
    @api_key = ENV['WORDS_API_KEY']
  end

  def url(word)
    "https://wordsapiv1.p.mashape.com/words/#{word}"
  end

  def relevant_api_categories
    ['synonyms','typeOf','hasTypes','similarTo']
  end

  def extract_relevant_words(response)
    word_list = []
    results = JSON.parse(response)['results']
   
    results.each do |meaning|
      relevant_api_categories.each do |category|
        unless meaning[category] == nil
          word_list += meaning[category]
        end
      end
    end
    word_list.uniq
  end

  def synonym(word)
    return [] if word == '' 
    
    response = HTTParty.get(url(word))
    extract_relevant_words(response)
  end

end
