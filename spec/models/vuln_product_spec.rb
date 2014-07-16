require_relative '../../app/models/vuln_product'

describe VulnProduct do
  it "returns the passed in version" do
    version = VulnProduct.new('test software', '1.0.1').version
    expect(version).to eq('1.0.1')
  end

  it "returns an empty array with no companies" do
    companies = VulnProduct.new('test software' , '1.0').companies
    expect(companies).to be_empty 
  end

  it "returns an empty array with no products" do
    products = VulnProduct.new('test software' , '1.0').products
    expect(products).to be_empty 
  end

  context "with java" do
    subject { VulnProduct.new('Oracle Java', nil) }

    it "returns sun and oracle for the companies" do
      expect(subject.companies).to eq(['sun', 'oracle'])
    end

    it "returns jdk and jre for the products" do
      expect(subject.products).to eq(['jdk', 'jre']) 
    end
  end

  context "with flash" do
    subject { VulnProduct.new('Adobe Flash', nil) }

    it "returns macromedia for the company" do
      expect(subject.companies).to eq(['macromedia'])
    end

    it "returns flash & flash player for the products" do
      expect(subject.products).to eq(['flash', 'flash player']) 
    end
  end

  context "with reader" do
    subject { VulnProduct.new('Adobe Reader', nil) }

    it "returns adobe for the company" do
      expect(subject.companies).to eq(['adobe'])
    end

    it "returns reader & acrobat reader for the products" do
      expect(subject.products).to eq(['reader', 'acrobat reader']) 
    end
  end

  context "with shockwave" do
    subject { VulnProduct.new('Adobe Shockwave', nil) }

    it "returns adobe for the company" do
      expect(subject.companies).to eq(['adobe'])
    end

    it "returns shockwave player for the product" do
      expect(subject.products).to eq(['shockwave player']) 
    end
  end

  context "with quicktime" do 
    subject { VulnProduct.new('Apple Quicktime', nil) }

    it "returns apple for the company" do
      expect(subject.companies).to eq(['apple'])
    end

    it "returns quicktime for the product" do
      expect(subject.products).to eq(['quicktime']) 
    end
  end

  context "with realplayer" do
    subject { VulnProduct.new('RealPlayer', nil) }

    it "returns realnetworks for the company" do
      expect(subject.companies).to eq(['realnetworks'])
    end

    it "returns realplayer for the product" do
      expect(subject.products).to eq(['realplayer']) 
    end
  end

  context "with silverlight" do
    subject { VulnProduct.new('Microsoft Silverlight', nil) }

    it "returns microsoft for the company" do
      expect(subject.companies).to eq(['microsoft'])
    end

    it "returns silverlight for the product" do
      expect(subject.products).to eq(['silverlight']) 
    end
  end

  context "with vlc" do
    subject { VulnProduct.new('VLC Player', nil) }

    it "returns videolan for the company" do
      expect(subject.companies).to eq(['videolan'])
    end

    it "returns vlc and vlc media player for the products" do
      expect(subject.products).to eq(['vlc', 'vlc media player']) 
    end
  end

  context "with windows media player" do
    subject { VulnProduct.new('Windows Media Player', nil) }

    it "returns microsoft and windows for the companies" do
      expect(subject.companies).to eq(['microsoft', 'windows'])
    end

    it "returns windows media player and media player for the products" do
      expect(subject.products).to eq(['windows media player', 'media player']) 
    end
  end
end
