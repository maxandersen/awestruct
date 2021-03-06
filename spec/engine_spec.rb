
require 'awestruct/engine'

require 'hashery/open_cascade'

describe Awestruct::Engine do

  it "should be able to load site.yml with the correct profile" do
    config = Awestruct::Config.new( File.dirname(__FILE__) + '/test-data/engine' )

    engine = Awestruct::Engine.new(config)
    engine.load_site_yaml( 'development' )
    engine.site.cook.should == 'microwave'
    engine.site.title.should == 'Awestruction!'

    engine = Awestruct::Engine.new(config)
    engine.load_site_yaml( 'production' )
    engine.site.cook.should == 'oven'
    engine.site.title.should == 'Awestruction!'
  end

  it "should be able to load arbitrary _config/*.yml files" do
    config = Awestruct::Config.new( File.dirname(__FILE__) + '/test-data/engine' )

    engine = Awestruct::Engine.new(config)
    engine.load_yaml( File.join( config.dir,  '_config/arbitrary.yml' ) )
    engine.site.arbitrary.name.should == 'randomness'
  end

  it "should be able to load all arbitary yamls" do
    config = Awestruct::Config.new( File.dirname(__FILE__) + '/test-data/engine' )

    engine = Awestruct::Engine.new(config)
    engine.load_yamls

    engine.site.arbitrary.name.should == 'randomness'
    engine.site.other.tags.should == [ 'a', 'b', 'c' ]
  end

  it "should exclude line comments in compass by default in production mode" do
    compass = compass_config
    config = Awestruct::Config.new( File.dirname(__FILE__) + '/test-data/engine' )
    engine = Awestruct::Engine.new(config)
    engine.load_site_yaml( 'production' )
    Compass.stub(:configuration).and_return(compass)
    compass.should_receive(:line_comments=).with(false)
    engine.configure_compass
  end

  it "should include line comments in compass by default in development mode" do
    compass = compass_config
    config = Awestruct::Config.new( File.dirname(__FILE__) + '/test-data/engine' )
    engine = Awestruct::Engine.new(config)
    engine.load_site_yaml( 'development' )
    Compass.stub(:configuration).and_return(compass)
    compass.should_receive(:line_comments=).with(true)
    engine.configure_compass
  end

  it "should accept site.compass_line_comments to configure behavior" do
    compass = compass_config
    config = Awestruct::Config.new( File.dirname(__FILE__) + '/test-data/engine' )
    engine = Awestruct::Engine.new(config)
    engine.load_site_yaml( 'staging' )
    Compass.stub(:configuration).and_return(compass)
    compass.should_receive(:line_comments=).with(false)
    engine.configure_compass
  end

end

def compass_config
  config = mock
  config.stub(:project_type=)
  config.stub(:project_path=)
  config.stub(:sass_dir=)
  config.stub(:css_dir=)
  config.stub(:javascripts_dir=)
  config.stub(:images_dir=)
  config
end
