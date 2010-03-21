# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_greed_two_session',
  :secret      => '507b256fb9a95ac59843c39b8fd60de8b2eae421b9ceb7cc3861de87cff99f017dcd10f995a2da442b56dbbe50b3bdb428def4afb0ba6081f34eeb9779fb3c1e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
