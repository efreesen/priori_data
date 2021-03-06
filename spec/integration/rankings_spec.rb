describe PrioriData::Integration::Rankings do
  let(:instance) { described_class.new }

  before do
    app = OpenStruct.new(publisher_id: 303585709)

    allow(PrioriData::Repositories::App).to receive(:find).and_return(app)
  end

  describe '#import' do
    context 'when service is available' do
      context 'and response is success' do
        subject do
          VCR.use_cassette("apple_rankings_success") do
            instance.import(6001)
          end
        end

        after do
          subject
        end

        it 'maps rankings' do
          expect_any_instance_of(described_class).to receive(:map_rankings)
        end
      end

      context 'and response is failure' do
        subject do
          VCR.use_cassette("apple_rankings_failure") do
            instance.import(6001)
          end
        end

        after do
          subject
        end

        it 'logs the error' do
          expect(PrioriData::DataLogger).to receive(:error).with('      - Request returned an error importing Rankings data from category 6001: status: 404.')
        end
      end
    end

    context 'when service is not available' do
      subject { instance.import(6001) }

      before do
        allow(HTTParty).to receive(:get).and_raise(Errno::EHOSTUNREACH)
      end

      after do
        subject
      end

      it 'logs the error' do
        expect(PrioriData::DataLogger).to receive(:error).with('      - Apple Service not available. Could not import Rankings data for category 6001.')
      end
    end
  end

  describe '#map_rankings' do
    after do
      subject
    end

    context 'with a test JSON' do
      let(:json) do 
        {
          "genre" => { "name" => "Genre Name" },
          "topCharts" => [
            {
              "adamIds" => [327193945],
              "shortTitle"   => "Paid"
            }
          ]
        }
      end

      subject do
        VCR.use_cassette("apple_rankings_single_app") do
          instance.map_rankings(json)
        end
      end

      before do
        allow(PrioriData::Repositories::Ranking).to receive(:persist)
      end

      it 'creates an app' do
        expect(PrioriData::Integration::Apps).to receive(:import).with([327193945]).and_call_original
      end

      it 'creates a ranking' do
        expect(PrioriData::Repositories::Ranking).to receive(:persist).with(nil, :paid, 1, 327193945, 303585709)
      end
    end

    context 'with a real JSON' do
      let(:json) do 
        JSON.parse '{"footerCrumbs":[{"label":"iTunes Store","url":"https://itunes.apple.com/us/store"},{"label":"App Store","url":"https://itunes.apple.com/us/genre/ios/id36?mt=8"},{"label":"Weather","url":"https://itunes.apple.com/us/genre/ios-weather/id6001?mt=8"},{"label":"Top Paid iPhone Apps","url":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?cc=us&genreId=6001&popId=30"}],"allGenresUrl":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?cc=us&genreId=36&popId=30","genre":{"name":"Weather","id":"6001","url":"https://itunes.apple.com/us/genre?id=6001"},"topCharts":[{"adamIds":["749133301","517329357","325683306","458225159","526831380","327193945","348618445","291430598","749078962","316415412","503757271","395148744","379869627","601606659","1020486527","459707387","348779486","288419283","426939660","467953363","401533966","649246860","505555988","695709241","485251405","958363882","336901296","292148184","479752016","649202100","961390574","417906074","546298468","294631159","410148139","460455088","287526650","465367975","482361332","460412892","382372588","739808997","528922569","497236102","495546638","445801759","579300320","628531466","310078711","415411639","949017360","305708971","827141249","547094769","821205322","886074803","698744759","495511938","516492507","471629622","904822956","482617382","769602146","945662966","661007567","916416931","650561613","978312542","284625154","442814223","594476963","335189604","306657027","556002847","467953321","490779008","294937581","516387961","572819275","318572643","312811399","513879979","417401887","373913405","486079607","366765248","362310884","659288660","434826116","464595524","611597262","647032797","975746713","497167406","346459810","917857630","961644736","343198153","608515289","412396957","419048258","584709151","527887046","547162979","413208244","931212644","413511993","992351930","547642997","361098444","533671562","430227107","912250293","839923054","593296099","419841529","489771210","465111766","456314120","608876851","572579876","1019327791","557872119","314819528","545627378","343527016","429394638","400259071","422679615","489821949","338667601","464199989","572864697","840157711","310755546","975770717","558257741","481404568","802517287","306867078","533816298","916760091","817932940","808357406","592644945","887768977","1020454965","314502416","893902568","306375551","375928259","572757152","888227320","951057136","491537291","715319015","398101772","488674899","541592394","552825440","539498084","986999294","780216906","871812944","434371487","611039652","611593913","397123729","454643891","663532889","371674047","688141190","822251895","952284499","403692190","416571494","284145181","460049357","885142714","903697721","897511324","364193735","512607963","486059426","284908756","314841443","413928923","306861907","406279838","509594468","710433569","547046983","482498256","574392006","539587329","447112326","405215559","547934690","375584450","968227562"],"seeAllUrl":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?cc=us&genreId=6001&popId=30","kinds":{"iosSoftware":true},"shortTitle":"Paid","id":"30","title":"Top Paid iPhone Apps","isTracklistChart":false},{"adamIds":["295646461","300048137","322439990","749133753","281940292","955957721","635638808","486154808","749083919","649264704","628677149","549890546","942413257","600105016","910608181","425914352","537308269","527705255","585223877","545689128","910660621","520581935","574503122","526785825","660036257","500182129","483922001","393782096","671352640","945662980","535224994","491024736","697766074","1020486515","634139673","493972179","414215658","909189320","364884105","437519442","533796437","897521658","404516121","957143504","542752476","454069957","561206553","954783878","1027116507","414910977","537403620","593308377","379529231","626468735","403037266","638426680","706159334","508798735","322103952","666995618","624566209","586488492","528732981","632706915","552826195","962146621","735214029","323711282","1029598507","506375544","1027125968","413007835","585726025","586377264","497489376","554438153","336829635","406162876","546817216","925774376","473299958","952022603","413543765","952638250","639846664","762861353","493299360","413536573","388481318","570219530","575673047","555644333","415950922","780748936","529051002","467154094","494652642","418407216","498022792","571826961","602724318","386964232","368497728","859015438","564147490","634132246","777280890","471314510","1011397030","333252638","686478938","395928613","923043780","975709372","434215893","418598616","467653238","413063856","632040358","1027134404","317992025","421110714","823413326","415720975","555309964","918604723","935459156","574495530","526819635","413107327","617987198","646719781","470656567","535841520","706159479","1007010544","899207547","447145667","527637646","889955060","539875792","971333907","412489722","428539534","386355471","418960096","397676100","625333002","638418843","469917266","438788905","455537046","662297095","523866851","566578123","368497309","415962807","625317512","515673004","531791266","922579578","320298020","368193439","696014681","871183277","557946227","1027136885","967504608","419168262","441551189","419674635","961406520","597793934","910010496","903685327","470909765","582758517","619814752","542487199","432169383","515816615","521720287","935421509","537265820","918982887","368499632","469229784","418554305","638063847","897852345","729430189","907141086","460066042","935402347","405100477","542875991","908912731","396524653","471325171","413112585"],"seeAllUrl":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?cc=us&genreId=6001&popId=27","kinds":{"iosSoftware":true},"shortTitle":"Free","id":"27","title":"Top Free iPhone Apps","isTracklistChart":false},{"adamIds":["333252638","322439990","517329357","749133301","325683306","288419283","458225159","445062163","348618445","526831380","327193945","749078962","300048137","291430598","316415412","486154808","503757271","601606659","955957721","379869627","348779486","395148744","505555988","467953363","281940292","958363882","628531466","401533966","735214029","323711282","479752016","961390574","695709241","1020486527","459707387","460412892","284625154","417906074","417401887","410148139","649246860","322103952","294631159","335189604","336901296","382372588","477048487","907141086","292148184","482361332","413511993","426939660","546298468","305708971","460455088","406162876","528922569","287526650","528732981","373913405","465367975","485251405","827141249","634139673","554438153","739808997","649202100","949017360","366765248","547094769","886074803","497236102","495511938","516492507","436760574","419048258","445801759","471629622","671352640","632040358","421110714","594476963","467953321","516387961","481404568","464595524","415411639","564147490","729430189","698744759","859015438","317992025","904822956","482617382","945662966","661007567","585726025","575673047","650561613","978312542","490779008","556002847","572819275","646750653","513879979","908090158","659288660","551571617","611597262","975746713","412489722","593296099","495546638","842428499","429394638","555309964","579300320","572579876","608515289","545993260","572864697","802517287","464199989","539875792","310078711","931212644","821205322","930952204","545375951","361098444","584709151","839923054","953897236","769602146","529047128","916416931","442814223","306657027","294937581","318572643","312811399","486079607","362310884","434826116","647032797","346459810","917857630","961644736","456314120","497167406","343198153","547162979","571826961","557872119","368498727","364193735","403037266","849005193","840157711","823413326","904970843","513766293","923043780","488674899","850417796","992351930","547642997","412396957","533671562","379529231","419841529","489771210","608876851","1019327791","686478938","314819528","619814752","545627378","400259071","555644333","527887046","395928613","422679615","975770717","916760091","1011691256","572757152","413208244","491537291","833507132","430227107","531791266","912250293","715319015","592644945","371674047","465111766","1020454965","933439687","343527016"],"seeAllUrl":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?cc=us&genreId=6001&popId=38","kinds":{"iosSoftware":true},"shortTitle":"Top Grossing","id":"38","title":"Top Grossing iPhone Apps","isTracklistChart":false}],"selectedChart":{"adamIds":["749133301","517329357","325683306","458225159","526831380","327193945","348618445","291430598","749078962","316415412","503757271","395148744","379869627","601606659","1020486527","459707387","348779486","288419283","426939660","467953363","401533966","649246860","505555988","695709241","485251405","958363882","336901296","292148184","479752016","649202100","961390574","417906074","546298468","294631159","410148139","460455088","287526650","465367975","482361332","460412892","382372588","739808997","528922569","497236102","495546638","445801759","579300320","628531466","310078711","415411639","949017360","305708971","827141249","547094769","821205322","886074803","698744759","495511938","516492507","471629622","904822956","482617382","769602146","945662966","661007567","916416931","650561613","978312542","284625154","442814223","594476963","335189604","306657027","556002847","467953321","490779008","294937581","516387961","572819275","318572643","312811399","513879979","417401887","373913405","486079607","366765248","362310884","659288660","434826116","464595524","611597262","647032797","975746713","497167406","346459810","917857630","961644736","343198153","608515289","412396957","419048258","584709151","527887046","547162979","413208244","931212644","413511993","992351930","547642997","361098444","533671562","430227107","912250293","839923054","593296099","419841529","489771210","465111766","456314120","608876851","572579876","1019327791","557872119","314819528","545627378","343527016","429394638","400259071","422679615","489821949","338667601","464199989","572864697","840157711","310755546","975770717","558257741","481404568","802517287","306867078","533816298","916760091","817932940","808357406","592644945","887768977","1020454965","314502416","893902568","306375551"],"seeAllUrl":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?cc=us&genreId=6001&popId=30","kinds":{"iosSoftware":true},"shortTitle":"Paid","id":"30","title":"Top Paid iPhone Apps","isTracklistChart":false},"navTitle":"Top Charts","genres":[{"name":"Books","id":"6018","url":"https://itunes.apple.com/us/genre?id=6018"},{"name":"Business","id":"6000","url":"https://itunes.apple.com/us/genre?id=6000"},{"name":"Catalogs","id":"6022","url":"https://itunes.apple.com/us/genre?id=6022"},{"name":"Education","id":"6017","url":"https://itunes.apple.com/us/genre?id=6017"},{"name":"Entertainment","id":"6016","url":"https://itunes.apple.com/us/genre?id=6016"},{"name":"Finance","id":"6015","url":"https://itunes.apple.com/us/genre?id=6015"},{"name":"Food & Drink","id":"6023","url":"https://itunes.apple.com/us/genre?id=6023"},{"name":"Games","id":"6014","url":"https://itunes.apple.com/us/genre?id=6014"},{"name":"Health & Fitness","id":"6013","url":"https://itunes.apple.com/us/genre?id=6013"},{"name":"All Ages","ageBandId":0,"id":"36","ageBandGenreName":"Kids"},{"name":"Lifestyle","id":"6012","url":"https://itunes.apple.com/us/genre?id=6012"},{"name":"Medical","id":"6020","url":"https://itunes.apple.com/us/genre?id=6020"},{"name":"Music","id":"6011","url":"https://itunes.apple.com/us/genre?id=6011"},{"name":"Navigation","id":"6010","url":"https://itunes.apple.com/us/genre?id=6010"},{"name":"News","id":"6009","url":"https://itunes.apple.com/us/genre?id=6009"},{"name":"Newsstand","id":"6021","url":"https://itunes.apple.com/us/genre?id=6021"},{"name":"Photo & Video","id":"6008","url":"https://itunes.apple.com/us/genre?id=6008"},{"name":"Productivity","id":"6007","url":"https://itunes.apple.com/us/genre?id=6007"},{"name":"Reference","id":"6006","url":"https://itunes.apple.com/us/genre?id=6006"},{"name":"Social Networking","id":"6005","url":"https://itunes.apple.com/us/genre?id=6005"},{"name":"Sports","id":"6004","url":"https://itunes.apple.com/us/genre?id=6004"},{"name":"Travel","id":"6003","url":"https://itunes.apple.com/us/genre?id=6003"},{"name":"Utilities","id":"6002","url":"https://itunes.apple.com/us/genre?id=6002"},{"name":"Weather","id":"6001","url":"https://itunes.apple.com/us/genre?id=6001"}]}'
      end

      subject do
        VCR.use_cassette("apple_rankings_apps") do
          instance.map_rankings(json)
        end
      end

      it 'persists data for the 3 ranking lists' do
        expect_any_instance_of(described_class).to receive(:persist_data).exactly(3)
      end
    end
  end

  describe '#persist_data' do
    let(:monetization) { :grossing }

    subject { instance.persist_data(monetization, app_ids_batch) }

    after { subject }

    context 'when the batch is empty' do
      let(:app_ids_batch) { [] }

      it 'imports no app' do
        expect(PrioriData::Integration::Apps).not_to receive(:import)
      end

      it 'creates no ranking' do
        expect(PrioriData::Repositories::Ranking).not_to receive(:persist)
      end
    end

    context 'when the batch has elements' do
      context 'and app_id has a correlated publisher_id' do
        let(:app_ids_batch) { [1, 2, 3] }
        let(:publisher_ids) { {"1" => 10, "2" => 20, "3" => 30} }

        before do
          allow(PrioriData::Integration::Apps).to receive(:import).with(app_ids_batch).and_return(publisher_ids)
          allow(PrioriData::Repositories::Ranking).to receive(:persist)
        end

        it 'imports apps' do
          expect(PrioriData::Integration::Apps).to receive(:import).with(app_ids_batch).and_return(publisher_ids)
        end

        it 'creates a ranking with valid attributes' do
          expect(PrioriData::Repositories::Ranking).to receive(:persist).with(nil, monetization, 2, 2, 20).at_least(:once)
        end
      end

      context 'and app_id has no correlated publisher_id' do
        let(:app_ids_batch) { [1] }
        let(:publisher_ids) { {"2" => 20} }

        before do
          allow(PrioriData::Integration::Apps).to receive(:import).with(app_ids_batch).and_return(publisher_ids)
          allow(PrioriData::Repositories::Ranking).to receive(:persist)
        end

        it 'imports apps' do
          expect(PrioriData::Integration::Apps).to receive(:import).with(app_ids_batch).and_return(publisher_ids)
        end

        it 'does not create a ranking' do
          expect(PrioriData::Repositories::Ranking).not_to receive(:persist)
        end
      end
    end
  end
end
