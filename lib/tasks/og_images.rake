require "#{Rails.root}/app/workers/og_image_worker.rb"

namespace :og_images do
  desc "Generating OpenGraph Images for existing pages"
  task generate: :environment do
    generated_count = 0

    pages = Page.all

    puts  "Processing #{pages.size} pages"

    pages.find_each.with_index do |page, index|

      image = "#{Rails.root}/public/images/opengraph/#{page.project_id}/#{page.id}/og-image.jpg"

      unless File.exist?(image)
        OgImageWorker.new.perform(page.project_id, page.id, page.title)

        generated_count += 1
      end

      puts "Processing #{index} of #{pages.size}" if (index % 25).zero?
    end

    puts "Processing complete."
    puts "Images count: 109"
    puts "Images generated: #{generated_count}" if generated_count.positive?
  end
end
