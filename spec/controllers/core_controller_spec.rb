require 'rails_helper'

describe CoreController, type: :controller do
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
        before do
          a = create(:target_attribute)
          b = create(:target_attribute, type: 'rt', value: 'a')

          get :index, rt: 'a'
        end

        it '200' do
          expect(response).to have_http_status(200)
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
        before do
          a = create(:target_attribute, type: 'rt', value: 'a')
          b = create(:target_attribute, type: 'rt', value: 'b')
          c = create(:target_attribute, type: 'if', value: 'c',
            typed_link: b.typed_link)

          get :index, rt: 'b', if: 'c'
        end

        it '200' do
          expect(response).to have_http_status(200)
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
        before do
          a = create(:target_attribute, type: 'rt', value: 'core.rd')
          b = create(:target_attribute, type: 'rt', value: 'core.rd-group')
          c = create(:target_attribute, type: 'rt', value: 'core.rd-lookup')

          get :index, rt: 'core.rd*'
        end

        it '200' do
          expect(response).to have_http_status(200)
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
