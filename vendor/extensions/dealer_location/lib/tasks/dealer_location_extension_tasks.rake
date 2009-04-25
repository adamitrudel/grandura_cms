namespace :radiant do
  namespace :extensions do
    namespace :dealer_location do
      
      desc "Runs the migration of the Dealer Location extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          DealerLocationExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          DealerLocationExtension.migrator.migrate
        end
      end

      desc "database populate"
      task :populate => :environment do
        
        ["New York", "Vermont", "Alabama"].each do |location_name|
          Location.create(:name => location_name)
        end
        
        Dealer.create(
          :location       => Location.find_by_name("New York"),
          :company        => "All Windows Inc.",
          :contact_person => "John Doe", 
          :phone          => "518-489-5581", 
          :address        => "15 Kairnes Street, Albany, NY 12205",
          :windows        => true, 
          :siding         => true
        )
        
        Dealer.create(
          :location       => Location.find_by_name("New York"),
          :company        => "Siding Co., Inc.", 
          :contact_person => "Jim Young",
          :phone          => "716-852-2531", 
          :address        => "266 Broadway Street, Buffalo, NY 14204 ", 
          :windows        => true,
          :siding         => false
        )
      end
      
      desc "Copies public assets of the Dealer Location to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from DealerLocationExtension"
        Dir[DealerLocationExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(DealerLocationExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
