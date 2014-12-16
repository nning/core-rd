require 'rails_helper'

RSpec.describe CoreController, type: :controller do
  describe 'GET #index' do
    context 'empty' do
      it '404' do
        get :index
        expect(response).to have_http_status(404)
      end

      it '404 filtered' do
        FactoryGirl.create(:target_attribute)
        get :index, rt: 'foo'
        expect(response).to have_http_status(404)
      end
    end

    context 'unfiltered' do
      before do
        FactoryGirl.create(:target_attribute)
        FactoryGirl.create(:target_attribute)
        
        get :index
      end

      it '200' do
        expect(response).to have_http_status(200)
      end

      it 'body' do
        expect(response.body).to eq('</test>;rt="test",</test>;rt="test"')
      end
    end

    context 'filtered' do
      before do
        FactoryGirl.create(:target_attribute)
        FactoryGirl.create(:target_attribute, type: 'rt', value: 'foo')

        get :index, rt: 'foo'
      end

      it '200' do
        expect(response).to have_http_status(200)
      end

      it 'body' do
        expect(response.body).to eq('</test>;rt="foo"')
      end
    end
  end
end
