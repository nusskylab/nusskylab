class AddDefaultTagsToHashTags < ActiveRecord::Migration
  def up
    hash_tag = HashTag.new(content: 'python', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'ruby', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'c/cpp', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'java', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'javascript', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'csharp', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'swift', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'scala', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'go', label: 'language')
    hash_tag.save
    hash_tag = HashTag.new(content: 'php', label: 'language')
    hash_tag.save

    hash_tag = HashTag.new(content: 'rails', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'django', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'gae', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'nodejs', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'angularjs', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'reactjs', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'emberjs', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'flask', label: 'web_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'meteor', label: 'web_framework')
    hash_tag.save

    hash_tag = HashTag.new(content: 'ios', label: 'platform')
    hash_tag.save
    hash_tag = HashTag.new(content: 'android', label: 'platform')
    hash_tag.save

    hash_tag = HashTag.new(content: 'vim', label: 'ide')
    hash_tag.save
    hash_tag = HashTag.new(content: 'emacs', label: 'ide')
    hash_tag.save
    hash_tag = HashTag.new(content: 'eclipse', label: 'ide')
    hash_tag.save
    hash_tag = HashTag.new(content: 'pycharm', label: 'ide')
    hash_tag.save
    hash_tag = HashTag.new(content: 'idle', label: 'ide')
    hash_tag.save
    hash_tag = HashTag.new(content: 'nitrous', label: 'ide')
    hash_tag.save
    hash_tag = HashTag.new(content: 'cloud9', label: 'ide')
    hash_tag.save

    hash_tag = HashTag.new(content: 'paypal', label: 'ecommerce')
    hash_tag.save
    hash_tag = HashTag.new(content: 'ecommerce', label: 'ecommerce')
    hash_tag.save
    hash_tag = HashTag.new(content: 'square', label: 'ecommerce')
    hash_tag.save
    hash_tag = HashTag.new(content: 'braintree', label: 'ecommerce')
    hash_tag.save

    hash_tag = HashTag.new(content: 'azure', label: 'cloud')
    hash_tag.save
    hash_tag = HashTag.new(content: 'aws', label: 'cloud')
    hash_tag.save
    hash_tag = HashTag.new(content: 'compute_engine', label: 'cloud')
    hash_tag.save
    hash_tag = HashTag.new(content: 'docker', label: 'cloud')
    hash_tag.save
    hash_tag = HashTag.new(content: 'vmware', label: 'cloud')
    hash_tag.save
    hash_tag = HashTag.new(content: 'digitalocean', label: 'cloud')
    hash_tag.save
    hash_tag = HashTag.new(content: 'socvm', label: 'cloud')
    hash_tag.save

    hash_tag = HashTag.new(content: 'fun', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'gamedev', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'devops', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'webapp', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'game', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'nusmods', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'dating', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'infosec', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'analytics', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'eca', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'cca', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'volunteer', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'studentclub', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'market', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'contests', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'hackathon', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'showcase', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'blk71', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'nushackers', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'acm', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'nussu', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'compclub', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'gdg', label: 'purpose')
    hash_tag.save
    hash_tag = HashTag.new(content: 'greyhats', label: 'purpose')
    hash_tag.save

    hash_tag = HashTag.new(content: 'raspberrypi', label: 'embedded_system')
    hash_tag.save
    hash_tag = HashTag.new(content: 'arduino', label: 'embedded_system')
    hash_tag.save
    hash_tag = HashTag.new(content: 'iot', label: 'embedded_system')
    hash_tag.save

    hash_tag = HashTag.new(content: 'gamepress', label: 'game_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'unity', label: 'game_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'gamemaker', label: 'game_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'corona', label: 'game_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'stencyl', label: 'game_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'gamesalad', label: 'game_framework')
    hash_tag.save
    hash_tag = HashTag.new(content: 'pygame', label: 'game_framework')
    hash_tag.save

    hash_tag = HashTag.new(content: 'wordpress', label: 'cms')
    hash_tag.save
    hash_tag = HashTag.new(content: 'joomla', label: 'cms')
    hash_tag.save
    hash_tag = HashTag.new(content: 'drupal', label: 'cms')
    hash_tag.save

    hash_tag = HashTag.new(content: 'nus', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'university', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'youths', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'adults', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'elderly', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'children', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'toddlers', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'families', label: 'audience')
    hash_tag.save
    hash_tag = HashTag.new(content: 'parents', label: 'audience')
    hash_tag.save
  end

  def down
    HashTag.delete_all
  end
end
