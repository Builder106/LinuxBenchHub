# dartsass-rails only builds application.scss by default. The showcase
# design system is a deliberately separate stylesheet (see showcase.scss)
# so it needs its own build entry.
Rails.application.config.dartsass.builds["showcase.scss"] = "showcase.css"
