# frozen_string_literal: false

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Integration Tests of Youtube API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store video data to database' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to create a feed object from Youtube and save the info to database' do
      feed = HeadlineConnector::Youtube::FeedMapper
        .new(YOUTUBE_TOKEN)
        .find(VIDEO_ID)

      rebuilt = HeadlineConnector::Repository::For.entity(feed).create(feed)

      _(rebuilt.feed_id).must_equal(feed.feed_id)
      _(rebuilt.feed_title).must_equal(feed.feed_title)
      _(rebuilt.description).must_equal(feed.description)
      _(rebuilt.tags).must_equal(feed.tags)
      _(rebuilt.provider.provider_id).must_equal(feed.provider.provider_id)
      _(rebuilt.provider.provider_title).must_equal(feed.provider.provider_title)
    end
  end
end
