require 'rails_helper'

describe TypedLink, type: :model do
  context '#to_link' do
    let(:attr)   { FactoryGirl.create(:target_attribute) }
    let(:parsed) { CoRE::Link.parse(attr.typed_link.to_link) }

    it { expect(parsed).to be_a(CoRE::Link) }
    it { expect(parsed.uri).to match(/\/test[0-9]+/) }
    it { expect(parsed.send(attr.type.to_sym)).to eq(attr.value) }
  end

  context '.to_link' do
    let(:n) { rand(5..14) }

    let(:string) { links.to_link }
    let(:parsed) { CoRE::Link.parse_multiple(string) }

    before { n.times { create(:typed_link) } }

    context 'all' do
      let(:links) { TypedLink.all }

      it { expect(parsed.size).to eq(n) }
      it { expect(parsed.map(&:uri)).to eq(links.pluck(:path)) }
    end

    context 'where' do
      before { 3.times { create(:typed_link, path: '/foo') } }

      let(:links) { TypedLink.where(path: '/foo') }

      it { expect(parsed.size).to eq(3) }
      it { expect(parsed.map(&:uri)).to eq(links.pluck(:path)) }
    end
  end

  context '.filter' do
    pending
  end
end
