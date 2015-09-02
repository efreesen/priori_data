## README

The task is to create a REST API that pulls the Apple App Store top lists from US and provides additional metadata information for each of the ids returned via Apple lookup API together with a simple aggregation functionality.

# Setup

To setup the app you must first configure the config/database.yml and then run the following command:

rake setup

# Usage

To start the server you can run:

rackup

# Routes

The API has the following routes:

  - Rankings:
    http://localhost:9292/api/rankings/:category_id/:monetization

  - Apps:
    http://localhost:9292/api/apps/:category_id/:monetization/:rank

  - Publishers:
    http://localhost:9292/api/publishers/:category_id/:monetization
