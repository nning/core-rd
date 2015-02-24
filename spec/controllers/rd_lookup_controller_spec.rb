require 'rails_helper'

describe RdLookupController do
  describe 'GET #lookup' do
    context 'mandatory parameters' do
      it 'type missing' do
        expect { get :lookup }.to \
          raise_error(ActionController::UrlGenerationError)

        expect { get :lookup, type: nil }.to \
          raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'wrong type' do
      it 'empty' do
        get :lookup, type: ''
        expect(response.status).to eq(4.00)
      end

      it 'non existent' do
        get :lookup, type: 'foo'
        expect(response.status).to eq(4.00)
      end
    end

    context 'type res' do
      context 'empty' do
        it 'rt missing' do
          get :lookup, type: 'res'
          expect(response.status).to eq(4.04)
        end

        it 'rt present' do
          get :lookup, type: 'res', rt: 'test'
          expect(response.status).to eq(4.04)
        end
      end

      context 'results' do
        before do
          create(:target_attribute, type: 'rt', value: 'temperature')
          create(:target_attribute, type: 'if', value: 'urn:sensor:celsius')
        end

        it 'rt' do
          get :lookup, type: 'res', rt: 'temperature'
          expect(response.status).to eq(2.05)
          expect(response.body).to match(/rt=\"temperature\"$/)
        end

        it 'if' do
          get :lookup, type: 'res', if: 'urn:sensor:celsius'
          expect(response.status).to eq(2.05)
          expect(response.body).to match(/if=\"urn:sensor:celsius\"$/)
        end
      end
    end

    # context 'type ep' do
    #   context 'results' do
    #     it 'et' do
    #       get :lookup, type: 'ep', et: 'power-node'
    #       expect(response.status).to eq(2.05)
    #     end
    #   end
    # end
  end
end
