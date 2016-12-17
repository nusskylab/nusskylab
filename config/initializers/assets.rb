# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.scss, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.compile = true
Rails.application.config.assets.precompile += ['public_views/bootstrap.js',
'public_views/bootstrap.min.js',
'public_views/jquery.js',
'public_views/modalbox.js',
'public_views/modalbox.js',
'public_views/3-col-portfolio.css',
'public_views/bootstrap.css',
'public_views/bootstrap.min.css',
]


