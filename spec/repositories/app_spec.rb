describe PrioriData::Repositories::App do
  describe '.persist' do
    context 'when params are not passed' do
      subject { described_class.persist() }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when params are nil' do
      subject { described_class.persist(nil) }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when params are empty' do
      subject { described_class.persist({}) }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when params are valid' do
      let(:app) { App.new }
      let(:json) do
        {
          "artworkUrl60" => "http://is1.mzstatic.com/image/thumb/Purple6/v4/82/01/b0/8201b0dd-ca5b-1a28-0469-2458f8ad4d4c/AppIcon57x57.png/0x0ss-85.jpg",
          "averageUserRatingForCurrentVersion" => 4.5,
          "currency" => "USD",
          "version" => "4.2",
          "artistId" => 303585709,
          "artistName" => "EZ Apps, Inc.",
          "price" => 2.99,
          "description" => "*Come join us and follow TS Erika in depth with blog posts, audio updates and much more.*\n\n6 years of tracking storms on iOS! Debuted Aug 2009! Visit www.hurrtracker.com for more info. Web access is also available for your MAC/PC. There is also a version available for iPhone/iPod Touch.\n\nReviewed by CNN as the best Hurricane Tracking app available for iPhone GOOGLE: \"cnn top hurricane app\" to read the article! \n\nHurricane Tracker is the most used & most comprehensive tracking app available on any platform. What makes Hurricane Tracker different from the others in the App Store:\n\n-Daily audio tropical updates\n-Exclusive Long Range Threat Graphic with percentages\n-Exclusive “Model Watch” product - check often to see what might develop next. Stay ahead of the storm\n-Custom graphics from our team of experts. Exclusive “Alert Level” & “Impact Potential” maps. Not just basic NHC info.\n-65+ maps/images\n-Push alerts when a new storm forms/intensifies\n-Storm video updates\n-In-depth written discussions\n-Real time National Hurricane Center Updates (All NHC advisories & maps)\n-Share information with friends/family via email, SMS, Facebook & Twitter\n-Super detailed tropical wave/invest information\n-Storm history from the NHC\n-NOAA weather radio\n-Dozens of satellites\n-Much more!\n\nThere is no other Hurricane app out there that can match the amount of information you get-we guarantee it. Get the information you need to make informed decisions. Just look at our ratings for all versions over 6 years. 4.5 star average! We charge for our app because it’s not just an automated product, our team is constantly creating graphics & writing detailed discussions. This is our full time job - keeping you informed.\n\nHurricane Tracker covers The Gulf of Mexico, Caribbean, Atlantic Ocean & Eastern Pacific. Our app also covers any storms that may affect Hawaii.\n\nWHAT ARE THEY SAYING: \n\n*Houston Press: \"Finally, there is Hurricane Tracker. This app may have the best interface of the bunch, with a sliding set of navigation buttons at the bottom of the screen. This one, unlike either of the others, has audio and video updates\" \n\n*Email from Customer Scott DeLacy: \"With the new maps under Outlook, you have SURPASSED everyone else out there...Hurricane Tracker is now British Virgin Islands Airways' primary tropical data source, No one comes close.\" \n\n*Valued Customer Ray 007: \"As good a review as you can give a service!\" \n\n*Valued Customer Dale Gattis: \"I've been using this and Hurricane for the last two years and I have really come to rely on this app exclusively. Excellent!\" \n\nCONTACT US WITH ANY QUESTIONS: \n\nWeb: www.hurrtracker.com \n\nEmail: support@ezappsinc.com \n\nTwitter: @hurrtrackerapp (live, real time updates)\n\n*Hurricane Tracker is an extremely data intensive application. A WiFi or strong cellular signal is recommended for the best experience.",
          "trackId" => 327193945,
          "trackName" => "Hurricane Tracker",
          "averageUserRating" => 4.5,
          "userRatingCount" => 3857
        }
      end
      let(:attributes) do
        {
          external_id: json["trackId"],
          name: json["trackName"],
          description: ActiveSupport::Inflector.transliterate(json["description"]),
          small_icon_url: json["artworkUrl60"],
          publisher_id: json["artistId"],
          price: json["price"],
          version: json["version"],
          average_user_rating: json["averageUserRating"]
        }
      end
      
      context 'and app is not found' do
        subject { described_class.persist(json) }

        before do
          allow(App).to receive(:first_or_initialize).and_return(app)
        end

        after do
          subject
        end

        it 'searches for existing category with same id' do
          expect(App).to receive(:where).with(external_id: 327193945).and_call_original
        end

        it 'creates category or updates it`s attributes' do
          expect(app).to receive(:update_attributes).with(attributes)
        end
      end
    end
  end

  describe '.find' do
    let(:id) { 1000 }

    subject { described_class.find(id) }

    after do
      subject
    end

    it 'calls where on model class' do
      expect(App).to receive(:where).with(external_id: id).and_call_original
    end
  end
end
