# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_treemap_session',
  :secret      => '1dae3e5cf1b977127d18408da616dc503cec56f27d9ac0c09d8249d14248b88fd8b1bff9f2b0727f44253499f9b068e416397972391846342084ffff72787102'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
