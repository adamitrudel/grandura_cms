namespace :radiant do
  namespace :extensions do
    namespace :navigation_tags do
      
      desc "Runs the migration of the Navigation Tags extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          NavigationTagsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          NavigationTagsExtension.migrator.migrate
        end
      end
    
    end
  end
end