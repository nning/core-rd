require 'rails_helper'

describe CoreController do
  describe 'GET #index' do
    context 'empty' do
      it '404' do
        get :index
        expect(response).to have_http_status(404)
      end

      it '404 filtered' do
        create(:target_attribute)
        get :index, rt: 'foo'
        expect(response).to have_http_status(404)
      end
    end

    context 'unfiltered' do
      before do
        5.times { create(:target_attribute) }
        
        get :index
      end

      it '200' do
        expect(response).to have_http_status(200)
      end

      it 'assignes' do
        expect(assigns(:links)).to be_a(ActiveRecord::Relation)
        expect(assigns(:links)).not_to be_empty
        expect(assigns(:links).size).to eq(5)
      end

      it 'parsed' do
        links = CoRE::Link.parse_multiple(response.body)

        expect(links.size).to eq(5)
        
        links.each do |link|
          expect(link.uri).to match(/\/test[0-9]+/)
          expect(link.rt).to eq('test')
        end
      end
    end

    context 'filtered' do
      context 'one attribute' do
        let!(:a) { create(:target_attribute) }
        let!(:b) { create(:target_attribute, type: 'rt', value: 'a') }

        before  { get :index, rt: 'a' }

        it '200' do
          expect(response).to have_http_status(200)
        end

        it 'assignes' do
          expect(assigns(:links)).to be_a(ActiveRecord::Relation)
          expect(assigns(:links)).to eq([b.typed_link])
        end

        it 'body' do
          expect(response.body).to match(/\<\/test[0-9]+>;rt="a"/)
        end

        it 'parsed' do
          links = CoRE::Link.parse_multiple(response.body)

          expect(links.size).to eq(1)

          expect(links[0].uri).to match(/\/test[0-9]+/)
          expect(links[0].rt).to eq('a')
        end
      end

      context 'two attributes' do
        let!(:a) { create(:target_attribute, type: 'rt', value: 'a') }
        let!(:b) { create(:target_attribute, type: 'rt', value: 'b') }
        let!(:c) { create(:target_attribute, type: 'if', value: 'c',
                     typed_link: b.typed_link) }

        before { get :index, rt: 'b', if: 'c' }

        it '200' do
          expect(response).to have_http_status(200)
        end

        it 'assignes' do
          expect(assigns(:links)).to be_a(ActiveRecord::Relation)
          expect(assigns(:links)).to eq([b.typed_link])
        end

        it 'body' do
          expect(response.body).to match(/\<\/test[0-9]+>;if="c";rt="b"/)
        end

        it 'parsed' do
          links = CoRE::Link.parse_multiple(response.body)

          expect(links.size).to eq(1)

          expect(links[0].uri).to match(/\/test[0-9]+/)
          expect(links[0].rt).to eq('b')
          expect(links[0].if).to eq('c')
        end
      end

      context 'wildcard' do
        let!(:a) { create(:target_attribute, type: 'rt', value: 'core.rd') }
        let!(:b) { create(:target_attribute, type: 'rt', value: 'core.rd-group') }
        let!(:c) { create(:target_attribute, type: 'rt', value: 'core.rd-lookup') }

        before { get :index, rt: 'core.rd*' }

        it '200' do
          expect(response).to have_http_status(200)
        end

        it 'assignes' do
          expect(assigns(:links)).to be_a(ActiveRecord::Relation)
          expect(assigns(:links)).to eq([a, b, c].map(&:typed_link))
        end

        it 'parsed' do
          links = CoRE::Link.parse_multiple(response.body)

          expect(links.size).to eq(3)
          expect(links.map(&:rt)).to eq(%w[core.rd core.rd-group core.rd-lookup])
        end
      end
    end
  end
end
